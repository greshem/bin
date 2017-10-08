#!/usr/bin/perl

system ('iso_copy_out_to_desktop.pl "sdb2:\\oss_site_all_iso\\_oss_site_all_1.iso\\du.list" ');

chdir("P:\\cygwin\\http%3a%2f%2fmirrors.kernel.org%2fsourceware%2fcygwin\\setup.exe");
system("P:\\cygwin\\http%3a%2f%2fmirrors.kernel.org%2fsourceware%2fcygwin\\setup.exe");

sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, "> d:\\log\\cygwin_install.log");
	}
	else
	{
		open(FILE, "> /var/log/cygwin_install.log");
	}

		print FILE $log_str;
		close(FILE);
}


