#!/usr/bin/perl
use POSIX 'strftime';
$month=POSIX::strftime('%Y%m',localtime(time()));
for (grep { -f  && !/pl$/} (glob("*")))
{
	$to_dir1="/media/sdb1/_x_file/xfile_$month/";
	if( ! -d $to_dir1)
	{
		print "mv $_  _xfile_$month/ \n";
	}
	else
	{
		print "mv $_ $to_dir1\n";
	}
}
