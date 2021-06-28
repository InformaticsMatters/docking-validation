#!/usr/bin/env nextflow

// params
params.chunk = 1000
params.scratch = false
params.ligands = 'ligands.sdf'
params.protein = 'receptor.pdb'
params.key_hbond = 0
params.key_hydrophobic = 0
params.key_halogen = 0
params.key_salt_bridge = 0
params.key_pi_stacking = 0
params.key_pi_cation = 0
params.publishDir = './'

// files
ligands = file(params.ligands)
protein = file(params.protein)

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

process interactions {

    container 'informaticsmatters/rdkit_pipelines:inters'
    errorStrategy 'retry'
    maxRetries 3
    scratch params.scratch

    input:
    file part from ligand_parts.flatten()
    file protein

    output:
    file 'oddt_*.sdf' into interactions_parts

    """
    python -m pipelines.xchem.calc_interactions -i '$part' -if sdf -p $protein -o 'oddt_${part.name[0..-4]}' -of sdf --no-gzip\
      ${params.key_hbond ? '--key-hbond ' + params.key_hbond : ''}\
      ${params.key_hydrophobic ? '--key-hydrophobic ' + params.key_hydrophobic : ''}\
      ${params.key_halogen ? '--key-halogen ' + params.key_halogen : ''}\
      ${params.key_salt_bridge ? '--key-salt-bridge ' + params.key_salt_bridge : ''}\
      ${params.key_pi_stacking ? '--key-pi-stacking ' + params.key_pi_stacking : ''}\
      ${params.key_pi_cation ? '--key-pi-cation ' + params.key_pi_cation : ''}\
      --nnscore /opt/python/NNScore_pdbbind2016.pickle\
      --rfscore /opt/python/RFScore_v1_pdbbind2016.pickle /opt/python/RFScore_v2_pdbbind2016.pickle /opt/python/RFScore_v3_pdbbind2016.pickle\
      --plecscore /opt/python/PLEClinear_p5_l1_pdbbind2016_s65536.pickle\
      --strict\
      --exact-ligand
    """
}


process collate {

    container 'informaticsmatters/rdkit_pipelines:inters'
    publishDir params.publishDir, mode: 'copy'

    input:
    file part from interactions_parts.collect()

    output:
    file 'results_oddt.sdf'

    """
    rm -f results_inters.sdf
    ls oddt_*.sdf | xargs cat >> results_oddt.sdf
    """
}

