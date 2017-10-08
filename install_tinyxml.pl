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
				warn("$each 没有安装\n");
				logger("vc2003 没有安装 请先安装vc2003\n");
		}
	}
}

#########################################################################
sub tinyxml_have_install()
{

	if( ! -d "D:\\usr\\include\\tinyxml")
	{
		logger("tinyxml 已经安装了, 已经有对应的头文件\n");
		return 0;
	}
	if( ! -d  "D:\\usr\\lib")
	{
		mkdir("D:\\usr\\lib");
	}
}
sub download_tinyxml()
{
	my $url="http://nchc.dl.sourceforge.net/project/tinyxml/tinyxml/2.6.2/tinyxml_2_6_2.zip";
	if ( -f "C:\\cygwin\\bin\\wget.exe")
	{
		if(! -f "tinyxml_2_6_2.zip")
	   	{	
			system("C:\\cygwin\\bin\\wget.exe  $url");
		}
		else
		{
			logger(" tinyxml_2_6_2.zip 文件存在 不用下载了\n");
		}
	}
	else
	{
		logger("wget.exe 没有, 没有安装 cygwin \n");
		warn("tinyxml_2_6_2.zip 没有, 去 下载\n");
		print "请到如下网址去下载: ";
		print "下载后,tinyxml_2_6_2.zip放到当前目录,然后接着运行此脚本,请不要手动安装tinyxml";
	}
}


sub create_tinyxml_bkl()
{

	@cpp_files=glob("*.cpp");
	if( scalar(@cpp_files)== 1)
	{
		logger("注意; 这是 tinyxml 的老版本, 只有一个cpp 文件\n");
	}
	open(FILE, "> build.bkl") or die("create file error\n");
	print FILE <<EOF
<?xml version="1.0" ?>
	<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
	<makefile>
			<lib id="tinyxml">
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

				<sources>\$(fileList('tinystr.cpp'))</sources>
				<sources>\$(fileList('tinyxml.cpp'))</sources>
				<sources>\$(fileList('tinyxmlerror.cpp'))</sources>
				<sources>\$(fileList('tinyxmlparser.cpp'))</sources>

			</lib>
			
	</makefile>
EOF
;
	close(FILE);
	if( -f "build.bkl")
	{
		logger("build.bkl 文件生成成功\n");
	}
	else
	{
		logger("build.bkl 文件生成失败, windows 系统权限问题? \n");
	}
}

#到了tinyxml 的代码目录.
sub compile_tinyxml_and_copy_install()
{
		system("bakefile -f msvc build.bkl");
		system("nmake /f makefile.vc");

		system("copy /y tinyxml.lib D:\\usr\\lib\\");
		if( ! -d "D:\\usr\\include\\tinyxml")
		{
			mkdir("D:\\usr\\include\\tinyxml")
		}
		system("xcopy /y /S *.h D:\\usr\\include\\tinyxml");
}
sub extract_tinyxml()
{
	#解压tinyxml.zip
	logger("解压 tinyxml_2_6_2.zip \n");
	if (-f "C:\\Program Files\\WinRAR\\WinRar.exe")
	{
		system('"C:\\Program Files\\WinRAR\\WinRar.exe" x tinyxml_2_6_2.zip');
	}
	else
	{
		print "检测到WinRAR没有安装在C:\\Program Files\\目录下";
		print "请手动安装WinRAR到C:\\Program Files\\,然后在运行此脚本";
		exit();
	}
		
			#system("copy /y tinyxml-1.6.0\\src\\tinyxml-all.cc tinyxml-1.6.0\\")

}
sub check_tinyxml()
{
	$tinyxml_lib= "d:\\usr\\lib\\tinyxml.lib";
	if (!  -f  $tinyxml_lib)
	{
		logger("tinyxml.lib 不存在,   估计编译没有成功\n");
		die("tinyxml.lib 不存在,   估计编译没有成功\n");
	}
	else
	{
		logger(" $tinyxml_lib 存在 编译安装成功\n");
	}

	if ( ! -d "d:\\usr\\include\\tinyxml\\")
	{
		die("tinyxml include 目录不存在,  copy 也会出错.\n");
		logger("tinyxml include 目录不存在,  copy 也会出错.\n");
	}
}


sub logger($)
{
	(my $log_str)=@_;
	
	if($^O=~/win32/i)
	{
		if(! -d ("d:\\log"))
		{
			mkdir("d:\\log");
		}
		open(FILE, ">>  d:\\log\\tinyxml_install.log");
	}
	else
	{
		open(FILE, ">> /var/log/tinyxml_install.log");
	}

		print FILE $log_str;
		close(FILE);
}
logger("this is a logger\n");


sub check_dir_delete($)
{
	(my $delete_dir)=@_;
	(! -d $delete_dir) && logger(" $delete_dir 目录删除成功\n");
	(  -d $delete_dir) && logger(" $delete_dir 目录删除失败\n");
}
sub check_file_delete($)
{
	(my $delete_file)=@_;
	(! -d $delete_file) && logger(" $delete_file 文件删除成功\n");
	(  -d $delete_file) && logger(" $delete_file 文件删除失败\n");
}

########################################################################
sub clean_tinyxml()
{
	my $include_dir= "d:\\usr\\include\\tinyxml\\" ;
	system("erase /S   /Q  $include_dir ");
	check_dir_delete($include_dir);
	

	my $lib_file= "d:\\usr\\lib\\TinyXml.lib" ;
	system("erase /S   /Q  $lib_file ");
	check_file_delete($lib_file);

	my $extract_dir= "tinxyml";
	system("erase /S /Q $extract_dir ");
	check_dir_delete($extract_dir);

}
sub install_tinyxml()
{
	check_cpp_env();
	tinyxml_have_install();
	download_tinyxml();
	extract_tinyxml();

	chdir("tinyxml");
	create_tinyxml_bkl();
	compile_tinyxml_and_copy_install();
	chdir("..");
	check_tinyxml();
}
$mode= shift;
if(defined($mode))
{
	clean_tinyxml();
}
else
{
	install_tinyxml();
}
