#!/usr/bin/perl
$number=0;
$file=shift;
($name, $suffix)=($file=~/(.*)\.(.*$)/);
if(! defined($name))
{
	$name=$file;
}
$tofile;

while(1)
{
	if(defined($suffix))
	{
	$tofile=$name."_".$number.".".$suffix;
	}
	else
	{
	$tofile=$name."_".$number;
	}
	if(! -f $tofile)
	{
		last;
	}
	$number++;
}

print "cp ",$file, "\t", $tofile,"\n"; 
