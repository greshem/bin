#!/usr/bin/perl    
use Filesys::DiskSpace;
	$dir="/";
	open(FILE,">/var/log/fection");
    ($fs_type, $fs_desc, $used, $avail, $fused, $favail) = df $dir;

	#print "fs_type = ", $fs_type, "fs_desc= ",$fs_desc, "used= ", $used, "avail = ", $avail, "fused= ", $fused, "favail = ",$favail,"\n";

	print FILE "my disk have USED =", int 100*$used/($used+$avail) ,"%\n";
	#exit int 100*$used/($used+$avail);
	close(FILE);
