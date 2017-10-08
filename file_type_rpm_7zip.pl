#!/uer/bin/perl

if($^O=~/win32/i)
{
	check_7zip();
}

#sub file_type_cmd_dum_lib()
for(glob("*.rpm"))
{
	my $line=$_;
	(my $name)=($line=~/(.*).rpm/i);	

	if($^O=~/win32/i)
	{
		print "7z x $name.rpm  \n";
		mkdir($name);
		print "7z -o$name x $name.cpio   \n"
	}
	else
	{
		print "/bin/q_rpm2targz.sh $line \n";
	}
}

sub check_7zip()
{

	system("7z.exe ");
	if($?>>8 ne 0)
	{
		warn("7z.exe ²»´æÔÚ , \n");
		put_7z_to_system_path();
	}

}

sub put_7z_to_system_path()
{
	for(<DATA>)
	{
		print $_;
	}
}

__DATA__


c:\bin\program_files_get_all_exe.pl |grep 7z

"c:\Program Files\7-Zip\7z.exe"
"c:\Program Files\7-Zip\7zFM.exe"
"c:\Program Files\7-Zip\7zG.exe"

#==========================================================================
#c:\bin\add_prog_bin_path_to_ENV_PATH.pl "c:\Program Files\7-Zip\"
#
#
