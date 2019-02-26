FROM centos:7
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"

RUN yum -y update &&\
  yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&\
  yum -y install python-pip openssh-clients

RUN pip install --upgrade pip && pip install tej paramiko==2.4.2

RUN useradd -u 5001 -G 0 -m tej
USER 5001

