#!/usr/bin/perl

$total= `du -s -B 1`;
$total_M= int($total/1024/1024);
print "cur dir size = ", $total_M,"M\n";
if($total_M > 4400)
{
	print "big than a dvd iso\n";
} 

$delete_size=$total-4400*1024*1024;
if($delete_size < 0)
{
	print " cur dir < 4.4G\n";
	exit 0;
}
print "delete size =" , int($delete_size/1024/1024)."M\n";
system(" find -type f -name \*tar.gz > targz");
system(" /bin/file_sort_size.pl  targz nosize > sort_list");

#open(FILE, "sort_list") or die("open file error $!\n");
#$current_size=0;
#@delete_list;
#for(<FILE>)
#{
#	chomp;
#	$current_size+=-s $_;
#	push(@delete_list, $_);
#	if($current_size > $delete_size )
#	{
#		last;	
#	}	
#}

close(FILE);


#delete action. 
$have_delete_size=0;
use File::Basename;
%file;
open(FILE, "sort_list") or die("open file error $!\n");
open(OUTPUT, ">delete_list") or die("open file error $!\n");
for(<FILE>)
{
	print OUTPUT $_,"\n";
	chomp;
	$basename=basename($_);
	#这个文件其他目录一定有了。 
	if(defined ($file{$basename} ))
	{
		#需要删除这个文件。 
		$have_delete_size+= (-s $_);
		if($have_delete_size >=$delete_size)
		{
			last;
		}
		else
		{
	#	$have_delete_size+=(-s $_);
		print "rm -f $_\n";
		}
	}	
	else
	{
		#这个文件其他地方是没有的。 
		print "#first init $basename -> $_\n";
		$file{$basename}=$_;
	}
}
close(OUTPUT);
close(FILE);
print  "删除文件大小为 ", int($have_delete_size/1024/1024)."M\n";
