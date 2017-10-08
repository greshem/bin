#!/usr/bin/perl
do("c:\\bin\\find_shell_implement_in_perl.pl");
do("repaire_perl_path_2_win32.pl");


my @tmp= find_and_get_filelists("e:\\vmware","vmx\$");
#print @tmp."\n";

$vmrun_exe='C:\Program Files\VMware\VMware Workstation\vmrun.exe';


for (@tmp)
{
		print "\"".$vmrun_exe."\"\t   -T ws start   \"".repaire_to_win_path($_)."\"\n";
}




