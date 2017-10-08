#!/usr/bin/perl
print <<EOF
cd /root/
wget http://download.oray.com/peanuthull/linux/phddns_centos_i386.tgz
wget http://download.oray.com/peanuthull/linux/phddns_centos_x86_64.tgz
cp /root/_xfile/linux_src/phddns-2.0.2.16556.tar.gz /root/
EOF
;

if (! -f "/etc/phlinux.conf")
{
	open(FILE , "> /etc/phlinux.conf") or die("create file error \n");
	print FILE <<EOF
[settings] 
szHost = PhLinux3.Oray.Net 
szUserID = greshem1983 
szUserPWD = q******************************n 
nicName = enp4s0 
szLog = /var/log/phddns.log 
EOF
;
	close(FILE);
}

print (" nohup /home/petty/root/root/phddns-2.0.2.16556/src/phddns   & ");
