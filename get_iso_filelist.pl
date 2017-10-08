#!/usr/bin/perl
#2011_01_31_17:32:02 add by greshem
foreach (glob("*.iso"))
{
	if( /.*([\x80-\xff]+).*/  )
	{
		#print $_,"\n";	
		next;
	}
	
	print "#".$_,"\n";
	$dir=$_;
	$dir=~s/\.iso$//g;
	$listfile=$dir.".txt";

	if( ! -f $listfile)
	{
		print "mkdir ".$dir."\n";
		print "mount -t iso9660 ".$_." \t".$dir."  -o loop \n";
		print "find ".$dir." > ".$listfile."\n";	
		print "umount ".$dir."\n";
		print "rm -rf $dir\n";
	}
}
