#!/usr/bin/perl

my $count=0;
for(glob("*"))
{
	if( /.*([\x80-\xff]+).*/  )
	{
		#print $_,"\n";	
		if(! -f $count )
		{
			system("mv $_ $count  ");
		}
	}
	$count++;
}
