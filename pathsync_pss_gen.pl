#!/usr/bin/perl


if($^O=~/win/i)
{
	do("c:\\bin\\repaire_perl_path_2_win32.pl");
	do("c:\\bin\\iso_get_mobile_disk_label.pl");
	do("c:\\bin\\repaire_perl_path_2_win32.pl");
}
else
{
	do("/bin/iso_get_mobile_disk_label_linux.pl");
	#do("iso_get_mobile_disk_label.pl");
}
my $cur_month= get_MM_month();

my $cur_month_x_file;
if($^O=~/win/i)
{
	$cur_month_x_file = change_mobile_path_to_win_path("sdb1:\\sdb1\\_xfile\\2013_all_iso\\_xfile_2013_$cur_month");
}
else
{
	$cur_month_x_file = change_mobile_path_to_linux_path($isoname);
}


my $dest_disk=undef;
for(a..z)
{
	if (-d "$_:\\sdb1_bak")
	{
		print "#BACKUP_disk -> $_ \n";
		$dest_disk=$_;
	}
}
if(!defined($dest_disk))
{
	warn "#ERROR: mobile disk   which contains dir \"sdb1_bak\"  not found \n";
}
$dest_month_x_file=$cur_month_x_file;
$dest_month_x_file=~s/^./$dest_disk/;
$dest_month_x_file=~s/\\sdb1\\/\\sdb1_bak\\/;

print $cur_month_x_file."\n";
print $dest_month_x_file."\n";

gen_pathsync_pss_config($cur_month_x_file, $dest_month_x_file);


#defbeh=1 local -> remoate ²»É¾³ý Ô¶¶ËµÄ. 
sub gen_pathsync_pss_config($$)
{
	mkdir("c:\\log");
	(my $local, $remote)=@_;
	open(PSS, ">pathsync_month.pss") or die("create PSS file error\n");
	print PSS <<EOF
[pathsync settings]
pssversion=1
path1=$local
path2=$remote
ignflags=0
defbeh=1
logpath=c:\\log\\path_sync_frequency.log
include=
throttlespd=1024
throttle=0
syncfolders=1
	
EOF
;
}

sub get_MM_month()
{
	use POSIX 'strftime';
	my $today=POSIX::strftime('%m',localtime(time()));
	return $today;
}

