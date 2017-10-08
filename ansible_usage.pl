#!/usr/bin/perl
$pattern=shift;

gen_cfg_file();
get_ansible_hosts();

foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}


########################
sub  gen_cfg_file()
{
    mkdir("/etc/ansible");
	if( -f "/etc/ansible/ansible.cfg")
	{
		print "/etc/ansible/ansible.cfg, exists  skip \n";
		return ;
	}

	open(FILE, ">/etc/ansible/ansible.cfg" ) or die("create file error \n");
	print FILE <<EOF
[defaults]
hostfile= /etc/ansible/hosts  
EOF
;
	close(FILE);
	print "/etc/ansible/ansible.cfg, generated  \n";
}

sub get_ansible_hosts()
{
	if( -f  "/etc/ansible/hosts")
	{
		print "/etc/ansible/hosts, exists  skip \n";
		return ;
	}
	open(FILE, ">/etc/ansible/hosts" ) or die("create file error hosts  \n");
	print FILE <<EOF
[all]
 192.168.1.18  
 192.168.1.19  
 192.168.1.24  
 192.168.1.25  
 192.168.1.26  
 192.168.1.29  
 192.168.1.30  
 192.168.1.32  
 192.168.1.34  
 192.168.1.36  
 192.168.1.38  
 192.168.1.41  
 192.168.1.42  
 192.168.1.43  
 192.168.1.44  
 192.168.1.45  
 192.168.1.49  

EOF
;
	close(FILE);
	print "#/etc/ansible/hosts, generated  \n";
}

__DATA__

ansible all -m shell -a "uptime"
ansible all -m shell -a "bash /data/creat.sh "
ansible all -m shell -a "service ceph restart  "

#copy  my /etc/hosts  to  group 'all'   /tmp/hosts  
ansible all  -m copy -a "src=/etc/hosts dest=/tmp/hosts" 

#Ìí¼Ó·Ö¸ô·û: 
#
294:  /usr/lib/python2.7/site-packages/ansible/callbacks.py
	def command_generic_msg(hostname, result, oneline, caption):
    def command_generic_msg(hostname, result, oneline, caption):


#deploy 
ansible-playbook -i /usr/share/kolla/ansible/inventory/all-in-one -e @/etc/kolla/globals.yml -e @/etc/kolla/passwords.yml -e CONFIG_DIR=/etc/kolla  -e action=deploy /usr/share/kolla/ansible/site.yml 

# kolu-ansiable pull
ansible-playbook -i /usr/share/kolla/ansible/inventory/multinode -e @/etc/kolla/globals.yml -e @/etc/kolla/passwords.yml -e CONFIG_DIR=/etc/kolla -e action=pull /usr/share/kolla/ansible/site.yml

