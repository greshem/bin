#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#nfs serveer 
/root/bin/export_cur_dir_to_nfs.sh 
service rpcbind start
service nfs start

iptables -F 
