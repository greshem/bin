#!/usr/bin/perl
use Win32::GuiTest qw(:ALL);
if($^O=~/win32/i)
{
    do("c:\\bin\\iso_get_mobile_disk_label.pl");
}
else
{
    do("./iso_get_mobile_disk_label.pl");
}

$windbg_path="sdb1:\\_x_file\\frequent_\\windbg_x86_6.11.1.404.msi";
$win_path=change_mobile_path_to_win_path($windbg_path);
system("start  $win_path");
sleep(3);

while(1)
{
	find_next_and_click();
}

sub find_next_and_click()
{
	my @windows = FindWindowLike(undef, "^Debugging");
	foreach (@windows)
	{
		my @children = GetChildWindows($_);
		foreach my $title (  qw( next ))
		{
			my $c= get_next_control(@children);
			print "next µÄ¾ä±úÊÇ  $c\n";
			my ($left, $top, $right, $bottom) = GetWindowRect($c);
			MouseMoveAbsPix(($right+$left)/2,($top+$bottom)/2);
			#SendMouse("{LeftClick}");
			SendMouse("{RightClick}");
			sleep(1);
		}
	}
}
sub get_next_control(@)
{
	(my @windows)=@_;
	foreach (@windows)
	{
		my $title= GetWindowText($_);
		print "####".$title."\n";
		if($title=~/next/i)
		{
			return $_;
		}
	}
}
