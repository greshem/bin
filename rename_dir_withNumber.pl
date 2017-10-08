#!/usr/bin/perl
my $count=0;
while(<*>)
{
if(-d $_)
{
	#my $count=getDirCount($_);
	$count++;
	if(!/\d$/)
	{
		#print "mv ",$_, "    ",$count,"_",$_,"\n";
		print "mv ".$_." ".$count."\n";
	}
}

}

sub  getDirCount($)
{
	(my $dir)=@_;
	opendir(DIR, $dir);
	@dirs=grep { -d $dir."/".$_} readdir(DIR);
	return scalar(@dirs);
}
