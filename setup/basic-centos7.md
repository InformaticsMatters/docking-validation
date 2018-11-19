# Setup basic environment for Docker and Nextflow on Centos7

This installs git, docker and java from RPM packages and then installs Nextflow into the centos users $HOME/bin directory.
It assumes a user called `centos`. Adjust if using a different username.

```
sudo -i
yum -y update
yum -y install git docker java-1.8.0-openjdk-headless
groupadd docker
usermod -aG docker centos
sudo systemctl enable docker
sudo systemctl start docker
exit
```

To test that docker is setup correctly try this as the `centos` user: `docker info`.
You should see a report of the docker environment.

Now as the `centos` user install Nextflow:

```
curl -s https://get.nextflow.io | bash
mkdir bin
mv nextflow bin/
nextflow -version
```

If you see information about the Nextflow version then all is good.
