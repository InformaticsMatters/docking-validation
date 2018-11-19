# Setup basic environment for Docker and Nextflow on Debian-like systems.

This installs git, docker and java from APT packages and then installs Nextflow into the `ubuntu` user's $HOME/bin directory.
It assumes a user called `ubuntu`. Adjust if using a different username.

```
$ sudo -i
# apt-get update -y
# apt-get install -y docker.io git openjdk-8-jdk-headless
# groupadd docker
# usermod -aG docker ubuntu
# service docker status
# exit
```

The `docker status` command should show that docker is running. If not start it using `service docker start`
On some distributions the docker package to install is named `docker` not `docker.io`.

To test that docker is setup correctly try this as the `ubuntu` user: `docker info`.
You should see a report of the docker environment.

Now as the `ubuntu` user install Nextflow:
```
$ curl -s https://get.nextflow.io | bash
$ mkdir bin
$ mv nextflow bin/
$ nextflow -version
```

If you see information about the Nextflow version then all is good.
Note that you might need to log out and log back in for Ubuntu to pick up your new $HOME/bin directory.

