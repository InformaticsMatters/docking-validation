#!/usr/bin/env nextflow

// params
params.smiles = '*.smi'
params.chunk_size = 500
params.min_ph = 6.0
params.max_ph = 8.0
params.minimize = 10
params.fragments = '../hits.sdf'
params.num_charges = null

// files
smilesfiles = file(params.smiles)
fragments = file(params.fragments)

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
    file 'enumerated_*' into enumerated

    """
    python -m pipelines.rdkit.enumerate_candidates -i '$chunks' -o enumerated_${chunks}\
      --enumerate-charges --enumerate-chirals --enumerate-tautomers --name-column 0 --num-charges 1\
      --min-ph ${params.min_ph} --max-ph ${params.max_ph}
    """
}

process prepare3d {

    container 'informaticsmatters/obabel:3.1.1'
    publishDir './results', mode: 'copy'

    input:
    file molecules from enumerated.flatten()

    output:
    file 'Prep_*.sdf' into prepared_candidates

    """
    obabel '$molecules' -O'Prep_${molecules.name[0..-5]}.sdf' -h --gen3D --add cansmi  > obabel.log
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