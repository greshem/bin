#!/usr/bin/perl
use Date::Pcalc qw(:all);
$prefix=shift or die("usage: $0 prefix");
for(1..356)
{
$nth=$_ * -1;
@array=Add_Delta_Days(Today(), $nth); 
$pre_nth_day= sprintf("%4s%2.2d%2.2d", $array[0],$array[1],$array[2]); 
print  $pre_nth_day."  \n";
	if( -d $prefix.$pre_nth_day)
	{
		print $prefix.$pre_nth_day,"\n";
		last;
	}
}
