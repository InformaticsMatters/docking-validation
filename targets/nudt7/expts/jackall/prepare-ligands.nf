
params.candidates = 'expanded.smi'
params.chunk = 1000

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

process prepare_smiles {

    container 'informaticsmatters/obabel:3.0.0'

    publishDir 'work'

    input:
    file chunks

    output:
    file 'chunk_*.sdf' into sdfs mode flatten

    """
    obabel $chunks -i smi -o sdf -O ${chunks}.sdf -p 7.4 --gen3D
    """
}
