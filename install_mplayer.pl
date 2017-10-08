#!perl -w

#$Id: calc.pl,v 1.2 2007/12/15 21:35:13 pkaluski Exp $
#
# Written by Gabor Szabo <gabor@pti.co.il>
# An example how to access the built in calculator (calc.exe) of Windows.
# This code assumes your calulator defaults to the Standard view (and not the Scientific)



#use strict;

use Win32::GuiTest qw(:ALL);

# if (not @ARGV or 
#     ($ARGV[0] ne "keyboard" and  $ARGV[0] ne "mouse")) {
#     die "Usage: $0 [keyboard|mouse]\n" 
# }
our $type=shift;
if(!defined($type))
{
	$type="keyboard";
}
system "start F:\\_x_file\\frequent_\\MPlayer_all_setup.exe";
sleep(1);
my @windows = FindWindowLike(undef, "��װ");

if (not @windows) 
{
   die "û���ҵ���װ���� \n";
}
if (@windows > 1) 
{
   warn "�ж����װ����������,����û�й�ϵ \n";
}

if ( $type  eq "keyboard") 
{
	SendKeys("{ENTER}"); #��һ��.
	sleep(1);
	SendKeys("{ENTER}"); #��һ��
	sleep(1);
	SendKeys("{ENTER}"); #ȡ��
	sleep(14);			 #��װ������.
	SendKeys("{ENTER}");
	sleep(1);
   	my @children = GetChildWindows($windows[0]);
   	printf "Result: %s\n", WMGetText($children[0]);
   	#SendKeys("%{F4}");  # Alt-F4 to exit
}

if ($ARGV[0] eq "mouse") 
{
   my ($left, $top, $right, $bottom) = GetWindowRect($windows[0]);
   # find the appropriate child window and click on  it
   my @children = GetChildWindows($windows[0]);
   foreach my $title (qw(7 * 5 =)) 
   {
       my ($c) = grep {$title eq GetWindowText($_)} @children;
       my ($left, $top, $right, $bottom) = GetWindowRect($c);
       MouseMoveAbsPix(($right+$left)/2,($top+$bottom)/2);
       SendMouse("{LeftClick}");
       sleep(1);
   }
   printf "Result: %s\n", WMGetText($children[0]);
   
   MouseMoveAbsPix($right-10,$top+10);  # this probably depends on the resolution
   sleep(2);
   SendMouse("{LeftClick}");
}


