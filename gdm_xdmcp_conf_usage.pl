#!/usr/bin/perl
common_usage();
sub common_usage()
{
	foreach (<DATA>)
	{
		print $_;
	}
}
__DATA__

#==========================================================================
#as6 f13
[daemon]
[security]
	AllowRemoteRoot = 1
	DisallowTCP = 0 
[xdmcp]
	Enable = 1
[greeter]
[chooser]
#��־�ļ����д���� /var/log/messages
[debug]
	Enable=true

#==========================================================================
#as5
[daemon]
[security]
	AllowRemoteRoot=true
	DisallowTCP=false
[xdmcp]
	Enable=true
[gui]
[greeter]
[chooser]
[debug]
	Enable=true
[servers]

#==========================================================================
#gdm ��root ��½.
sed '/root\s+quiet/{s/^/#/}' -i /etc/pam.d/gdm -i 
sed '/root\s+quiet/{s/^/#/}' -i /etc/pam.d/gdm-fingerprint -i
sed '/root\s+quiet/{s/^/#/}' -i /etc/pam.d/gdm-password -i
sed '/quiet/{s/^/#/}' -i /etc/pam.d/gdm* 
