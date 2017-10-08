#!/usr/bin/perl 

sub   method_1()
{
my 	@array= glob("*mp3");

	my $count2=0;
	my $count=0;
	my @tmps;
	for (@array)
	{
		$count++;
		if(($count %6 ) == 0 )
		{
			print "cat ".join("\t", @tmps)." >  $count2.mp3 \n";
			$count2++;
			@tmps=undef;
		}
		push(@tmps, $_);
	}
}
#"develop_perl/array_split_splice_shift_part.pl"
sub method_2()
{
	
	mkdir("output");
	my 	@array= glob("*mp3");
	my 	$count=0;
	while(scalar(@array) !=0)
	{
		my @tmp=splice(@array,0, 6);
		print "cat ".join("\t", @tmp)." > output/$count.mp3 \n";
		system("cat ".join("\t", @tmp)." > output/$count.mp3 \n");
		$count++;
	}
}
method_2();
