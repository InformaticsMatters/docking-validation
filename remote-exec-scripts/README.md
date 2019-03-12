# Remote execution of workflows

## 1. Overview

Remote execution uses Tej (https://pypi.org/project/tej/) which is a wrapper around
SSH and SCP for executing jobs remotely.

The jobs themselves are Nextflow (https://www.nextflow.io/) workflows which allows
the wokflow to be run using a number of job executors. The `sge`, `ignite` and `slurm` executors
are tested but other supported executors should work with minimal extra work.

The workflow tasks are typically executed using Singularity containers (https://singularity.lbl.gov/)
though Docker containers also work, as should running without containers should your
environment have all the dependencies needed. But using Signularity is the easiest approach.
Our workflows are defined using Docker containers so that they can be run with Docker or Singularity.

The basic approach is to create a remote execution and test it on the remote environments you are using. An
example is in the`rdock directory. An execution directory will contain:

1. a `start.sh` script that runs the workflow by executing the `nextflow run ...` command.
1. all required input files
1. an optional `nextflow.config` file with additional Nextflow configuration, but this is
usually not needed.

The remote execution environment must be set up to use the appropriate executor. See below for details.

The remote execution is implemented using Tej in the `tej-submit.sh` script which is workflow neutral.
The same script should be able to be used to execute any workflow in any environment. This script:

1. copies the content of the workflow dir (e.g. the `rdock` directory) to the remote server
1. runs the `start.sh` script
1. waits for the workflow to complete
1. if execution is successful copies the result files back to the work directory

## Setting up SSH

Tej uses ssh to for remote execution so password-less SSH must be enabled from your host to the remote
execution environment so a public/private key needs to be defined and an entry for that key pair put in 
the ~/.ssh/known_hosts file. To do this:

1.1. Create a public/private key pair in this directory:
```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f id_rsa
```
The files `id_rsa` and `id_rsa.pub` are in .gitignore.

1.2. Add the public key to the `.ssh/authorized_keys` file on the remote server.

1.3. SSH to that server with this private key to generate an entry in the `.ssh/known_hosts` file.
Copy that particular entry to the `known_hosts` file in this project (that file is in .gitignore).


## Setting up remote execution environment

Password-less SSH must be set up as described above.

The remote execution environment must be set up to use the appropriate executor. This is typically done
by means of a `~/.nextflow/config`file, but additional aspects can be defined by creating a
`~/nextflow-init.sh` file which will be sourced prior to nextflow execution should it exist.

The workflow itself will be completely isolated from the execution environment and will not specify
the executor (e.g. `sge`) or what type of container runtime (e.g. Singularity) is being used.

If using Singularity it is __strongly__ recommended to use Nextflow's `cacheDir` feature to avoid pulling
images multiple times, and you probably need to enable the `autoMounts` setting. A section on the config file
might  look like this:

```
singularity {
    enabled = true
    cacheDir = "$HOME/singularity-containers"
    autoMounts = true
}
```
 

### Execute from a shell

Run this with the `tej-submit.sh` script. Two environment variables must be set, `USERNAME` and `SERVER` which
specify the remove execution server and the user. The SSH keys must have been set up for that user.

```
$ ./tej-submit.sh rdock
Submiting job from rdock
Submitting Tej job using gse84885@130.246.215.45 ...
Started Tej job rdock_gse84885_b7bf4gyku7
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: running
Status: finished 0
Job finished. Status: finished 0
Downloading results ...
Results downloaded
Deleting job ...
Job rdock_gse84885_b7bf4gyku7 deleted
```

You will see that the job is started, waits until it is finished, downloads the results and then deletes
the job. The result files will be found in the worklow directory.


## Running from a docker container

Alternatively you can start the execution from a Docker container. One reason to do this is to simulate the 
environment that will be run when these workflows are executed as Squonk services.

### Docker image

An image for executing tej can be found on [Docker Hub](https://cloud.docker.com/u/informaticsmatters/repository/docker/informaticsmatters/tej). You can pull it with:
```
docker pull informaticsmatters/tej
```

### Execute in container

This uses the SSH private key file and the known_hosts file described in the previous section 1.
Change the values of the 2 environment variables if using different files. 

```
docker run -it --rm -v $PWD:$PWD:Z -w $PWD -e SSH_KEY="$(cat id_rsa)" -e SERVER=myhost.com -e USERNAME=myuser -e KNOWN_HOSTS="$(cat known_hosts)" informaticsmatters/tej:latest ./docker-submit.sh rdock
```

The `docker-submit.sh` script sets up the SSH environment and then calls the `tej-submit.sh` script used above.

You probably need to change:

* The USERNAME and SERVER environment variables
* The workflow to execute (the last argument)

The workfloww directory needs to have permissions to allow the container user to write files to it.

## Limitations

1. tej's ability to copy result files seems to be quite limited (no support for wildcards etc.).
We are still working out how best to handle this in a generic manner.
1. error handling is not much tested yet. If the Nextflow workflow fails tej does not recognise this as 
having failed and tried to download non-existing results. We plan to improve this.
1. If the singularity container is not already present then Singularity must be installed on the head node.
This may not be the case (e.g. in  SGE environment) so you might need to make sure that all the containers are
pre-pulled.
