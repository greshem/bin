#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

Server: 
	fileZilla_Server_xml.pl 

Client: 
lftp  -e  "mirror d_ntfs_3g_fuse_rhel5/"   root@192.168.21.1:/sdb1/_xfile/2013_all_iso/_xfile_2013_04/_d_frequent_1 


