#!/usr/bin/python
#coding=utf-8

DATA="""

http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1701.qcow2.xz


#密码的修改 

#guestfish -a rhel-7-server-guest-image.qcow2
guestfish -a  /tmp3/images/CentOS-7-x86_64-GenericCloud-1701.qcow2
<fs> run
<fs> list-filesystems
<fs> mount /dev/sda1 /
<fs> vi /etc/shadow
#==========================================================================
vi /etc/ssh/sshd_config  PermitRootLogin

#==========================================================================
把 自己电脑上的 /etc/passwd 的 第一行的 root 粘贴到  镜像里面的 第一行 
vi /etc/password

umount /
exit 

##########################################################################
#另外一种方式:
yum install   libguestfs-devel
pip install http://libguestfs.org/download/python/guestfs-1.36.2.tar.gz
python //tmp3/bin/guestfish/mdf_image.py


"""
print DATA;
