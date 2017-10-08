#!/usr/bin/perl
$g_piso_path="\"C:\\Program Files\ (x86)\\PowerISO\\piso.exe\"";

#输入: 
#Drive [F:] H:\sdb1\_xfile\2012_all_iso\_xfile_201211\_pre_cache_2012_10_01.iso
#Drive [I:] h:\sdb2\linux_iso_windows\fedora_all\Fedora_12-i386-DVD.iso
sub get_listvd()
{
	my %letters;
	open(CMD, " $g_piso_path listvd |") or die(" piso.exe faulure $!\n");
	for(<CMD>)
	{
		if($_=~/.*Drive \[(\S):\] .*/)
		{
			#print $1."\n";;
			$letters{$1}=1;
		}
		#print $_;
	}
	return %letters;
}
sub set_one_virtual_iso_drv()
{
		system("$g_piso_path  setvdnum 1  ");
}

########################################################################
#mainloop 
my %hash=get_listvd();
if(scalar(keys(%hash)) == 0)
{
	print "没有设置虚拟光驱数量, 这里设置为1个\n";
	set_one_virtual_iso_drv();
}
else
{
	print join("|", keys(%hash));
	print "\n";
}

%hash=get_listvd();
my @letters=keys(%hash);
my $input_iso=shift; 
if(defined($input_iso))
{
	print "$g_piso_path  mount $input_iso  $letters[0] \n";
	print "ie.pl $letters[0]:\\ \n";
}
else
{
	for(@letters)
	{
		print "$g_piso_path  unmount  $_ \n";
	}

	print "$g_piso_path unmount all \n";
	print "$g_piso_path listvd \n";
	print "$g_piso_path setvdnum 1 \n";
}
