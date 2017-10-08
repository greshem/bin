#!/usr/bin/perl
if( -f "Manifest")
{
	die("Manifest exists \n");
}
#open(PIPE, "find ./ -type f |grep tar.gz$|") or die("open pipe error \n");
for( grep {-f} glob("*"))
{
	if($_=~/tar.gz$|tar.bz2$|zip$|tgz$/)
	{
		append_to_mainifest($_);
	}

}
sub append_to_mainifest($)
{
	(my $input)=@_;
	open(OUTPUT, ">>Manifest") or die(" Manifest error \n");
	{
		print OUTPUT "DIST  $input  \n";
		print  "DIST  $input  \n";
	}
	close(OUTPUT);

}
