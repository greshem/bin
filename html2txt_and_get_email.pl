#!/usr/bin/perl
use HTML::FormatText;
use HTML::Parse;

if(scalar(@ARGV)==0)
{
	die("Usage: $0 dir1 dir2 dir 3...\n");
}
our @email;

for $each (@ARGV)
{
	@email=();
	opendir(DIR, $each) or die("opendir error\n");
	@tmp=grep { -f $each."/".$_ } readdir(DIR);
	@files=map{$tmpfile=$each."/".$_;$tmpfile;}@tmp;
	getEmailFromFiles(\@files);
	dumpEmail($each."/email.list");
	close(DIR);
}


sub getEmailFromFiles($)
{
	($files)=@_;
	my %hash;
	for (@{$files})
	{
		$html=parse_htmlfile($_);
		$formatter=HTML::FormatText->new(leftmargin=>0, rightmargin=>50);
		$ascii=$formatter->format($html);
		#print $ascii;
		@array=split(/\n/, $ascii);
		for $each (@array)
		{
			@array2=split(/\s+/, $each);
			for $each2 (@array2)
			{
				$hash{$each2}=1;
			}
		}
	}

	@email=grep(/@/, keys %hash);

	map {print $_,"\n";} @email;
}

sub dumpEmail()
{
	($file)=@_;
	open(EMAIL, ">".$file) or die("create $file error\n");
	for(@email)
	{
		print EMAIL  $_,"\n";	
	}
	close(EMAIL);
}
