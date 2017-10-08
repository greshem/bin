#!/usr/bin/perl
$pattern=shift;
if(!defined($pattern))
{
	list_perl_INC_PATH();
}
else
{
	search_perl_inc_with_pattern($pattern);
}

########################################################################
sub search_perl_inc_with_pattern($)
{
	(my $pattern)=@_;
	for (@INC)
	{
		for(  glob($_."/*"))
		{
			if($_=~/$pattern/i)
			{
				print "cd ".$_."\n";
			}
		}
	}

}

sub list_perl_INC_PATH()
{
	for (@INC)
	{
		if(-d $_)
		{
			print "cd  $_ ".$each." && ls -la \n";
		}
	}

}
