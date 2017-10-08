#!/usr/bin/perl
use File::Find;

use vars qw(*name);
*name=*File::Find::name;

our @globalFileList;
sub wanted()
{
	if ( -f $_)
	{
		push(@globalFileList, $name);
	}
}

sub getAllFileFromDir($)
{
	(my $in)=@_;
	File::Find::find({wanted=>\&wanted}, $in);
	#map{print $_,"\n"} @globalFileList;
	return @globalFileList;
}

1;

