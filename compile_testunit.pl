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

			<ldflags>/DEBUG </ldflags>
			<ldflags>/NODEFAULTLIB:libcmt.lib</ldflags>
			<ldflags>/NODEFAULTLIB:MSVCRT.lib  /NODEFAULTLIB:MSVCRTD.lib  /NODEFAULTLIB:msvcprtd.lib</ldflags>
			<include>D:\\usr\\include</include>
			<!-- <include>D:\\usr\\include\\lmyunit</include> -->
			<include>D:\\usr\\include\\Baselib</include>
			<!-- <threading>multi</threading> -->
			<lib-path>D:\\usr\\lib</lib-path>
			<ldflags>/DEBUG</ldflags>
			<sys-lib>gtest</sys-lib>
			<sys-lib>lmyunit</sys-lib>

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
			<sys-lib>libcpmtd</sys-lib>


		<sources>\$(fileList('$filename'))</sources> 
     </exe>
</makefile>


EOF
;	
}

sub gen_lmyunit_bat()
{
	open(FILE, "> one_step_lmyunit.bat");
	print FILE <<EOF

cmd_find.pl lmyunit
c:\\bin\\compile_lmyunit.pl
gen_bakefile_bkl.pl
bakefile -f msvc  build.bkl
nmake /f makefile.vc
EOF
;
}


for (glob("*.cpp"))
{
	print "Deal with $_\n";
	if( shell_grep($_, "tmp_ok"))
	{
		print $_, "已经处理过了\n";
	}
	else
	{
		gen_bakefile($_);
		system("bakefile -f msvc  build.bkl \n");
		system("nmake /f makefile.vc");
		($name)=($_=~/(.*).cpp/);	
		if(! -f $name.".exe")
		{
			logger($name.".exe 不存在 编译错误\n");
			die($name.".exe 不存在 编译错误\n");
		}
		else
		{
			system("$name.exe");
		}
		append_to_file($_, "tmp_ok");

		#system("make /f makefile.vc clean");
	}
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
#print "one_step_lmyunit.bat 已经生成\n";
#print "ie.bat\n";

#gen_lmyunit_bat();

sub append_to_file($$)
{
	(my $cppfile, $logfile)=@_;
	open(FILE, ">> $logfile" ) or die("open file $logfile error\n");
	print FILE  $cppfile."\n";;
	close(FILE);
}
sub shell_grep($$)
{
	(my $pattern, $file)=@_;
	open(FILE, $file) or warn("Open file $file error\n");
	my $count=undef;
	for(<FILE>)
	{
		if($_=~/$pattern/)
		{
			$count++;
		}
	}
	return $count;
}



#windows 下 最简单的, 到d:\\log 目录
sub logger($)
{
	if(! -d ("d:\\log"))
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">>  d:\\log\\compile_testunit.log");
	print FILE $log_str;
	close(FILE);
}


