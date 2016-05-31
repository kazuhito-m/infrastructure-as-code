#!/bin/bash
docker build -t centos:5.11-java6-rpmbuild .
docker run -i --name centos511test -t centos:5.11-java6-rpmbuild /bin/bash
