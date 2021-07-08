#!/usr/bin/env nextflow

/* Example Nextflow pipline that runs Docking using rDock 
*/

params.ligands = 'ligands.sdf'
params.protein = 'receptor.mol2'
params.prmfile = 'rdockconfig.prm'
params.asfile =  'rdockconfig.as'
params.chunk = 25
params.limit = 0
params.num_dockings = 50
params.top = 5
params.score = null
params.publish_dir = './results'

prmfile = file(params.prmfile)
ligands = file(params.ligands)
protein = file(params.protein)
asfile  = file(params.asfile)



/* Splits the input SD file into multiple files of ${params.chunk} records.
* Each file is sent individually to the ligand_parts channel
*/
process sdsplit {

    container 'informaticsmatters/vs-rdock:latest'

    input:
    file ligands

    output:
    file 'ligands_part*.sd' into ligand_parts

    """
    sdsplit -${params.chunk} -oligands_part_ $ligands

    for f in ligands_part_*.sd; do
      n=\${f:13:-3}
      if [ \${#n} == 1 ]; then
        mv \$f ligands_part_000\${n}.sd
      elif [ \${#n} == 2 ]; then
        mv \$f ligands_part_00\${n}.sd
      elif [ \${#n} == 3 ]; then
        mv \$f ligands_part_0\${n}.sd
      fi
    done
    """
}

/* Docks each file from the ligand_parts channel sending each resulting SD file to the results channel
*/
process rdock {

    container 'informaticsmatters/vs-rdock:latest'
    errorStrategy 'retry'
    maxRetries 3

    input:
    file part from ligand_parts.flatten()
    file protein
    file prmfile
    file asfile
	
    output:
    file 'docked_part*.sd' into docked_parts
    
    """
    rbdock -i $part -r $prmfile -p dock.prm -n $params.num_dockings -o ${part.name.replace('ligands', 'docked')[0..-4]} > docked_out.log
    """
}



/* Filter, combine and publish the results
*/
process results {

	container 'informaticsmatters/vs-rdock:latest'

	publishDir params.publish_dir, mode: 'move'

	input:
	file parts from docked_parts.collect()

	output:
	file 'results_rdock.sdf'

	"""
	ls docked_part*.sd | xargs cat >> results_rdock.sdf
	"""
}
