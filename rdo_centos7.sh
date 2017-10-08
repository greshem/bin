set -x 
yum install subversion  
svn co http://192.168.100.120/svn/bin /root/bin/

yum install -y  http://192.168.100.175/openstack-kilo/el7/rdo-release-kilo-1.noarch.rpm

#wget -c -r -np --reject=html,gif,A,D -nH https://repos.fedorapeople.org/repos/openstack/openstack-juno/epel-7/

#vim /etc/yum.repos.d/rdo-release.repo 
cp deploy/rdo-release.repo_my_local    /etc/yum.repos.d/rdo-release.repo 

yum clean all 
yum list > /root/yum_list 

yum install -y  openstack\*



yum install -y   openvswitch mariadb mariadb-server mongodb mongodb-server redis rabbitmq-server memcached xinetd nrpe   vim  crudini
 
service mariadb restart 
/usr/bin/mysqladmin -u root password 'password'

#bash deploy/kilo/keystone.sh 

#iptable -L 

#192.168.100.167 

