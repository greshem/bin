#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

[global]  
workgroup = WORKGROUP  
server string = Samba Server %v  
netbios name = centos  
security = share
map to guest = bad user  
dns proxy = no  

[_tmp_]
path= /tmp
        writeable  = yes 
        browseable = yes 
        guest ok   = yes 
        public     = yes 
		case sensitive = yes 


