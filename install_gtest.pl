#!/usr/bin/perl
sub check_cpp_env()
{
	$vc_2003= "C:\\Program Files\\Microsoft Visual Studio\ .NET\ 2003\\Vc7\\bin";
	$vc_2003_upper= "C:\\Program Files\\Microsoft\ Visual Studio\ .NET\ 2003\\VC7\\BIN";
	$bakefile="C:\\Program Files\\Bakefile";
	$cygwin="c:\\cygwin";
	push( @progs_path , $cygwin);
   	push( @progs_path , $vc_2003);
	push( @progs_path , $vc_2003_upper);
	push(@progs_path, $bakefile);
	
	for $each (@progs_path)
	{
		if( ! -d  $each)
		{
				warn("$each û�а�װ\n");
				logger("vc2003  $each û�а�װ\n");
		}
	}
}

#########################################################################
sub gtest_have_install()
{

	if( ! -d "D:\\usr\\include\\gtest")
	{
		logger("gtest û�а�װ, ��Ϊû�ж�Ӧ�� D:\\usr\\include\\gtest Ŀ¼\n");
		return 0;
	}
	if( ! -d  "D:\\usr\\lib")
	{
		mkdir("D:\\usr\\lib");
	}
}
sub download_gtest()
{
	if ( -f "C:\\cygwin\\bin\\wget.exe")
	{
		if(! -f "gtest-1.6.0.zip")
	   	{	
			system("C:\\cygwin\\bin\\wget.exe http://googletest.googlecode.com/files/gtest-1.6.0.zip");
		}
	}
	else
	{
		logger("�뵽������ַȥ����:http://googletest.googlecode.com/files/gtest-1.6.0.zip\n");
		print "�뵽������ַȥ����:http://googletest.googlecode.com/files/gtest-1.6.0.zip\n";
		print "���غ�,�뽫gtest.zip�ŵ���ǰĿ¼,Ȼ��������д˽ű�,�벻Ҫ�ֶ���װgtest\n";
	}
}


sub create_gtest_bkl()
{
	open(FILE, "> build.bkl") or die("create file error\n");
	print FILE <<EOF
<?xml version="1.0" ?>
	<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
	<makefile>
			<lib id="gtest">
				<cxxflags>/Od</cxxflags>
				<cxxflags>/D_DEBUG</cxxflags>
				<cxxflags>/D_LIB</cxxflags>
				<cxxflags>/D_MBCS</cxxflags>
				<cxxflags>/Gm</cxxflags>
				<cxxflags>/RTC1</cxxflags>
				<cxxflags>/W3</cxxflags>
				<cxxflags>/TP</cxxflags>
				<cxxflags>/ZI</cxxflags>
				<cxxflags>/MTd</cxxflags>
				<ldflags>/NOLOGO</ldflags>
				<include>include</include>
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
				<sources>\$(fileList('gtest-all.cc'))</sources>
			</lib>
			
	</makefile>
EOF
;
	close(FILE);
	if( -f "build.bkl")
	{
		logger("build.bkl �ļ����ɳɹ�\n");
	}
	else
	{
		logger("build.bkl �ļ�����ʧ��, windows ϵͳȨ������? \n");
	}
}

sub compile_gtest_and_copy_install()
{
	system("bakefile -f msvc build.bkl");
	if(! -f "makefile.vc")
	{
		logger("Panic:  compile_gtest_and_copy_install ����,  makefile.vc �ļ�������, �����޷�����, die\n");
			die("Panic: makefile.vc �ļ�������\n");
	}
	system("nmake /f makefile.vc");

	if(! -f "gtest.lib")
	{
		logger("gtest.lib �ļ�������, �������\n ");
		die("gtest.lib �ļ�������, ������� \n");
	}

	system("del gtest-all.cc");
	system("copy /y gtest.lib D:\\usr\\lib\\");
	system("xcopy /y /S include D:\\usr\\include");
}
sub extract_gtest()
{
	#��ѹgtest.zip
	if (! -d ("gtest-1.6.0"))
	{
		if (-f "C:\\Program Files\\WinRAR\\WinRar.exe")
		{
			system('"C:\\Program Files\\WinRAR\\WinRar.exe" x gtest-1.6.0.zip');
		}
		else
		{
			logger("winrar û�а�װ\n");
			print "��⵽WinRARû�а�װ��C:\\Program Files\\Ŀ¼��";
			print "���ֶ���װWinRAR��C:\\Program Files\\,Ȼ�������д˽ű�";
			exit();
		}
	}

	system("copy /y gtest-1.6.0\\src\\gtest-all.cc gtest-1.6.0\\")

}
sub check_gtest()
{
	if (!  -f "d:\\usr\\lib\\gtest.lib")
	{
		logger("gtest.lib ������,   ���Ʊ���û�гɹ�\n");
		die("gtest.lib ������,   ���Ʊ���û�гɹ�\n");
	}
	elsif ( ! -d "d:\\usr\\include\\gtest\\")
	{
		logger("gtest include Ŀ¼������,  copy Ҳ�����.\n");
		die("gtest include Ŀ¼������,  copy Ҳ�����.\n");
	}
	else
	{
		logger("gtest ��װ���\n");
	}
}
########################################################################
sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">> d:\\log\\gtest_install.log");
	}
	else
	{
		open(FILE, ">> /var/log/gtest_install.log");
	}

		print FILE $log_str;
		close(FILE);
}

########################################################################
check_cpp_env();
gtest_have_install();
download_gtest();
extract_gtest();

chdir("gtest-1.6.0");
create_gtest_bkl();
compile_gtest_and_copy_install();
chdir("..");
check_gtest();
