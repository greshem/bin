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
}
elsif ($^O =~/mswin32/i)
{
	#print "this is windows32\n";
	#<STDIN>;
	@files= glob("c:\\bin\\*.dll");
	#push(@files, glob('c:/bin/*.dll'));
	push(@files,  glob("c:\\cygwin\\bin\\*.dll"));
	push(@files,  glob("c:\\WINDOWS\\*.dll"));
	push(@files,  glob("c:\\WINDOWS\\system32\\*.dll"));
	push(@files,  glob("c:\\WINDOWS\\system32\\*.cpl"));
	push(@files,  glob("c:\\WINDOWS\\system32\\*.msc"));
	push(@files, glob('C:/MPlayer_Windows/*.dll'));
	push(@files, glob("c:\\windows\\MPSReports\\Cluster\\bin\\*.dll"));

	push(@files, glob('C:/Program\ Files/Vim/vim72/*.dll'));
	push(@files, glob('C:/Python26/*.dll'));
	push(@files, glob('C:/Ruby192/bin/*.dll'));
	push(@files, glob('c:/Perl/bin/*.dll'));
	push(@files, glob('C:/Program\ Files/Bakefile/*.dll'));
	push(@files, glob('C:/Program\ Files/Wireshark/*.dll'));
	push(@files, glob('C:/Program\ Files/Ext2Fsd/*.dll'));
	push(@files, glob('C:/Program\ Files/Subversion/bin/*.dll'));
	push(@files, glob('C:/Program\ Files/HTML Help Workshop/*.dll'));
	push(@files, glob('C:/Program\ Files/WinCDEmu/*.dll'));
	push(@files, glob('C:/Program\ Files/WinRAR/*.dll'));
	push(@files, glob('C:/Program\ Files/Debugging Tools for Windows /(x86/)/*.dll'));
	push(@files, glob('C:/Leakdiag/*.dll'));
	push(@files, glob('C:/Program Files/Microsoft Visual Studio/COMMON/MSDev98/Bin/*.dll'));
	
	push(@files, glob('C:/Program\ Files/Microsoft/VSSSDK72/Tools/VSSReports/*.dll'));
	push(@files, glob('C:/Program\ Files/Microsoft/VSSSDK72/Tools/VSSReports/vssreports/*.dll'));

	push(@files, glob('C:/Program\ Files/Windows\ Resource\ Kits/Tools/*.dll'));

 	push(@files, "C:/WINDOWS/system32/drivers/*.sys");
}


my @result;
for $_ (@files)
{
	#print $each
	if($_=~/$pattern/i)
	{
		print "\"".$_."\"\n";
		push(@result, $_);
	}
}

print "########################################################################\n";
#打印 explorer 
for(@result)
{
	print "explorer /select,$_\n";
}
