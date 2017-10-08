#!/usr/bin/perl -w
#2011_01_20_ add by greshem
#2011_06_23_ 星期四 add by greshem6
#修改于 "快捷方式.pl"
use Win32::Shortcut;
sub create_shortcut_lnk($)
{
	(my $win_path)=@_;
	my $name;
	if($win_path =~/.*\\(.*)\.exe$/)
	{
		$name=$1;	
	}
	else
	{
		warn("not execute programs \n");
		return ;

	}
	$ApplicationName = $win_path ;
	$BaseName        = $name ;
	$lnk = new Win32::Shortcut();
	$lnk->{'Path'} = $ApplicationName;
	$lnk->{'Arguments'} = "";
	$lnk->{'WorkingDirectory'} = ".";
	$lnk->{'Description'} = "Launches application";
	$lnk->{'ShowCmd'} = SW_SHOWNORMAL;
	$lnk->Save( $BaseName . ".lnk" );
	$lnk->Close();
	print "create $win_path OK\n";

}
sub create_notepad()
{
	(my $win_path)=@_;
	$ApplicationName = 'c:\WINDOWS\system32\notepad.exe';
	$BaseName        = 'Notepad';
	$lnk = new Win32::Shortcut();
	$lnk->{'Path'} = $ApplicationName;
	$lnk->{'Arguments'} = "";
	$lnk->{'WorkingDirectory'} = ".";
	$lnk->{'Description'} = "Launches application";
	$lnk->{'ShowCmd'} = SW_SHOWNORMAL;
	$lnk->Save( $BaseName . ".lnk" );
	$lnk->Close();
}

sub create_cmd()
{
	$ApplicationName = 'c:\WINDOWS\system32\cmd.exe';
	$BaseName        = 'cmd';
	$lnk = new Win32::Shortcut();
	$lnk->{'Path'} = $ApplicationName;
	$lnk->{'Arguments'} = "";
	$lnk->{'WorkingDirectory'} = ".";
	$lnk->{'Description'} = "Launches application";
	$lnk->{'ShowCmd'} = SW_SHOWNORMAL;
	$lnk->Save( $BaseName . ".lnk" );
	$lnk->Close();
}

if ($^O=~/linux/i)
{
	die("cannot run in linux\n");
}
#create_notepad();
#create_cmd();
create_shortcut_lnk('c:\WINDOWS\system32\notepad.exe');
create_shortcut_lnk('c:\WINDOWS\system32\cmd.exe');
