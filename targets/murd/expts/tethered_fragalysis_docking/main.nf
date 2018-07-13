#!/usr/bin/env nextflow

params.chunk = 5
params.num_dockings = 9
params.top = 1
params.score = null
params.nscore = null

protein = file('receptor.pdb')
prmfile = file('recep.prm')

dirs = Channel.fromPath([type: 'dir'], 'MOL_3/VECTOR_*')
files = dirs.map { [it.parent.name, it.name, it.resolve('reference.sdf'), it.resolve('input.smi'), it.resolve('SMILES')] }                   


process prepare_protein {

    container 'informaticsmatters/rdock:latest'

    input:
    file protein
    file prmfile

    output:
    file 'receptor.mol2' into receptor
    
    """
    set -xe

    obabel -ipdb $protein -O receptor.mol2
    """
}

process prepare_inputs {

    container 'informaticsmatters/rdock:latest'

    input:
    set val(dir1), val(dir2), file(reference), file(ligands), file(smarts) from  files
    file receptor
    file prmfile

    output:
    set file('reference_hydrogens.sdf'), file('SMILES'), file('receptor.mol2'), file('recep.as'), file('*_ligands_part_*.sdf') into prepared_inputs mode flatten
    
    """
    set -xe

    split -l $params.chunk $ligands ${dir1}_${dir2}_ligands_part_
    for f in *_ligands_part_*; do obabel -ismi \$f -h --gen3D -O \$f.sdf; done

    obabel -imol $reference -h -O reference_hydrogens.sdf
    rbcavity -was -d -r $prmfile
    """
}


process docking {

    container 'informaticsmatters/rdock:latest'

    input:
    file prmfile
    set file(reference_h), file(smarts), file(receptor), file(activesite), file(part) from prepared_inputs 

    output:
    file '*_docked_part*.sd' into docked_parts
    
    """
    set -xe

    sdtether $reference_h $part ${part.name.replace('ligands', 'tethered')} "\$(cat $smarts)"
    rbdock -i ${part.name.replace('ligands', 'tethered')} -r $prmfile -p dock.prm -n $params.num_dockings -o ${part.name.replace('ligands', 'docked')[0..-5]} > docked_out.log
    """
}

grouped_results = docked_parts.map { file -> tuple(file.name[0..13], file) }.groupTuple()

process results {

    publishDir './results/'
    container 'informaticsmatters/rdock:latest'

    input:
    set prefix, file(f) from grouped_results

    output:
    file "${prefix}.sdf.gz" into results

    """
    sdsort -n -s -fSCORE *_docked_part*.sd |\
        ${params.score == null ? '' : "sdfilter -f'\$SCORE < $params.score' |"}\
        sdfilter -f'\$_COUNT <= ${params.top}' |\
        gzip >  ${prefix}.sdf.gz
    """
}

results.subscribe onNext: { println it }, onComplete: { println 'Done' }

