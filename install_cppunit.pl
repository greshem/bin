#!/usr/bin/perl

sub  _create_cppunit_bkl()
{
		open(FILE, "> build.bkl")or die("create file error\n");

		print FILE  <<EOF
<?xml version="1.0" ?>
<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
	<makefile>
		<lib id="cppunitd">
				<cxxflags>/Od</cxxflags>
				<cxxflags>/D_DEBUG</cxxflags>
				<cxxflags>/D_LIB</cxxflags>
				<cxxflags>/D_MBCS</cxxflags>
				<cxxflags>/GR</cxxflags>
				<cxxflags>/RTC1</cxxflags>
				<cxxflags>/W3</cxxflags>
				<cxxflags>/TP</cxxflags>
				<cxxflags>/ZI</cxxflags>
				<cxxflags>/MTd</cxxflags>
				<cxxflags>/nologo</cxxflags>
				<ldflags>/NOLOGO</ldflags>
				<include>../../include</include>
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
				<sources>\$(fileList('A*.cpp'))</sources>
				<sources>\$(fileList('B*.cpp'))</sources>
				<sources>\$(fileList('C*.cpp'))</sources>
				<sources>\$(fileList('E*.cpp'))</sources>
				<sources>\$(fileList('M*.cpp'))</sources>
				<sources>\$(fileList('P*.cpp'))</sources>
				<sources>\$(fileList('R*.cpp'))</sources>
				<sources>\$(fileList('S*.cpp'))</sources>
				<sources>\$(fileList('T*.cpp'))</sources>
				<sources>\$(fileList('U*.cpp'))</sources>
				<sources>\$(fileList('W*.cpp'))</sources>
				<sources>\$(fileList('X*.cpp'))</sources>
				<sources>\$(fileList('DefaultProtector.cpp'))</sources>
				<sources>\$(fileList('DynamicLibraryManager.cpp'))</sources>
				<sources>\$(fileList('DynamicLibraryManagerException.cpp'))</sources>
			</lib>
			
	</makefile>
EOF
;

		close(FILE);
}

#安装cppUnit
sub extract_cppunit()
{
	#if ( ! -f ("D:\\usr\\include\\cppunit\\config")   or  ! -f ("D:\\usr\\lib\\cppunitd.lib"))
	#	
	#解压cppunit
	if (!  -d "cppunit-1.10.2")
	{
		system('"C:\\Program Files\\WinRAR\\WinRar.exe" x cppunit-1.10.2.tar.gz');
	}
}

sub _compile_cppunit_copy()
{
		if ( ! -d  "D:\\usr\\lib\\")
		{
			mkdir ("D:\\usr\\lib\\");
		}
		if ( ! -d  "D:\\usr\\include\\")
		{
			mkdir ("D:\\usr\\include\\");
		}
		system("bakefile -f msvc build.bkl");
		system("nmake /f makefile.vc");
		system("copy /y cppunitd.lib D:\\usr\\lib\\");
		system("xcopy /y /S ..\\..\\include\\cppunit D:\\usr\\include\\cppunit\\");
}
sub download_cppunit()
{
	if (! -f ("cppunit-1.10.2.tar.gz"))
	{
		print "检测到cppunit开发工具没有安装\n";
		if (-f ("C:\\cygwin\\bin\\wget.exe"))
		{
			system("C:\\cygwin\\bin\\wget.exe http://down1.chinaunix.net/distfiles/cppunit-1.10.2.tar.gz");
		}
		else
		{
			print "请到如下网址去下载:http://down1.chinaunix.net/distfiles/cppunit-1.10.2.tar.gz";
			print "下载后,请将cppunit-1.10.2.tar.gz放到当前目录,然后接着运行此脚本,请不要手动安装";
			exit();
		}
	}
}

sub check_cppunit()
{
	if ( -f "d:\\usr\\lib\\cppunitd.lib")
	{
		die("cppunitd.lib no exists\n");
	}

	if ( -d "d:\\usr\\include\\cppunit\\")
	{
		die("cppunitd include dir  no exists\n");
	}
}

sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, "> d:\\log\\cppunit_install.log");
	}
	else
	{
		open(FILE, "> /var/log/cppunit_install.log");
	}

		print FILE $log_str;
		close(FILE);
}
logger("this is a logger\n");

########################################################################
#mainloop
download_cppunit();
extract_cppunit();

chdir("cppunit-1.10.2\\src\\cppunit\\");
_create_cppunit_bkl();
_compile_cppunit_copy();
chdir("..\\..\\..");
check_cppunit();

