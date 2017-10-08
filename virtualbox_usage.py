#!/usr/bin/python
DATA="""
#virtualbox rpm from  
wget http://download.virtualbox.org/virtualbox/5.1.14/VirtualBox-5.1-5.1.14_112924_el7-1.x86_64.rpm
rpm -ivh  VirtualBox-5.1-5.1.14_112924_el7-1.x86_64.rpm

#disable kvm 
virsh destroy  all_libvirt_kvm
rmmod  kvm-intel


#centos vagrant image 
http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1701_01.VirtualBox.box


# Vagrantfile  from /root/bin/vagrant/virtualbox
vagrant up 

"""
print DATA;
