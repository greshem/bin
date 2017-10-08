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
	@files= glob("c:\\bin\\*.exe");
	#push(@files, glob('c:/bin/*.exe'));
	push(@files,  glob("c:\\cygwin\\bin\\*.exe"));
	push(@files,  glob("c:\\WINDOWS\\*.exe"));
	push(@files,  glob("c:\\WINDOWS\\system32\\*.exe"));
	push(@files,  glob("c:\\WINDOWS\\system32\\*.cpl"));
	push(@files,  glob("c:\\WINDOWS\\system32\\*.msc"));
	push(@files, glob('C:/MPlayer_Windows/*.exe'));
	push(@files, glob("c:\\windows\\MPSReports\\Cluster\\bin\\*.exe"));

	push(@files, glob('C:/Program\ Files/Vim/vim72/*.exe'));
	push(@files, glob('C:/Python26/*.exe'));
	push(@files, glob('C:/Ruby192/bin/*.exe'));
	push(@files, glob('c:/Perl/bin/*.exe'));
	push(@files, glob('C:/Program\ Files/Bakefile/*.exe'));
	push(@files, glob('C:/Program\ Files/Wireshark/*.exe'));
	push(@files, glob('C:/Program\ Files/Ext2Fsd/*.exe'));
	push(@files, glob('C:/Program\ Files/Subversion/bin/*.exe'));
	push(@files, glob('C:/Program\ Files/HTML Help Workshop/*.exe'));
	push(@files, glob('C:/Program\ Files/WinCDEmu/*.exe'));
	push(@files, glob('C:/Program\ Files/WinRAR/*.exe'));
	push(@files, glob('C:/Program\ Files/Debugging Tools for Windows /(x86/)/*.exe'));
	push(@files, glob('C:/Leakdiag/*.exe'));
	push(@files, glob('C:/Program Files/Microsoft Visual Studio/COMMON/MSDev98/Bin/*.exe'));
	
	push(@files, glob('C:/Program\ Files/Microsoft/VSSSDK72/Tools/VSSReports/*.exe'));
	push(@files, glob('C:/Program\ Files/Microsoft/VSSSDK72/Tools/VSSReports/vssreports/*.exe'));

	push(@files, glob('C:/Program\ Files/Windows\ Resource\ Kits/Tools/*.exe'));
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
