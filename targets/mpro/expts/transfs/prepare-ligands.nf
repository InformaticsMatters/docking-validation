
params.candidates = 'expanded.smi'
params.chunk = 1000
params.min_ph = 6.4
params.max_ph = 8.4

candidates = file(params.candidates)


process split_smiles {

    input:
    file candidates

    output:
    file 'chunk_*' into chunks mode flatten

    """
    split -l ${params.chunk} -d $candidates chunk_
    """
}

process enumerate_charges {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file chunks

    output:
    file 'enumerated_*' into enumerated_charges mode flatten

    """
    python -m pipelines.dimorphite.dimorphite_dl --smiles_file $chunks --output_file enumerated_${chunks}\
      --min_ph ${params.min_ph} --max_ph ${params.max_ph}
    """
}

process prepare_3d {

    container 'informaticsmatters/obabel:3.0.0'

    publishDir 'work', mode: 'copy'

    input:
    file enumerated_charges

    output:
    file 'enumerated_chunk_*.sdf' into sdfs mode flatten

    """
    obabel $enumerated_charges -i smi -o sdf -O ${enumerated_charges}.sdf --gen3D
    """
}
