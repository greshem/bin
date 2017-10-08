#!/usr/bin/perl

 check("/bin/ls");
check("/usr/bin/xterm");
for (glob("/usr/sbin/*"))
{
	check($_);
}

for (glob("/usr/bin/*"))
{
	check($_);
}

sub check()
{
	(my $file)=@_;
	my @line=`ldd $file`;
	my @qt=grep {/libQt/} @line;	
	my @x11= grep {/libX/} @line;
	my $count=scalar(@qt) + scalar(@x11);
	if($count ==0)
	{
		#print ("$file is console \n");
		return 1;
	}
	else
	{
		print (" $file  is GUI, count=$count \n");
		return undef;
	}
}
