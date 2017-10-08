#!/usr/bin/perl
sub get_target()
{
	use Cwd;
	use File::Basename;
	$pwd=getcwd();
	print $pwd."\n";;
	$targetname=basename($pwd);
	#print $targetname."\n";;
	return $targetname;
}

#mfc
sub is_mfc_plat()
{
	if( -f "StdAfx.h")
	{
		return 1;
	}
	return undef;
}

sub get_rc()
{
	my $ret_str;
	@rc=grep{-f } glob("*.rc");
	for $each(@rc)
	{
		$ret_str="<win32-res>".$each."</win32-res>\n";
	}
	return $ret_str;
}


sub gen_bakefile($)
{
	(my $filename)=@_;
	($name)=($filename=~/(.*).cpp/);
	$target=get_target();
	$res_tag=get_rc();

	open(FILE, ">$target.bkl") or die("Open file error $!\n");
    #<include file="presets/wx.bkl"/>
	print FILE <<EOF
<?xml version="1.0" ?>
<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
<makefile>
	<exe id="$name"> 

            <app-type>console</app-type>
			<cxxflags>/D_DEBUG</cxxflags>
			<cxxflags>/DWINDOWSCODE</cxxflags>
			<cxxflags>/MTd</cxxflags>
			<cxxflags>/ZI</cxxflags>
			<ldflags>/NODEFAULTLIB:libcmt.lib</ldflags>
			<ldflags>/DEBUG</ldflags>
			<include>D:\\usr\\include</include>
			<include>D:\\usr\\include\\lmyunit</include>
			<threading>multi</threading>
			<lib-path>D:\\usr\\lib</lib-path>
			<sys-lib>kernel32</sys-lib>
            <sys-lib>user32</sys-lib>
			<sys-lib>gdi32</sys-lib>
			<sys-lib>winspool</sys-lib>
			<sys-lib>comdlg32</sys-lib>
			<sys-lib>advapi32</sys-lib>
			<sys-lib>shell32</sys-lib>
			<sys-lib>ole32</sys-lib>
			<sys-lib>oleaut32</sys-lib>
			<sys-lib>uuid</sys-lib>
			<sys-lib>odbccp32</sys-lib>
			<sys-lib>ws2_32</sys-lib>
			<sys-lib>gtest</sys-lib>
			<sys-lib>cppunitd</sys-lib>
			<sys-lib>unitcode</sys-lib>


		<sources>\$(fileList('$filename'))</sources> 
     </exe>
</makefile>


EOF
;	
	if( -f "build.bkl")
	{
	print ("#build.bkl 文件生成\n");
	}
}

sub gen_gtest_bat()
{
	open(FILE, "> one_step_gtest.bat");
	print FILE <<EOF

cmd_find.pl gtest
c:\\bin\\compile_gtest.pl
gen_bakefile_bkl.pl
bakefile -f msvc  build.bkl
nmake /f makefile.vc
EOF
;
}


for (glob("*.cpp"))
{
	print "Deal with $_\n";
	gen_bakefile($_);
	my $target=get_target();

	system("bakefile -f msvc  $target.bkl \n");
	system("nmake /f makefile.vc");
	($name)=($_=~/(.*).cpp/);	
	system("$name.exe");
	system("make /f makefile.vc clean");
}

if($^O=~/linux/i)
{
	print "/bin/gen_bakefile_bkl.pl\n";
}
else
{
	print "gen_bakefile_bkl.pl\n";
}
print "#选用 msvc 的输出格式\n";
print "bakefile -f msvc  build.bkl \n";
print "nmake /f makefile.vc\n";
print "one_step_gtest.pl 已经生成\n";
print "ie.bat\n";

gen_gtest_bat();

my $target=get_target();
system("bakefile -f msvc  $target.bkl \n");
system("nmake /f makefile.vc\n");

