#!/usr/bin/perl
$ip=shift or die("Usage: $0 ip\n");
mkdir("/nfs/");
mkdir("/nfs/$ip");
$command="showmount -e $ip";
$tmp=`$command`;
for(split(/\n/, $tmp))
{
	#print $_,"\n";
	if(/^(\/\S+)\s+\S+/)
	{
		#print "mkdir /nfs/$ip/$1\n";
		$path=$1;
		$name=$1;
		$name=~s/\//_/g;
		mkdir("/nfs/$ip/$name");
		print "mount -t nfs $ip:$path   /nfs/$ip/$name\n";
	}
} 
