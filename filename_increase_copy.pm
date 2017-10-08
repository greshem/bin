#!/usr/bin/perl
$number=0;
#use Strict;
sub filename_increase_copy($)
{
	($file)=@_;
	my $tofile;
	$tofile=$file;
	if( ! -f $tofile)
	{
		return $tofile;
	}
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
	return $tofile
}
1;
#$filt=shift; 
#print "cp ",$file, "\t", filename_increase_copy($file),"\n"; 
