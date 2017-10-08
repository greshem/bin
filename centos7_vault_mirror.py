#!/usr/bin/python
DATA="""
7.0.1406  7.1.1503  7.1.sh  7.2.1511  7.3.1611  
set -x 
wget -c -r -np --reject=html,gif,A,D,iso -nH  http://vault.centos.org/7.0.1406/
wget -c -r -np --reject=html,gif,A,D,iso -nH  http://vault.centos.org/7.1.1503/
wget -c -r -np --reject=html,gif,A,D,iso -nH  http://vault.centos.org/7.2.1511/
wget -c -r -np --reject=html,gif,A,D,iso -nH  http://vault.centos.org/7.3.1611

"""
print DATA;
