#!/usr/bin/env nextflow

// params
params.smiles = '*.smi'
params.chunk_size = 500
params.min_ph = 5.0
params.max_ph = 9.0
params.minimize = 4
params.fragments = 'hits.sdf'
params.num_charges = 1

// files
smilesfiles = file(params.smiles)
fragments = file(params.fragments)

/*
process splitter {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file smiles from smilesfiles.flatten()


    """
    echo ${smiles.name}
    """
}
*/

process splitter {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file smiles from smilesfiles.flatten()

    output:
    file '*.smi' into chunks

    """
    stem=${smiles.name[0..-5]}
    split -l $params.chunk_size -d -a 3 --additional-suffix .smi $smiles \${stem}_
    """
}

process enumerate {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file chunks from chunks.flatten()

    output:
    file 'enumerated_*.sdf' into enumerated

    """
    python -m pipelines.rdkit.enumerate_candidates -i '$chunks' -o enumerated_${chunks}.sdf\
      --enumerate-charges --enumerate-chirals --enumerate-tautomers --name-column 0 --num-charges $params.num_charges\
      --min-ph ${params.min_ph} --max-ph ${params.max_ph}\
      --gen3d --minimize $params.minimize --smiles-field SMILES --add-hydrogens
    """
}

process prepareObabel {
    // this is needed to add the charge info to the atom lines

    container 'informaticsmatters/obabel:3.1.1'
    publishDir './results', mode: 'copy'

    input:
    file molecules from enumerated.flatten()

    output:
    file 'Prep_*.sdf' into prepared_candidates

    """
    obabel '$molecules' -O'Prep_${molecules.name[0..-5]}.sdf'  > obabel.log
    """
}

process gen_feat_maps {

    container 'informaticsmatters/rdkit_pipelines:latest'
    publishDir './results', mode: 'copy'

    input:
    file fragments

    output:
    file 'featurestein.p'

    """
    python -m pipelines.xchem.featurestein_generate -i '$fragments' -f featurestein.p
    """
}
