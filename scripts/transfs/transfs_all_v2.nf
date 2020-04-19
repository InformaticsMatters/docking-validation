#!/usr/bin/env nextflow

/* Nextflow pipeline that runs Docking using rDock and scores ligands using TransFS and SuCOS
*/

params.ligands = '../enumerated_chunk_*.sdf'
params.hits = '../../hits.sdf'
params.protein_pdb = 'receptor.pdb'
params.protein_mol2 = 'receptor.mol2'
params.prmfile = 'docking-local.prm'
params.asfile =  'docking-local.as'
params.limit = 0
params.num_dockings = 25
params.mock = false

params.num_gpus = 'all'
params.max_forks = 1

prmfile = file(params.prmfile)
hits = file(params.hits)
protein_pdb = file(params.protein_pdb)
protein_mol2 = file(params.protein_mol2)
asfile  = file(params.asfile)


ligands = Channel.fromPath(params.ligands)
    .flatten()


/* Docks each file from the ligand_parts channel sending each resulting SD file to the results channel
*/
process pose_generation {

    container 'informaticsmatters/rdock-mini:latest'
    errorStrategy 'retry'
    maxRetries 3

    input:
    file part from ligands
    file protein_mol2
    file prmfile
    file asfile

    output:
    file 'docked_*.sd' into docked_parts

    """
    rbdock -i $part -r $prmfile -p dock.prm -n $params.num_dockings -o ${part.name.replace('_part_', '_part_docked')[0..-5]} > docked_out.log
    rbdock -i $part -r $prmfile -p dock.prm -n $params.num_dockings -o docked_${part.name[0..-5]} > docked_out.log
    """
}

process score_sucos {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file docked_parts
    file hits

    output:
    file 'sucos_*.sdf' into sucos_scored

    """
    python -m pipelines.rdkit.sucos_max -i $docked_parts -if sdf --target-molecules $hits --targets-format sdf -o sucos_$docked_parts -of sdf --name-field _Name --no-gzip
    """
}

/* Filters the scored poses
*/
process filter_sucos {

	container 'informaticsmatters/rdock-mini:latest'

	input:
	file sucos_scored

	output:
	file 'filt_*.sdf' into filt_sucos

	"""
	sdfilter -f'\$SuCOS_Max_Score > 0.3' $sucos_scored > filt_${sucos_scored}
	"""
}

/* Scores the poses the deep learning.
* Use the 'mock' param to use random scores rather than run of GPU
*/
process score_transfs {

    container 'informaticsmatters/transfs:1.3'
    containerOptions params.mock ? '' : "--gpus $params.num_gpus"
    maxForks params.max_forks

    input:
    file filt_sucos
    file 'receptor.pdb' from protein_pdb

    output:
    file 'tfs_*.sdf' into scored_transfs

    """
    base=\$PWD
    mv $filt_sucos ligands.sdf
    cd /train/fragalysis_test_files/
    python transfs.py -i \$base/ligands.sdf -r \$base/receptor.pdb -d 0 -w \$base/tfs ${params.mock ? '--mock' : ''}
    mv \$base/tfs/output.sdf \$base/tfs_${filt_sucos}
    """
}

/* Sorts the poses of each molecule by the deep learning score and keep the best one.
*/
process collect_transfs {

    container 'informaticsmatters/rdock-mini:latest'
    publishDir '.', mode: 'link'

    input:
    file parts from scored_transfs.collect()

    output:
    file 'results.sdf.gz'

    """
    cat $parts | gzip > results.sdf.gz
    """
}

