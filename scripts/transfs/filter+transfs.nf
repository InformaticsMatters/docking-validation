#!/usr/bin/env nextflow

/* Nextflow pipeline that runs TransFS
*/

params.poses = 'input.sdf'
params.sucos_score = 0.3
params.sucos_field = 'Max_SuCOS_Score'
params.chunk = 100000
params.protein_pdb = 'receptor.pdb'
params.distance = 0
params.num_gpus = 'all'
params.max_forks = 1
params.mock = false
// models are: weights.caffemodel 10nm.0_iter_50000.caffemodel 50nm.0_iter_50000.caffemodel 200nm.0_iter_50000.caffemodel
params.model = '50nm.0_iter_50000.caffemodel'

poses = file(params.poses)
protein_pdb = file(params.protein_pdb)

process filter_rank_split {

    container 'informaticsmatters/rdock:latest'

    input:
    file poses

    output:
    file 'chunk_*.sd' into chunks mode flatten

    """
    sdfilter -f'\$${params.sucos_field} > ${params.sucos_score}' '$poses'\
    | sdsplit -${params.chunk} -ochunk_

    if [ -f chunk_1.sd ]; then mv chunk_1.sd chunk_01.sd; fi
    if [ -f chunk_2.sd ]; then mv chunk_2.sd chunk_02.sd; fi
    if [ -f chunk_3.sd ]; then mv chunk_3.sd chunk_03.sd; fi
    if [ -f chunk_4.sd ]; then mv chunk_4.sd chunk_04.sd; fi
    if [ -f chunk_5.sd ]; then mv chunk_5.sd chunk_05.sd; fi
    if [ -f chunk_6.sd ]; then mv chunk_6.sd chunk_06.sd; fi
    if [ -f chunk_7.sd ]; then mv chunk_7.sd chunk_07.sd; fi
    if [ -f chunk_8.sd ]; then mv chunk_8.sd chunk_08.sd; fi
    if [ -f chunk_9.sd ]; then mv chunk_9.sd chunk_09.sd; fi
    """
}

/* Scores the poses the deep learning.
* Use the 'mock' param to use random scores rather than run of GPU
*/
process score_transfs {

    container 'informaticsmatters/transfs:1.3'
    containerOptions params.mock ? '' : "--gpus $params.num_gpus"
    maxForks params.max_forks

    publishDir '.', mode: 'copy'

    input:
    file chunks
    file 'receptor.pdb' from protein_pdb

    output:
    file 'tfs_*.sd'

    """
    mkdir tfs
    base=\$PWD
    cd /train/fragalysis_test_files/
    python transfs.py -i \$base/$chunks -r \$base/receptor.pdb -d $params.distance -m $params.model -w \$base/tfs ${params.mock ? '--mock' : ''}
    mv \$base/tfs/output.sdf \$base/tfs_${chunks}
    """
}
