# Docking execution and validation studies

This repo provides examples of performing virtual screening related work.
The idea is to provide well defined and well documented examples that can be run
by third parties, and to define how to produce a toolset that allows these
workflows to be readily executed.

A key related project is [Pipelines](https://github.com/InformaticsMatters/pipelines)
that defines a number of components (currently mostly based on Python and RDKit).

A key part of the strategy is perform the execution in [Docker containers](https://www.docker.com/)
so that you do NOT need to install lots of different tools on your host machine. Currently the only
tools you need installed are:

* [Docker](https://www.docker.com/community-edition) or [Singularity](https://www.sylabs.io/singularity/)
* [Nextflow](https://www.nextflow.io/) 
* [Java](http://www.oracle.com/technetwork/java/javase/overview/index.html) (neded by Nextflow).

Many of the Docker images can be found on the Informatics Matters 
[Docker Hub repository](https://hub.docker.com/u/informaticsmatters/).

## Docker and Singularity

The majority of this work uses Docker containers and the scripts are written for Docker.
However most if not all should also work with Singularity.
To run with Singularity first create the necessary Singularity images from the Docker images
using a command like this:
```
singularity pull docker://informaticsmatters/rdock:latest
``` 

Then convert the `docker run` commands to `singularity exec` commands. The current directory is automatically
mounted and the process runs as the current user so the command is a little simpler. For example, for a 
Docker command like this:
```
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest rbcavity -r 1sj0_rdock.prm -was
```

you would need a Singularity command like this:
```
singularity exec ~/rdock-mini_latest.sif rbcavity -r 1sj0_rdock.prm -was
```

When running with Nextflow the Docker images defined in a workflow are automatically pulled and converted
to Singlularity. You might want to set the `NXF_SINGULARITY_CACHEDIR` environment variable
to define where Nextflow places the Singularity images so that you do not end up with copies in every 'project'.

## Relationship with Squonk

This is an upstream project for the [Squonk computational notebook](http://squonk.it), as is 
[Pipelines](https://github.com/InformaticsMatters/pipelines). The aim is that these workflows
are generated in a way that makes them easy to integrated into Squonk. As such it provides a 
playground where new methodologies can be developed and benchmarked.

## Datasets

Inlcuded in this repo are a number of public datasets that are useful for testing and validation studies.
You can find them in the [datasets directory](datasets).
Feel free to contribute additional datasets, but if doing so please include documentation describing the source
of the dataset and attribute ownership appropriately.

## Highlights

* [CDK2 virtual screening with rDock](targets/cdk2/expts/vs-rdock-expt1/README.md)
* Docking validation for DHFR using rDock and Smina using DEKIOS data: [DHFR](targets/dhfr/expts/vs-dekois/README.md) - also for [CDK2](targets/cdk2/expts/vs-dekois/README.md), [SARS-COV](targets/sars-cov-3cpr/expts/vs-dekois/README.md)
* [Generating ROC curves](targets/hivpr/expts/vs_roc_curve/README.md)
* [Docking pose validation for ESR](targets/esr/expts/pose-validation/README.md)
* [rDock setup for use in Squonk](targets/dhfr/expts/vs-simple-rdock/README.md)
* [Protein selection for docking](targets/nudt7/expts/protein-selection/README.md)

## Contributing

We welcome contributions, but want to make sure they follow a well defined set of pattens and 
conventions. Unfortunately these are still being established.

We will insist on all examples being well documented.

Contact Tim Dudgeon \<tdudgeon at informaticsmatters dot com\> if you want to get involved.

