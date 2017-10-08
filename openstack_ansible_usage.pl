#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

#git clone -b TAG https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible
git clone   https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible

# Change to the /opt/openstack-ansible directory, and run the Ansible bootstrap script:
cd /opt/
bash scripts/bootstrap-ansible.sh
