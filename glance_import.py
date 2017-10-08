#!/usr/bin/python
DATA = """
#--------------------------------------------------------------------------
curl -O https://download.fedoraproject.org/pub/fedora/linux/releases/24/CloudImages/x86_64/images/Fedora-Cloud-Base-24-1.2.x86_64.qcow2
glance --os-image-api-version 2 image-create --name 'Fedora-24-x86_64' --disk-format qcow2 --container-format bare --file Fedora-Cloud-Base-24-1.2.x86_64.qcow2

#--------------------------------------------------------------------------
curl -O http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1611.qcow2.xz
xz -d  CentOS-7-x86_64-GenericCloud-1611.qcow2.xz
glance --os-image-api-version 2 image-create --name 'centos7.3' --disk-format qcow2 --container-format bare --file  CentOS-7-x86_64-GenericCloud-1611.qcow2


"""
print DATA
