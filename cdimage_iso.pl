#!/usr/bin/perl

use File::Basename;

use Cwd;
$pwd=getcwd();
print $pwd."\n";;

#print basename("/root/linux/bbb"); #½á¹ûÊÇ. bbb
if(!  -f "c:\\bin\\CDImage.exe" )
{
	#print("copy C:/Program\ Files\ \(x86\)/Richtech/CDImage_GUI/CDImage.exe   c:/bin/");
	print("copy C:\\Program\ Files\ \(x86\)\\Richtech\\CDImage_GUI\\CDImage.exe   c:\\bin\\\n");
	system("copy \"C:\\Program\ Files\ \(x86\)\\Richtech\\CDImage_GUI\\CDImage.exe\"   c:\\bin\\");
}

do("c:\\bin\\repaire_perl_path_2_win32.pl");

$pwd=repaire_to_win_path($pwd);
for $each (grep { -d }  (glob("*")))
{
	$basename= basename($each);
	#print "CDImage.exe  -l$basename     -n  -d   -m  $pwd\\$basename    $pwd\\$basename.iso \n";
	print "CDImage.exe  -l$basename     -n  -d   -m  $pwd\\$basename    D:\\${basename}.iso \n";
}
