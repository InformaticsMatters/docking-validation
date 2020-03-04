#!/usr/bin/env nextflow

/* Example Nextflow pipeline that runs Docking using rDock
*/

params.ligands = '../chunk_*.sdf'
params.protein = 'receptor.mol2'
params.prmfile = 'docking-local.prm'
params.asfile =  'docking-local.as'
params.chunk = 25
params.limit = 0
params.num_dockings = 25
params.top = 10
params.field = 'SCORE.norm'
params.mock = false


prmfile = file(params.prmfile)
ligands = file(params.ligands)
protein = file(params.protein)
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

    input:
    file part from ligand_parts
    file protein
    file prmfile
    file asfile
	
    output:
    file '*_part_docked*.sd' into docked_parts
    
    """
    rbdock -i $part -r $prmfile -p dock.prm -n $params.num_dockings -o ${part.name.replace('_part_', '_part_docked')[0..-5]} > docked_out.log
    """
}

/* Collects the docked poses and sorts them according to the docking score (the field param) and takes the
* best n (the top param).
*/
process collect_poses {

	container 'informaticsmatters/rdock-mini:latest'

	publishDir '.', mode: 'copy'

	input:
	file parts from docked_parts.collect()

	output:
	file 'poses.sdf' into poses

	"""
	sdsort -n -s -f${params.field} $parts | sdfilter -f'\$_COUNT <= ${params.top}' > poses.sdf
	"""
}

/* Scores the poses the deep learning.
* Use the 'mock' param to use random scores rather than run of GPU
*/
process score_poses {

    container 'informaticsmatters/jackall:latest'
    containerOptions params.mock ? '' : '--gpus all'

    publishDir '.', mode: 'copy'

    input:
    file poses
    file protein

    output:
    file 'scored.sdf' into scored_poses


    """
    base=\$PWD
    cd /train/fragalysis_test_files/
    python xchem_deep_score.py -i \$base/poses.sdf -r \$base/receptor.mol2 -w /tmp ${params.mock ? '--mock' : ''}
    mv /tmp/output.sdf \$base/scored.sdf
    """

}

/* Sorts the poses of each molecule by the deep learning score and keep the best one.
*/
process rank_scores {

    container 'informaticsmatters/rdock-mini:latest'

    publishDir '.', mode: 'copy'

    input:
    file scored_poses

    output:
    file 'results.sdf'

    """
    sdsort -n -r -s -fXChemDeepScore $scored_poses | sdfilter -f'\$_COUNT <= 1' | sdsort -n -r -fXChemDeepScore > results.sdf
    """

}