#!/usr/bin/env nextflow

params.chunk = 25
params.num_dockings = 9
params.top = 1
params.score = null
params.nscore = null
params.limit = 0
params.digits = 3

protein = file('receptor.pdb')
prmfile = file('recep.prm')

ligands = Channel.fromPath('MOL_3/*/input.smi')
    .map { file-> [file.parent.name, file.parent.parent.name, file] }
reference = Channel.fromPath('MOL_3/*/reference.sdf')
smiles = Channel.fromPath('MOL_3/*/SMILES')

                          


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
  set val(dir2), val(dir1), file(ligands) from  ligands
  file reference
  file receptor
  file prmfile
  file smiles

  output:
  file "*_ligands_h.sdf" into ligands_h
  file "reference_hydrogens.sdf" into reference_h
  file 'recep.as' into activesite
  file 'SMILES' into smiles2
  file 'receptor.mol2' into receptor2
    
  """
  set -xe

  obabel -imol $reference -h -O reference_hydrogens.sdf
  obabel -ismi $ligands -h --gen3D -O ${dir1}_${dir2}_ligands_h.sdf
  rbcavity -was -d -r $prmfile
  """
}

process splitter {

  container 'informaticsmatters/rdkit_pipelines:latest'
  input:
  file ligands_h
  file reference_h
  file receptor2
  file smiles2
  file activesite

  output:
  file '*ligands_h_part*.sdf' into ligands_parts mode flatten
  file 'reference_hydrogens.sdf' into reference_h3
  file 'receptor.mol2' into receptor3
  file 'SMILES' into smiles3
  file 'recep.as' into activesite3
    
  """
  python -m pipelines_utils_rdkit.filter -i $ligands_h -c $params.chunk -d $params.digits -l $params.limit -o ${ligands_h.name.replace('_ligands_h.sdf', '_ligands_h_part')} -of sdf --no-gzip
  """
}

process docking {

  container 'informaticsmatters/rdock:latest'

	input:
    file part from ligands_parts
    file reference_h3
    file receptor3
    file prmfile
    file activesite3
    file smiles3

    output:
    file '*docked_h_part*.sd' into docked_parts
    
    """
    set -xe

    sdtether $reference_h3 $part ${part.name.replace('ligands', 'tethered')} "\$(cat $smiles3)"
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
	sdsort -n -s -fSCORE *.sd > sorted.sd
    sdfilter -f'\$_COUNT <= ${params.top}' sorted.sd > results.sdf

    sdsort -n -s -fSCORE *.sd |\
      ${params.score == null ? '' : "sdfilter -f'\$SCORE < $params.score' |"}\
      sdfilter -f'\$_COUNT <= ${params.top}' | gzip > ${prefix}.sdf.gz
	"""
}

results.subscribe onNext: { println it }, onComplete: { println 'Done' }

