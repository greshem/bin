#!/usr/bin/perl
if($^O=~/linux/)
{
	print_in_linux();
}
else
{
	print_in_windows();
}
sub print_in_windows()
{
	for (glob("samdump2*.txt"))
	{
		print <<EOF
		\"C:\\Program Files (x86)\\ophcrack\\ophcrack_nogui.exe\"    -d J:\\sdb2\\Security_iso\\ophcrack-tables\\  -f $_  -t rainbow_spical_winxp
		\"C:\\Program Files (x86)\\ophcrack\\ophcrack_nogui.exe\"    -d J:\\sdb2\\Security_iso\\ophcrack-tables\\  -f $_  -t tables_vista_spical_NTHASH
		\"C:\\Program Files (x86)\\ophcrack\\ophcrack_nogui.exe\"    -d J:\\sdb2\\Security_iso\\ophcrack-tables\\  -f $_  -t tables_vista_free
		\"C:\\Program Files (x86)\\ophcrack\\ophcrack_nogui.exe\"    -d J:\\sdb2\\Security_iso\\ophcrack-tables\\  -f $_  -t tables_xp_free_fast
		\"C:\\Program Files (x86)\\ophcrack\\ophcrack_nogui.exe\"    -d J:\\sdb2\\Security_iso\\ophcrack-tables\\  -f $_  -t tables_xp_free_small
EOF
;
	}
}


sub print_in_linux()
{
	for (glob("samdump2*.txt"))
	{
		print <<EOF
		ophcrack -g  -d /mnt/ftp/sdb2/Security_iso/ophcrack-tables/ -f $_ -t rainbow_spical_winxp
		ophcrack -g  -d /mnt/ftp/sdb2/Security_iso/ophcrack-tables/ -f $_ -t tables_vista_spical_NTHASH
		ophcrack -g  -d /mnt/ftp/sdb2/Security_iso/ophcrack-tables/ -f $_ -t tables_vista_free
		ophcrack -g  -d /mnt/ftp/sdb2/Security_iso/ophcrack-tables/ -f $_ -t tables_xp_free_fast
		ophcrack -g  -d /mnt/ftp/sdb2/Security_iso/ophcrack-tables/ -f $_ -t tables_xp_free_small


EOF
;
	}
}
