#!/usr/bin/perl
centos7_usage();
centos5_2_usage();
redhat_9_usage();

sub centos7_usage()
{
	print <<EOF
	referance  with  /root/bin/vsftpd/0_init.sh 
EOF
;
}
sub centos5_2_usage()
{
print <<EOF
#centos5_2 ok, rhel6_2 ok 
cd /etc/vsftpd/
sed '/root/{s/^/#/g}' ftpusers -i 
sed '/root/{s/^/#/g}' user_list -i 
iptables -F 
service vsftpd restart 
EOF
;

}

sub redhat_9_usage()
{
	print <<EOF
#redhat 9.0 ok 
#allow local users to log in. 

	sed '/local_enable/{s/#//g}' /etc/vsftpd/vsftpd.conf
	#anomymouse_enable=NO

	sed '/root/{s/^/#/g}' /etc/vsftpd.ftpusers -i 
	sed '/root/{s/^/#/g}' /etc/vsftpd.user_list -i 

EOF
;
}
