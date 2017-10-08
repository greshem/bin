#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

dpkg-reconfigure   keyboard-configuration 
#PC 104  ,  US 


#extend fs 
raspi-config  
	expand file system 

#ssh root  login 
 /etc/ssh/sshd_config
 PermitRootLogin yes

#添加 
cp /root/bin/daemon/ssh_nat/ssh_phabricator.pl  /root/bin/daemon/ssh_nat/ssh_phabricator_raspi4.pl
#端口修改一下. 

# 修改启动一下.
rc-local


