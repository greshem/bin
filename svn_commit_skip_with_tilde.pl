#!/usr/bin/perl
open(FILE, "svn status |") or die("svn open error\n");
my $comment_str=join(" ", @ARGV);
my $file_str;
for(<FILE>)
{
	if($_=~/^M|^A|^D/)
	{
		my @array=split(/\s+/, $_);
		#print (join("|", @array))."\n";
		if($array[1]=~/\+/)
		{
			$file_str.=$array[2];	
			$file_str.=" ";
		}
		else
		{
			$file_str.=$array[1];	
			$file_str.=" ";

		}
	}
}
print "svn commit  -m \"".$comment_str."\" $file_str  \n";
