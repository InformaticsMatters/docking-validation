# Simple rDock virtual screening

Simple example of how to set up virtual screening using rDock.
This mainpurpose of this example is to illustrate how to set up rDock for virtual screening for a
particular target so that the prepared components (receptor and active site definition) can be used
in virtual screening workflows in Squonk. Use a project like this to setup the dcoking experiment,
and onve you are happy with the results use the items generated in Squonk. This allows an expert to set up 
the experiment, but for the non-expert to easily run docking in Squonk.

## Contents

DHFR and the bound ligand from the DEKOIS dataset is used for receptor and the DHFR Sutherland dataset is used 
for the ligands to screen. All of these are present in the datasets present in this repository. 

## To run 

### 1. Copy files

Copy the relevant files from /datasets/DEKOIS_2.0 and /datasets/sutherland

```sh
./1_copy_files.sh
```

The results are the files ligands.sdf.gz receptor.pdb and xtal-lig.mol2

### 2. Prepare inputs

Use OpenBabel to convert the receptor to MOL2 format and the bound ligand to SDF format. 


```sh
./2_prepare_inputs.sh
```

The results are the files receptor.mol2 and ligand.sdf

### 3. Create cavity

rDock needs a cavity defintion. In this case we use the rbcavity program that uses a cound ligand to define the 
cavity.

```sh
./3_create_cavity.sh
```

The results are the receptor_cav1.grd and receptor.as files.

This runs the rbcavity in the [informaticsmatters/rdock/](https://hub.docker.com/r/informaticsmatters/rdock/) 
Docker image.

### 4. Perform docking with rDock

This runs the docking using [Nextflow](http://nextflow.io) which executes each of the stages, parallelising
the computationally demanding process of doing the actual dockings according to the number of cores on the machine.
See the rdock.nf file for details.

```sh
./4_run_rdock.sh
```
The result is the rdock_results.sdf.gz file.

This uses the [informaticsmatters/rdkit_pipelines](https://hub.docker.com/r/informaticsmatters/rdkit_pipelines/) 
and [informaticsmatters/rdock/](https://hub.docker.com/r/informaticsmatters/rdock/) Docker images.

**Note** this will take some time depending on the power of your computer.

To view the results do something like this:

```
zcat rdock_results.sdf.gz |  docker run -i --rm -v $PWD:$PWD -w $PWD informaticsmatters/rdock sdreport -tSCORE,SCORE.norm  | more
```


## Preapration for use in Squonk

Information on using the Squonk rDock Docking cell can be found [here](https://squonk.it/xwiki/bin/view/Cell+Directory/Data/rDock+Docking).

You need to prepare a zip file containing:

* receptor.mol2 - the receptor definintion in Tripos MOL2 format
* receptor.prm - the rDock parameters file
* receptor.as - The rDock active site definition for the receptor 

After running the steps above (and convincing yourself that you are happy with the results) you will have these 3 files in this directory.
Just zip them up into a zip file and you can use that in Squonk for the rDock configuration.

```
zip dhrf_rdock_config.zip receptor.mol2 receptor.prm receptor.as
```

The name of the zip file is not important, just its contents.






