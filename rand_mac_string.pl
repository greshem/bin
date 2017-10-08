#!/usr/bin/perl

sub randHEX
{
	my $randHEX=sprintf("%X", int(rand("255")));
	if (length($randHEX) == 1)
	{
		$randHEX="0".$randHEX;
	};
	return $randHEX;
};

sub rand_mac_str()
{
	#return rand_full_mac_str();
	return rand_broadcom_mac();
}

sub rand_full_mac_str()
{
	#return  &randHEX."-".&randHEX."-".&randHEX."-".&randHEX."-".&randHEX."-".&randHEX."\n";
	return  &randHEX.":".&randHEX.":".&randHEX.":".&randHEX.":".&randHEX.":".&randHEX;
}

#
sub rand_broadcom_mac()
{
	 return "DC:0E:".&randHEX.":".&randHEX.":".&randHEX.":".&randHEX;
}
if($0=~/rand_mac_string.pl$/)
{
	#print rand_mac_str(); 
	print rand_broadcom_mac(); 
}
