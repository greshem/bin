#!/usr/bin/python
DATA="""
http://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud-1705.qcow2.xz

#tools
guestfish_get_ip.sh

# tools with  python 
python //tmp3/bin/guestfish/mdf_image.py

"""
print DATA;
