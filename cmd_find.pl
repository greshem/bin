#!/usr/bin/perl
#2011_06_21_15:03:04   ���ڶ�   add by greshem
#����Ĳ����ĺ���. 
$pattern=shift;
if(! defined($pattern))
{
	$pattern=".";
}

my @files;
if ( $^O  =~/linux/)
{
	#print "this is linux \n";
	@files= glob("/bin/*.pl");
	push(@files,  glob("/bin/*.sh"));
	push(@files,  glob("/bin/*.php"));
	push(@files,  glob("/bin/*.py"));
}
elsif ($^O =~/mswin32/i)
{
	#print "this is windows32\n";
	#<STDIN>;
	@files= glob("c:\\bin\\*.pl");
	push(@files,  glob("c:\\bin\\*.sh"));
	push(@files,  glob("c:\\bin\\*.php"));
	push(@files,  glob("c:\\bin\\*.py"));
	push(@files,  glob("c:\\bin\\*.bat"));

}


for $_ (@files)
{
	#print $each
	if($_=~/$pattern/i)
	{
		print $_."\n";
	}
}
