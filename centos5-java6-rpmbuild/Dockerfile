FROM centos:centos5.11

MAINTAINER kazuhito-m(Twitter:kazuhito_m)

# install tools. java6,ant,rpm-build,kernel-headers,build-essensials 
RUN yum update -y
RUN yum -y install java-1.6.0-openjdk.x86_64 ant rpm-build kernel-devel kernel-headers
# RUN yum -y groupinstall "Development Tools"

# custom install Git
RUN rpm -ivh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/5/x86_64/epel-release-5-4.noarch.rpm && yum install -y --enablerepo=epel git
