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

* [Docker](https://www.docker.com/community-edition) 
* [Nextflow](https://www.nextflow.io/) 
* [Java](http://www.oracle.com/technetwork/java/javase/overview/index.html) (neded by Nextflow).

Many of the Docker images can be found on the Informatics Matters 
[Docker Hub repository](https://hub.docker.com/u/informaticsmatters/).

## Relationship with Squonk

This is an upstream project for the [Squonk computational notebook](http://squonk.it), as is 
[Pipelines](https://github.com/InformaticsMatters/pipelines). The aim is that these workflows
are generated in a way that makes them easy to integrated into Squonk. As such it provides a 
playground where new methodologies can be developed and benchmarked. 

## Highlights

* [CDK2 virtual screening with rDock](targets/cdk2/expts/vs-rdock-expt1/README.md)
* [Generating ROC curves](targets/hivpr/expts/vs_roc_curve/README.md)
* [Docking pose validation for ESR](targets/esr/expts/pose-validation/README.md)

## Contributing

We welcome contributions, but want to make sure they follow a well defined set of pattens and 
conventions. Unfortunately these are still being established.

We will insist on all examples being well documented.

Contact Tim Dudgeon <tdudgeon at informaticsmatters dot com> if you want to get involved.

