#!/usr/bin/env nextflow

/* Example Nextflow pipline that runs Docking using rDock 
*/

params.ligands = 'cdk2_ligprep.sdf.gz'
params.protein = 'cdk2_rdock.mol2'
params.prmfile = 'cdk2_rdock.prm'
params.asfile =  'cdk2_rdock.as'
params.chunk = 5 // 25
params.limit = 100 //0
params.digits = 4
params.num_dockings = 10 // 100
params.top = 5
params.score = null

prmfile = file(params.prmfile)
ligands = file(params.ligands)
protein = file(params.protein)
asfile  = file(params.asfile)

/* Splits the input SD file into multiple files of ${params.chunk} records.
* Each file is sent individually to the ligand_parts channel
*/
process sdsplit {

	input:
    file ligands

    output:
    file 'ligands_part*' into ligand_parts mode flatten
    
    """
    singularity exec ~/singularity-containers/rdkit-pipelines-centos-latest.simg\
      python -m pipelines_utils_rdkit.filter -i $ligands -c $params.chunk -l $params.limit -d $params.digits -o ligands_part -of sdf --no-gzip
    """
}

/* Docks each file from the ligand_parts channel sending each resulting SD file to the results channel
*/
process rdock {

    input:
    file part from ligand_parts
    file protein
    file prmfile
    file asfile

    output:
    file 'docked_part*.sd' into docked_parts

    """
    singularity exec ~/singularity-containers/rdock-mini-latest.simg\
      rbdock -i $part -r $prmfile -p dock.prm -n $params.num_dockings -o ${part.name.replace('ligands', 'docked')[0..-5]} > docked_out.log
    """
}

/* Filter, combine and publish the results
*/
process results {

    publishDir './', mode: 'copy'

    input:
    file parts from docked_parts.collect()

    output:
    file 'rdock_results.sdf.gz'

    shell:
    '''
    cat << EOF > execute.sh
#!/bin/bash
sdsort -n -s -fSCORE docked_part*.sd | !{params.score == null ? '' : "sdfilter -f'\\$SCORE < !params.score' |"} sdfilter -f'\\$_COUNT <= !{params.top}' | gzip > rdock_results.sdf.gz
EOF
    singularity exec ~/singularity-containers/rdock-mini-latest.simg bash execute.sh
    '''
}


