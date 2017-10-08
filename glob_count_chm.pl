#!/usr/bin/perl
for $each (grep {-d} glob("*")   )
{
	if(count_chm($each) == 0)
	{
		print $each."   #chm is empty \n";
	}	
}
sub  count_chm($)
{
	(my $input_dir)=@_;
	@chms=glob("$input_dir/*.chm");
	return scalar(@chms);
}
