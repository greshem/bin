#!/usr/bin/perl
open(PIPE, "LANG=C df|") or die("df error \n");
for(<PIPE>)
{
	my @array=split(/\s+/, $_);
	my $mount_dir=$array[$#array];
	if(is_greshem_4t($mount_dir))
	{
		print  STDERR "4T mount dir is ";
		print "$mount_dir\n";
	}
}

sub is_greshem_4t($)
{
	(my $dir)=@_;	
	#print $dir."/sdb1\n";
	if( -d $dir."/sdb1"  && -d $dir."/sdb2" && -d $dir."/sdb3" && -d $dir."/sdb4")
	{
		#print "FFFF: $dir\n";
		return $dir;
	}
	return undef;
}
