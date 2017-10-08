#!/usr/bin/perl 
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
#fcopy("/etc/passwd", "/tmp/bbb/bbb/bbbZ");
	mkdir("h:\\photo_split");
for $each (grep {-f} glob("*.iso"))
{
	system(" batchmnt64.exe /unmountall   s:  ");
	system(" perl c:\\bin\\iso_mount_win.pl    $each ");

	my $name=$each;
	$name=~s/\.iso$//g;
	print " dircopy S:\\ -> h:\\photo_split\\$name \n";
	dircopy("S:\\", "h:\\photo_split\\$name");
}

