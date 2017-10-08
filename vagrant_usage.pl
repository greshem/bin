#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
vagrant package --base centos65-x86_64 --output bbb.vbox
VBoxManage  list vms


#==========================================================================
 git clone https://github.com/mitchellh/vagrant

#==========================================================================
vagrant box      - manage boxes
vagrant plugin   - manage plugins
vagrant init     - initialize a new Vagrantfile
vagrant up       - create/provision/start the machine
vagrant ssh      - ssh into the machine as user vagrant
vagrant suspend  - suspend the machine
vagrant resume   - resume the suspended machine
vagrant halt     - stop the machine
vagrant destroy   - remove the machine completely
########################################################################
#centos7 vbox download 
#list 
http://www.vagrantbox.es/

#example
https://github.com/CommanderK5/packer-centos-template/releases/download/0.7.2/vagrant-centos-7.2.box

########
# vagrant  rpm download 
#wget https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.rpm
#

#####
##centos
vagrant box add centos-6 https://download.gluster.org/pub/gluster/purpleidea/vagrant/centos-6.box --provider=libvirt

####
#centos7 images 
# https://atlas.hashicorp.com/viniciusfs/boxes/centos7/versions/1.0.1/providers/libvirt.box
# https://atlas.hashicorp.com/viniciusfs/boxes/centos7/versions/1.0.1/providers/libvirt.box
vagrant init viniciusfs/centos7; vagrant up --provider libvirt


###
yum install ruby-devel
yum install libvirt-devel
vagrant plugin install vagrant-libvirt
vagrant plugin list

 gem pristine ruby-libvirt --version 0.7.0
 gem install ruby-libvirt --version 0.7.0

 #OK
vagrant up --provider libvirt

