#!/usr/bin/env nextflow

params.chunk = 25

// docking params
params.ligands = 'ligands.sdf'
params.protein = 'receptor.mol2'
params.prmfile = 'docking.prm'
params.asfile = 'docking.as'
params.pharmafile = 'pharma.restr'
params.num_dockings = 10

// featurestein
params.featuremaps = 'featurestein.p'

// interactions
params.iprotein = 'receptor.pdb'
params.key_hbond = null
params.key_hydrophobic = null
params.key_halogen = null
params.key_salt_bridge = null
params.key_pi_stacking = null
params.key_pi_cation = null
params.interactions = 'self_interactions.json'

// sucos
params.refmol = 'ligand.mol'

// xcos
params.fragments = 'hits.sdf'

// files
ligands = file(params.ligands)
protein = file(params.protein)
prmfile = file(params.prmfile)
asfile = file(params.asfile)
pharmafile = file(params.pharmafile)
featuremaps = file(params.featuremaps)
iprotein = file(params.iprotein)
interactions = file(params.interactions)
refmol = file(params.refmol)
fragments = file(params.fragments)

process sdsplit {

    container 'informaticsmatters/rdock:2013.1'

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

process rdock {

    container 'informaticsmatters/rdock:2013.1'
    errorStrategy 'retry'
    maxRetries 3

    input:
    file part from ligand_parts.flatten()
    file 'receptor.mol2' from protein
    file 'docking.prm' from prmfile
    file 'docking.as' from asfile
    file 'pharma.restr' from pharmafile

    output:
    file 'Docked_*.sd' optional true into docked_parts

    """
    rbdock -r $prmfile -p dock.prm -n $params.num_dockings -i $part -o ${part.name.replace('ligands', 'Docked')[0..-4]} > docked_out.log
    """
}

process featurestein {

    container 'informaticsmatters/rdkit_pipelines:latest'

	input:
    file part from docked_parts
    file featuremaps
    file refmol

    output:
    file 'FS_*.sdf' into featurestein_parts

    """
    python -m pipelines.rdkit.sucos -i '$part' -if sdf --target '$refmol' --target-format sdf -o sucos -of sdf --no-gzip
    python -m pipelines.xchem.featurestein_score -i sucos.sdf -if sdf -f '$featuremaps' -o 'FS_${part.name[0..-4]}' -of sdf --no-gzip
    """
}

process interactions {

    container 'informaticsmatters/rdkit_pipelines:latest'

    input:
    file part from featurestein_parts
    file iprotein
    file interactions

    output:
    file 'INT_*.sdf' into interactions_parts

    """
    python -m pipelines.xchem.calc_interactions -i '$part' -if sdf -p $iprotein -o 'INT_${part.name[0..-5]}' -of sdf --no-gzip\
      ${params.key_hbond ? '--key-hbond ' + params.key_hbond : ''}\
      ${params.key_hydrophobic ? '--key-hydrophobic ' + params.key_hydrophobic : ''}\
      ${params.key_halogen ? '--key-halogen ' + params.key_halogen : ''}\
      ${params.key_salt_bridge ? '--key-salt-bridge ' + params.key_salt_bridge : ''}\
      ${params.key_pi_stacking ? '--key-pi-stacking ' + params.key_pi_stacking : ''}\
      ${params.key_pi_cation ? '--key-pi-cation ' + params.key_pi_cation : ''}\
      --nnscore /opt/python/NNScore_pdbbind2016.pickle\
      --rfscore /opt/python/RFScore_v1_pdbbind2016.pickle /opt/python/RFScore_v2_pdbbind2016.pickle /opt/python/RFScore_v3_pdbbind2016.pickle\
      --compare '$interactions'\
      --strict
    """
}


process xcos {

    container 'informaticsmatters/rdkit_pipelines:latest'

	input:
    file part from interactions_parts
    file fragments

    output:
    file 'XC_*.sdf' into xcos_parts

    """
    python -m pipelines.xchem.xcos -i '$part' -if sdf -f '$fragments' -o 'XC_${part.name[0..-5]}' -of sdf --no-gzip
    """
}


process filter_and_report {

    container 'informaticsmatters/rdock:2013.1'
    publishDir "./results", mode: 'copy'

    input:
    file part from xcos_parts.collect()

    output:
    file 'results.sdf.gz'
    file 'results.txt'

    """
    cat XC_*.sdf > results.sdf
    sdreport -t results.sdf > results.txt
    gzip results.sdf
    """
}
