#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

git clone https://github.com/ninghao/playbook
cd playbook/

cp  -a -r  config_default/   config/
ansible-playbook --list-tasks local.yml 


ansible-playbook -i /usr/share/kolla/ansible/inventory/all-in-one -e @/etc/kolla/globals.yml -e @/etc/kolla/passwords.yml -e CONFIG_DIR=/etc/kolla  /usr/share/kolla/ansible/prechecks.yml 

