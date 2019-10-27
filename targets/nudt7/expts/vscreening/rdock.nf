#!/usr/bin/env nextflow

/* Example Nextflow pipeline that runs Docking using rDock
*/

params.ligand = 'ligand.mol'
params.ligands = '../ligands.sdf.gz'
params.protein = 'receptor.mol2'
params.prmfile = 'docking.prm'
params.asfile =  'docking.as'
params.chunk = 5
params.limit = 0
params.num_dockings = 25
params.top = 1
params.threshold = 0.5
params.field = 'SCORE.norm'

prmfile = file(params.prmfile)
ligand = file(params.ligand)
ligands = file(params.ligands)
protein = file(params.protein)
asfile  = file(params.asfile)

/* Splits the input SD file into multiple files of ${params.chunk} records.
* Each file is sent individually to the ligand_parts channel
*/
process sdsplit {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file ligands

    output:
    file 'ligands_part*.sdf' into ligand_parts mode flatten
    
    """
    python -m pipelines_utils_rdkit.filter -i $ligands -if sdf -c $params.chunk -l $params.limit -d 4 -o ligands_part -of sdf --no-gzip
    """
}

/* Docks the original ligand
*/
process dock_ligand {

    container 'informaticsmatters/rdock-mini:latest'

    publishDir './', mode: 'copy'

    input:
    file protein
    file prmfile
    file asfile
    file ligand

    output:
    file 'best_ligand.sdf' into best_ligand

    """
    rbdock -i ligand.mol -r $prmfile -p dock.prm -n $params.num_dockings -o docked_ligand > docked_ligand_out.log
    sdsort -n -s -fSCORE docked_ligand.sd | sdfilter -f'\$_COUNT <= 1' > best_ligand.sdf
    """
}

/* Docks each file from the ligand_parts channel sending each resulting SD file to the results channel
*/
process vscreening {

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
	file best from best_ligand

	output:
	file 'rdock_results.sdf.gz'

	"""
	FSCORE=\$(sdreport -nh -t${params.field} best_ligand.sdf | cut -f 2 | awk '{\$1=\$1};1')
	ASCORE=\$(awk "BEGIN {print \$FSCORE + ${params.threshold}}")
	echo "Processing $parts with normalised score filter of \$ASCORE"
	sdsort -n -s -fSCORE docked_part*.sd | sdfilter -f'\$${params.field} < \$ASCORE' | sdfilter -f'\$_COUNT <= ${params.top}' | gzip > rdock_results.sdf.gz
	"""
}
