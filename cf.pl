#!/usr/bin/perl
#2011_06_21_15:03:04   星期二   add by greshem
#命令的操作的函数. 
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


	push(@files,  glob("/root/bin/*.pl"));
	push(@files,  glob("/root/bin/*.sh"));
	push(@files,  glob("/root/bin/*.php"));
	push(@files,  glob("/root/bin/*.py"));

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
	push(@files,  glob("c:\\bin\\*.exe"));
	push(@files,  glob("c:\\bin_exe\\*.exe"));
	push(@files,  glob("C:\\cygwin\\bin\\*.exe"));
}
elsif($^O=!/cygwin/i)
{
	#print "this is cygwin\n";
	#<STDIN>;
	@files= glob("/cygdrive/c/bin/*.pl");
	push(@files,  glob( "/cygdrive/c/bin/*.sh"));
	push(@files,  glob( "/cygdrive/c/bin/*.php"));
	push(@files,  glob( "/cygdrive/c/bin/*.py"));
	push(@files,  glob( "/cygdrive/c/bin/*.bat"));
	push(@files,  glob( "/cygdrive/c/bin/*.exe"));
}


my @result;
for $_ (@files)
{
	#print $each
	if($_=~/$pattern/i)
	{
		print $_."\n";
		push(@result, $_);
	}
}

print "########################################################################\n";
#打印 explorer 
if($^O=~/win/i)
{
	for(@result)
	{
		print "explorer /select,$_\n";
	}
}
else
{
	print " command_find.pl $pattern \n";
	print " perl_inc_goto.pl  $pattern \n";
}
