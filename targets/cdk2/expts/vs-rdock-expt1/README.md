# Virtual screening using rDock

This examples is based of the [rDock tutorial](http://rdock.sourceforge.net/docking-in-3-steps/)
that is adapted to use data from CDK2 (cyclin dependent kinase 2).
It uses data from the [DUD_rDock_TestSet](http://rdock.sourceforge.net/validation-sets/).

## Requirements

Nextflow and Docker (or Singularity) must be installed on the host machine.

## To run 

### 1. Copy files

Copy the relevant files from /datasets/DUD_rDock_TestSet.

```sh
./1_copy_files.sh
```

### 2. Create cavity

rDock needs a cavity defintion. In this case we use the rbcavity program that uses a cound ligand to define the 
cavity.

```sh
./2_create_cavity.sh
```

The results are the cdk2_rdock_cav1.grd and cdk2_rdock.as files.

This runs the rbcavity in the [informaticsmatters/rdock/](https://hub.docker.com/r/informaticsmatters/rdock/) 
Docker image.

### 3. Perform docking

This runs the docking using [Nextflow](http://nextflow.io) which executes each of the stages, parallelising
the computationally demanding process of doing the actual dockings according to the number of cores on the machine.
See the rdock.nf file for details.

```sh
./3_run_rdock.sh
```
The result is the rdock_results.sdf.gz file.

This uses the [informaticsmatters/rdkit_pipelines/](https://hub.docker.com/r/informaticsmatters/rdkit_pipelines/) 
and [informaticsmatters/rdock-mini/](https://hub.docker.com/r/informaticsmatters/rdock-mini/) 
Docker images.

**Note** this will take some time depending on the power of your computer.
To perform 100 dockings on the entire dataset takes about 10 hours on a 24 core machine.
To run smaller jobs see the comments in the 2_run_rdock.sh file.

**Note** this workflow can also be run using Singularity. Look at the `2_create_cavity.sh` and `3_run_rdock.sh`
scripts and change `-with-docker` to `-with-singularity`
