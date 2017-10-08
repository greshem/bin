#!/usr/bin/perl
use File::Find;
use Cwd;
use vars qw(*name);

$dir=shift or die("Usage: $0 dir depth\n");
our $depth= shift or die("Usage: $0 dir depth\n");
$depth++;
our $printDepth=undef;
if(grep{/print|depth/} @ARGV)
{
	$printDepth=1;
}
*name=*File::Find::name;

our @globalFileList;
sub wanted()
{
	if ( -f $_)
	{
		$cwd=cwd();
		@array=split(/\//, $name);

		print "Depth ", scalar(@array),"\n" if($printDepth);
		if(scalar(@array) == $depth)
		{
			push(@globalFileList, $name);
			print $name,"\n";
		}
	}
}

sub getAllFileFromDir($)
{
	(my $in)=@_;
	File::Find::find({wanted=>\&wanted}, $in);
	#map{print $_,"\n"} @globalFileList;
	return @globalFileList;
}

getAllFileFromDir($dir);
#for( @globalFileList)
{
#	print $_,"\n";
}

