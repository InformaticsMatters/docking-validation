#!/usr/bin/env nextflow

params.chunk = 25
params.scratch = false

// docking params
params.ligands = 'ligands.sdf'
params.ligand = 'xtal-lig.mol'
params.protein = 'receptor.pdb'
params.scoring_function = 'default'
params.exhaustiveness = 8
params.padding = 4
params.publish_dir = './results'
params.cpu = 1


// files
ligands = file(params.ligands)
ligand = file(params.ligand)
protein = file(params.protein)


/** Convert the protein to PDBQT format if necessary.
OpenBabel is used to perform the conversion.
*/
process format_protein {

    container 'informaticsmatters/vs-smina:latest'
    scratch params.scratch

    input:
    file protein

    output:
    file 'ready_receptor.pdbqt' into ready_receptor_pdbqt

    script:
    
    if( protein.name.endsWith('.pdb') || protein.name.endsWith('.mol2') )
      """
      echo 'Converting protein to PDBQT format'
      obabel $protein -O ready_receptor.pdbqt
      """
      
    else if( protein.name.endsWith('.pdbqt') )
      """
      cp $protein ready_receptor.pdbqt
      """
      
    else
      """
      echo 'Receptor must be in pdb, pdbqt or mol2 formats'
      exit 1
      """
}

process format_ligand {

    container 'informaticsmatters/vs-smina:latest'
    scratch params.scratch

    input:
    file ligand

    output:
    file 'ready_ligand.pdbqt' into ready_ligand_pdbqt

    script:
    if( ligand.name.endsWith('.pdb') || ligand.name.endsWith('.mol2') || ligand.name.endsWith('.mol') )
      """
      echo 'Converting ligand to PDBQT format'
      obabel $ligand -h -O ready_ligand.pdbqt
      """
      
    else if( ligand.name.endsWith('.pdbqt') )
      """
      cp $ligand ready_ligand.pdbqt
      """
      
    else
      """
      echo 'Ligand must be in pdb, pdbqt, mol or mol2 formats'
      exit 1
      """
}


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


process smina {

    container 'informaticsmatters/vs-smina:latest'
    errorStrategy 'retry'
    maxRetries 3
    scratch params.scratch

    input:
    file part from ligand_parts.flatten()
    file 'receptor.pdbqt' from ready_receptor_pdbqt
    file 'ligand.pdbqt' from ready_ligand_pdbqt
    file 'ligand.sdf' from ligands

    output:
    file 'smina_part_*.sd' into docked_parts

    """
    smina -r receptor.pdbqt -l $part --autobox_ligand ligand.pdbqt --autobox_add $params.padding\
      --exhaustiveness $params.exhaustiveness --scoring $params.scoring_function --cpu $params.cpu\
      -o ${part.name.replace('ligands', 'smina')} > smina_out.log
    """
}


process collect_and_report {

    container 'informaticsmatters/vs-rdock:latest'
    publishDir params.publish_dir, mode: 'move'

    input:
    file part from docked_parts.collect()

    output:
    file 'results_smina.sdf'

    """
    rm -f results_smina.sdf
    ls smina_*.sd | xargs cat >> results_smina.sdf
    """
}

