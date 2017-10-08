#!/usr/bin/perl
#
#  iso_copy_out_to_desktop.pl "sdb1:\sdb1\software_ext_iso\gentoo_portage_ISO_16_iso.iso\\net-mail\\qpopper\\qpopper4.1.0.tar.gz"
#
if(! -f  "/tmp3/linux_src/qpopper4.1.0.tar.gz")
{
	system(" wget http://mirrors.163.com/gentoo/distfiles//qpopper4.1.0.tar.gz -O /tmp3/linux_src/qpopper4.1.0.tar.gz  ");
}
if(! -f  "/tmp3/linux_src/qpopper4.1.0/popper/popper"   ) 
{
    system(" tar -xzvf /tmp3/linux_src/qpopper4.1.0.tar.gz  -C /tmp3/linux_src/ \n");
    system(" cd /tmp3/linux_src/qpopper4.1.0/ &&    ./configure  --enable-standalone     && gmake  ");
}


system("  cp  /var/spool/mail/root  /var/spool/mail/test ");
system("  /tmp3/linux_src/qpopper4.1.0/popper/popper  -S -t  /tmp/bbb.log \n");


#COMMAND   PID USER   FD   TYPE   DEVICE SIZE/OFF NODE NAME
#popper  24243 root    5u  IPv4 51823543      0t0  TCP *:pop3 (LISTEN)
#popper  24243 root    6u  IPv6 51823544      0t0  TCP *:pop3 (LISTEN)
my $buffer=` lsof -i:110 `;
if($buffer!~/popper.*pop3/)
{
	die(" popper  ERRRO \n");
}
print $buffer;

telnet_check();
getmail_check();

##################################################
sub getmail_check()
{
	open(FILE, "/root/.getmail/qpopper.conf") or die(" getmail qpopper.conf error \n");
	print <<EOF

[options]
verbose = 1
delete = false
message_log = /tmp/getmail.log

[retriever]
type = SimplePOP3Retriever
server =  localhost
username = test
password = Emotibot1

[destination]
type = Maildir
path = /tmp/mail_dir/
path_commit= path  must be absolute  
EOF
;
	close(FILE);
	
	print "OK: /root/.getmail/qpopper.conf \n";
	print "INFO:  yum install getmail \n";
	print "CMD to test :  getmail -r  /root/.getmail/qpopper.conf   \n";
}

sub telnet_check()
{
print <<EOF
telnet  localhost 110 
user test
pass  Emotibot1
list 
retr   1  # 获取 邮件. 
retr   2  # 获取 邮件. 
top       #获取邮件 的 前 n行. 
EOF
;
}
