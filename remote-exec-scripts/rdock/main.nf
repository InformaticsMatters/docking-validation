#!/usr/bin/env nextflow

/* Example Nextflow pipline that runs Docking using rDock 
*/

params.ligands = 'ligands.data.gz'
params.protein = 'receptor.mol2'
params.prmfile = 'receptor.prm'
params.asfile =  'receptor.as'
params.chunk = 25
params.limit = 0
params.digits = 4
params.num_dockings = 100
params.top = 5
params.score = null
params.nscore = null

prmfile = file(params.prmfile)
ligands = file(params.ligands)
protein = file(params.protein)
asfile  = file(params.asfile)

/* Splits the input SD file into multiple files of ${params.chunk} records.
* Each file is sent individually to the ligand_parts channel
*/
process sdsplit {

    container 'informaticsmatters/rdkit-pipelines-centos:latest'

    errorStrategy 'retry'
    maxRetries 3

    input:
    file ligands

    output:
    file 'ligands_part*.sdf' into ligand_parts mode flatten
    file 'ligands_part_metrics.txt' into splitter_metrics
    
    """
    python -m pipelines_utils_rdkit.filter -i $ligands -if json -c $params.chunk -l $params.limit -d $params.digits -o ligands_part -of sdf --no-gzip --meta
    """
}

/* Docks each file from the ligand_parts channel sending each resulting SD file to the results channel
*/
process rdock {

    container 'informaticsmatters/rdock-mini:latest'

    errorStrategy 'retry'
    maxRetries 3

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

    publishDir baseDir, mode: 'link'

    input:
    file parts from docked_parts.collect()

    output:
    file 'results.sdf' into results

    shell:
    '''
    cat << EOF > execute.sh
#!/bin/bash
sdsort -n -s -fSCORE docked_part*.sd |\
!{params.score == null ? '' : "sdfilter -f'\\$SCORE < !params.score' |"}\
!{params.nscore == null ? '' : " sdfilter -f'\$SCORE.norm <= $params.nscore' |"} \
sdfilter -f'\\$_COUNT <= !{params.top}' > results.sdf
EOF
    bash execute.sh
    '''
}

process metrics {

    container 'informaticsmatters/rdkit-pipelines-centos:latest'

    publishDir baseDir, mode: 'link'

    input:
    file results
    file 'splitter_metrics.txt' from splitter_metrics

    output:
    file 'output.data.gz'
    file 'output.metadata'
    file 'output_metrics.txt'

    """
    python -m pipelines_utils_rdkit.filter -i results.sdf -of json -o output --meta
    mv output_metrics.txt old_metrics.txt
    grep '__InputCount__' splitter_metrics.txt | sed s/__InputCount__/DockingRDock/ > output_metrics.txt
    grep '__InputCount__' splitter_metrics.txt >> output_metrics.txt
    grep '__OutputCount__' old_metrics.txt >> output_metrics.txt
    """
}


