#!/usr/bin/perl
for(<*.htm>)
{
	if( -f $_)
	{
		getXunLeiUrl($_);
	}
}

sub getXunLeiUrl()
{
	(my $in) =@_;
	open(FILE, $in);
	while(<FILE>)
	{
		if(/(thunder.*?)\<br>.*/)
		{
			print $1,"\n";
		}
	}
	close(FILE);
}
