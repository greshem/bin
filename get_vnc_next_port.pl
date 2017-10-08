#!/usr/bin/perl
sub get_next_port()
{
	for $each (5900..6100)
	{
		$ret=`lsof -i:$each -n -P `;
		if($ret!~/listen/i)
		{
			my $port= ($each-5900);
			#print $port;
			return $port
		}
	}
	return 0;
}
#/bin/get_vnc_next_port.pl
if($0=~/get_vnc_next_port.pl$/)
{
	print get_next_port()."\n";
}
