#!/usr/bin/env nextflow

/* Nextflow pipeline that runs Docking using rDock and scores ligands using TransFS and SuCOS
*/

params.ligands = '../enumerated_chunk_*.sdf'
params.hits = '../../hits.sdf'
params.protein_pdb = 'receptor.pdb'
params.protein_mol2 = 'receptor.mol2'
params.prmfile = 'docking-local.prm'
params.asfile =  'docking-local.as'
params.chunk = 25
params.limit = 0
params.num_dockings = 25
params.field = 'SCORE.norm'
params.mock = false
params.distance = 2.0
params.transfs_chunk = 100000


prmfile = file(params.prmfile)
ligands = file(params.ligands)
hits = file(params.hits)
protein_pdb = file(params.protein_pdb)
protein_mol2 = file(params.protein_mol2)
asfile  = file(params.asfile)


/* Splits the input SD file into multiple files of ${params.chunk_docking} records.
* Each file is sent individually to the ligand_parts channel
*/
process sdsplit {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file ligands

    output:
    file '*_part_*.sdf' into ligand_parts mode flatten

    """
    python -m pipelines_utils_rdkit.filter -i $ligands -if sdf -c $params.chunk -l $params.limit -d 4 -o ${ligands.name[0..-5]}_part_ -of sdf --no-gzip
    """
}


/* Docks each file from the ligand_parts channel sending each resulting SD file to the results channel
*/
process pose_generation {

    container 'informaticsmatters/rdock-mini:latest'
    errorStrategy 'retry'
    maxRetries 3

    input:
    file part from ligand_parts
    file protein_mol2
    file prmfile
    file asfile

    output:
    file '*_part_docked*.sd' into docked_parts

    """
    rbdock -i $part -r $prmfile -p dock.prm -n $params.num_dockings -o ${part.name.replace('_part_', '_part_docked')[0..-5]} > docked_out.log
    """
}

/* Collects the docked poses and sorts them according to the docking score (the field param)
*/
process collect_poses {

	container 'informaticsmatters/rdock-mini:latest'

	//publishDir '.', mode: 'copy'

	input:
	file parts from docked_parts.collect()

	output:
	file 'tfs_in_*.sd' into poses mode flatten

	"""
	sdsort -n -s -f${params.field} $parts | sdsplit -${params.transfs_chunk} -otfs_in_${parts}
	"""
}

/* Scores the poses the deep learning.
* Use the 'mock' param to use random scores rather than run of GPU
*/
process score_transfs {

    container 'informaticsmatters/transfs:latest'
    containerOptions params.mock ? '' : '--gpus all'
    maxForks 1

    publishDir '.', mode: 'copy', pattern: "*.pdb.tgz"

    input:
    file poses
    file protein_pdb

    output:
    file 'scored_tfs_*.sd' into scored_transfs
    file "${poses}-receptors.pdb.tgz"


    """
    base=\$PWD
    cd /train/fragalysis_test_files/
    python transfs.py -i \$base/$poses -r \$base/$protein_pdb -d $params.distance -w /tmp/work ${params.mock ? '--mock' : ''}
    mv /tmp/work/output.sdf \$base/scored_tfs_${poses}
    tar cvfz \$base/${poses}-receptors.pdb.tgz /tmp/work/*.pdb
    """
}

/* Sorts the poses of each molecule by the deep learning score and keep the best one.
*/
process rank_transfs {

    container 'informaticsmatters/rdock-mini:latest'

    input:
    file parts from scored_transfs.collect()

    output:
    file 'ranked_transfs.sdf' into ranked_transfs

    """
    sdsort -n -r -s -fTransFSScore $parts | sdfilter -f'\$_COUNT <= 1' | sdsort -n -r -fTransFSScore > ranked_transfs.sdf
    """
}

process score_sucos {

    container 'informaticsmatters/rdkit_pipelines:latest'

    publishDir '.', mode: 'copy'

    input:
    file ranked_transfs
    file hits

    output:
    file 'scored_sucos.sdf'

    """
    python -m pipelines.rdkit.sucos_max -i $ranked_transfs -if sdf --target-molecules $hits --targets-format sdf -o scored_sucos -of sdf --name-field _Name --no-gzip
    """
}