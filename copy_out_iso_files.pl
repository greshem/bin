#!/usr/bin/perl
#2011_03_28_14:45:21   ����һ   add by greshem
foreach (glob("*.iso"))
{
	#���ĵ��Թ�. 
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
		#print "mkdir ".$dir."\n";
		print "#==========================================================================\n";
		print "mkdir tmp  \n";
		print "mount -t iso9660 ".$_." \t tmp   -o loop \n";
		#print "find ".$dir." > ".$listfile."\n";	
		print "cp -a -r tmp $dir \n";
		print "umount tmp  \n";
		#print "rm -rf $dir\n";
	}
}
