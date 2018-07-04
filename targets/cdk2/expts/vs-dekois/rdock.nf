#!/usr/bin/env nextflow

/* Example Nextflow pipline that runs Docking using rDock 
*/

params.actives = 'CDK2.sdf.gz'
params.decoys = 'CDK2_Celling-v1.12_decoyset.sdf.gz'
params.protein = 'cdk2_protein.mol2'
params.prmfile = 'cdk2_rdock.prm'
params.asfile =  'cdk2_rdock.as'
params.chunk = 25
params.limit = 0
params.num_dockings = 50
params.top = 5
params.score = null

prmfile = file(params.prmfile)
actives = file(params.actives)
decoys  = file(params.decoys)
protein = file(params.protein)
asfile  = file(params.asfile)

/* Splits the input SD file into multiple files of ${params.chunk} records.
* Each file is sent individually to the ligand_parts channel
*/
process sdsplit {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file actives
    file decoys

    output:
    file 'ligands_part*' into ligand_parts mode flatten
    
    """
    zcat $actives $decoys | python -m pipelines_utils_rdkit.filter -if sdf -c $params.chunk -l $params.limit -d 4 -o ligands_part -of sdf --no-gzip
    """
}


/* Docks each file from the ligand_parts channel sending each resulting SD file to the results channel
*/
process rdock {

    container 'informaticsmatters/rdock-mini:latest'

    input:
    file part from ligand_parts
    file protein
    file prmfile
    file asfile
	
    output:
    file 'docked_part*.sd' into docked_parts
    
    """
    rbdock -i $part -r $prmfile -p dock.prm -n $params.num_dockings -o ${part.name.replace('ligands', 'docked')[0..-5]} > docked_out.log
    """
}



/* Filter, combine and publish the results
*/
process results {

	container 'informaticsmatters/rdock-mini:latest'

	publishDir './', mode: 'copy'

	input:
	file parts from docked_parts.collect()

	output:
	file 'rdock_results.sdf.gz'

	"""
	echo Processing $parts
	sdsort -n -s -fSCORE docked_part*.sd | ${params.score == null ? '' : "sdfilter -f'\$SCORE < $params.score' |"} sdfilter -f'\$_COUNT <= ${params.top}' | gzip > rdock_results.sdf.gz
	"""
}
