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


sub gen_bakefile()
{
	$target=get_target();
	$res_tag=get_rc();

	open(FILE, ">$target.bkl") or die("Open file error $!\n");
    #<include file="presets/wx.bkl"/>
	print FILE <<EOF
<?xml version="1.0" ?>
<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
<makefile>
	<exe id="$target"> 
	<app-type>gui</app-type>
	<!-- <include>D:\\usr\\include\\lmyunit</include> -->

	<cxxflags>/DNOPCH</cxxflags>   
	<cxxflags>/DWIN32</cxxflags>
	<cxxflags>/DWINDOWSCODE</cxxflags>
	<cxxflags>/D_AFXDLL</cxxflags> 
	<cxxflags>/D_DEBUG</cxxflags>			
	<cxxflags>/D_MBCS</cxxflags>
	<cxxflags>/D_WINDOWS</cxxflags>

	<cxxflags>/MDd</cxxflags>
	<cxxflags>/ZI</cxxflags>
	
	
	<lib-path>D:\\usr\\lib</lib-path>
	<include>D:\\usr\\include</include>

	<ldflags>/INCREMENTAL:NO</ldflags>
	<ldflags>/NOLOGO</ldflags>
	<ldflags>/NODEFAULTLIB:LIBCMTD.lib</ldflags>
	<ldflags>/DEBUG</ldflags>
	<ldflags>/SUBSYSTEM:WINDOWS</ldflags>
	<ldflags>/MACHINE:X86</ldflags>
	<!-- <sys-lib>UnitCode</sys-lib> --> 
	<sys-lib>winmm</sys-lib>
	<sys-lib>comctl32</sys-lib>
	<sys-lib>rpcrt4</sys-lib>
	<sys-lib>wsock32</sys-lib>
	<sys-lib>odbc32</sys-lib>
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

	$res_tag
	<sources>\$(fileList('*.cpp'))</sources> 
	<clean-files> *.ncb *.plg *.opt *.positions UpgradeLog.XML MakeFile.aps *.suo *.aps *.suo.old *.sln.old *.7.10.old *.ilk *.clw *.obj *.res *.pch *.pdb *.scc *.sbr *idb
	</clean-files>
     </exe>
</makefile>


EOF
;	
	if( -f "build.bkl")
	{
	print ("#build.bkl 文件生成\n");
	}
}

########################################################################
#mfc 
sub gen_mfc_bat()
{
	open(FILE, "> one_step_mfc.bat");
	print FILE <<EOF
cmd_find.pl mfc
c:\\bin\\compile_mfc.pl
gen_bakefile_bkl.pl
bakefile -f msvc  build.bkl

nmake /f makefile.vc
EOF
;
close(FILE);
}

gen_bakefile();
#gen_mfc_bat();

my $target=get_target();
system("bakefile -f msvc  $target.bkl \n");
system("nmake /f makefile.vc\n");


if($^O=~/linux/i)
{
	print "/bin/gen_bakefile_bkl.pl\n";
}
else
{
	print "gen_bakefile_bkl.pl\n";
}
print "#选用 msvc 的输出格式\n";
print "bakefile -f msvc  ".get_target().".bkl \n";
print "nmake /f makefile.vc\n";
