#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#�г�����.
smbclient  -L    192.168.1.100 -U user%passwd ;
smbclient  -L    172.16.1.18 -U tnsoft\zjqian     #error \ -> \\
smbclient  -L    172.16.1.18 -U tnsoft\\zjqian     #ok


#==========================================================================
#��½ ��ȡ ����.
smbclient    //192.168.1.12/root/  -U administrator
smbclient    //172.16.1.18/root/  -U tnsoft/zjqian



 
