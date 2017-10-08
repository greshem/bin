#!/usr/bin/perl
while(<STDIN>)
{
$tmp_str=$_;

		if($tmp_str=~/^\d/)
		{
			#格式如下面的
			#2009105(849)," 2009-9-8 ",10,16,02,27,30,08,15,208614594
#			print $tmp_str,"\n";
			@a=split(/\,/,  $tmp_str);
			print  $a[0],"\t";
			print "\t", $a[1],"\t";
			my @red;
			for( 2..7)
			{
			push(@red, $a[$_]);
			}
			@red_sort=	sort(@red);
			print_red(@red_sort);
			#print "red ", Dumper(@red_sort);
			print " \t",$a[8], "\t";
			print " \t",$a[9];
		}
	
}

sub print_red(@)
{
	(@red)=@_;
	print "red ";
	for(@red_sort)
	{
		print $_,"  ";
	}

}

