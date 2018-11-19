# Setup instructions

Here are a set of instructions for setting up environments in which you can run the experiments.

## Basic environment for Docker and Nextflow

* [Instructions for Centos7](basic-centos7.md)
* [Instructions for Debian and Ubuntu](basic-debian.md)

## Running a Nextflow (Ignite) cluster

This extends the basic environment by allowing Nextflow to run on tasks on multiple servers.
It should work for Centos7 and Debian distributions.

This uses an Apache Ignite clustering that is built into Nextflow.
More info in Ignite in Nextflow can be found [here](https://www.nextflow.io/docs/latest/ignite.html).
Nextflow also supports other types of cluster. See [here](https://www.nextflow.io/docs/latest/executor.html) for details.

1. Create a master node from where the jobs are started as described in the `Basic environment for Docker and Nextflow` section above.
2. Create the worker nodes as described in the `Basic environment for Docker and Nextflow` section above.
3. Set up shared storage for all nodes accessible from the same path. e.g. setup the master as an NFS server and mount the shared directory on the worker nodes.
4. Start Nextflow as a background process on all the worker nodes using `nextflow node -bg -cluster.join path:/path/to/shared/dir/` 

Note: we use the shared directory for node discovery. Other options are possible. See the Nextflow docs for more info.

Start the workflow on the master node by adding `-process.executor ignite -cluster.join path:path/to/shared/dir/` to your `nextflow run ...` command. e.g. `nextflow run <your pipeline> -process.executor ignite -cluster.join path:/net/shared/path`. Also consider using `-process.scratch` to allow work to be done outside the shared dir.
