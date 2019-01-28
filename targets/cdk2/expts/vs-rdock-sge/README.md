# Virtual screening using rDock using SGE

This is an example of running docking with Nextflow using a Sun Grid Engine (or Univa Grid Engine) cluster.

This examples is based of the [rDock tutorial](http://rdock.sourceforge.net/docking-in-3-steps/)
that is adapted to use data from CDK2 (cyclin dependent kinase 2).
It uses data from the [DUD_rDock_TestSet](http://rdock.sourceforge.net/validation-sets/).

## Requirements

A SGE environment is available and  Singularity must be availble on the cluster.
The workflow is executed from a node with the `qsub` command (the `head` node) and Nextflow is available on that node.

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
the computationally demanding process of doing the execution on the SGE cluster using Singularity containers.
See the rdock.nf file for details.

```sh
./3_run_rdock.sh
```
The result is the rdock_results.sdf.gz file.

This uses the [informaticsmatters/rdkit_pipelines/](https://hub.docker.com/r/informaticsmatters/rdkit_pipelines/) 
and [informaticsmatters/rdock-mini/](https://hub.docker.com/r/informaticsmatters/rdock-mini/) 
Docker images that need tob e converted into Singularity containers and located in the ~/singularity-containers/ directory.

**Note** this will take some time depending on the power of your cluster.
To run smaller jobs see the comments in the 3_run_rdock.sh file.

