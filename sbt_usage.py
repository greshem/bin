#!/usr/bin/python
DATA="""
PATH=$PATH:/root/linux_src/sbt/bin
#from gentoo portage 
sbt         package 
sbt clean   package 

http://greshem.51vip.biz:44444/download/sbt-0.13.15.tgz

"""
print DATA;
