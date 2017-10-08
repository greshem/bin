#!/usr/bin/perl
$g_package="zlib-1.2.5.tar.gz";
$g_output_dir="zlib-1.2.5";
$g_url="http://nchc.dl.sourceforge.net/project/zlib/zlib/2.6.2/zlib_2_6_2.zip";

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
sub zlib_have_install()
{
	$include_dir= "D:\\usr\\include\\zlib";
	if( ! -d  $include_dir )
	{
		logger("zlib 没有安装, 因为没有对应的 $include_dir 目录\n");
		return 0;
	}
	if( ! -d  "D:\\usr\\lib")
	{
		mkdir("D:\\usr\\lib");
	}
}
sub download_zlib()
{
	if ( -f "C:\\cygwin\\bin\\wget.exe")
	{
		if(! -f "$g_package")
	   	{	
			system("C:\\cygwin\\bin\\wget.exe  $g_url");
			if( ! -f "$g_package")
			{
				logger("wget 之后 还是不 存在, 网址错误, 或者网络不通\n");
				die("wget 之后 还是不 存在, 网址错误, 或者网络不通\n");
			}
		}
		else
		{
			logger(" $g_package 文件存在 不用下载了\n");
		}
	}
	else
	{
		logger("wget.exe 没有, 没有安装 cygwin \n");
		warn("$g_package 没有, 去 下载\n");
		print "请到如下网址去下载: ";
		print "下载后, $g_package 放到当前目录,然后接着运行此脚本,请不要手动安装zlib";
	}
}


sub create_zlib_bkl()
{

	@cpp_files=glob("*.cpp");
	if( scalar(@cpp_files)== 1)
	{
		logger("注意; 这是 zlib 的老版本, 只有一个cpp 文件\n");
	}
	open(FILE, "> build.bkl") or die("create file error\n");
	print FILE <<EOF
<?xml version="1.0" ?>
	<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
	<makefile>
			<lib id="zlib">
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

				<sources>\$(fileList('*.c'))</sources>

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

#到了zlib 的代码目录.
sub compile_zlib_and_copy_install()
{
		system("bakefile -f msvc build.bkl");
		if(! -f "makefile.vc")
		{
			logger("Panic:  compile_zlib_and_copy_install 函数,  makefile.vc 文件不存在, 编译无法进行, die\n");
			die("Panic: makefile.vc 文件不存在\n");
		}
		
		system("nmake /f makefile.vc");
		
		if(! -f "zlib.lib")
		{
			logger("zlib.lib 文件不存在, 编译错误 ");
			die("zlib.lib 文件不存在, 编译错误 ");
		}
		system("copy /y zlib.lib D:\\usr\\lib\\");
		if( ! -d "D:\\usr\\include\\zlib")
		{
			mkdir("D:\\usr\\include\\zlib")
		}
		system("xcopy /y /S *.h D:\\usr\\include\\zlib");
}
sub extract_zlib()
{
	#解压$g_package
	logger("解压 $g_package \n");
	if (-f "C:\\Program Files\\WinRAR\\WinRar.exe")
	{
		system("\"C:\\Program Files\\WinRAR\\WinRar.exe\" x $g_package");
	}
	else
	{
		print "检测到WinRAR没有安装在C:\\Program Files\\目录下";
		print "请手动安装WinRAR到C:\\Program Files\\,然后在运行此脚本";
		exit();
	}
		
			#system("copy /y zlib-1.6.0\\src\\zlib-all.cc zlib-1.6.0\\")

}
sub check_zlib()
{
	$zlib_lib= "d:\\usr\\lib\\zlib.lib";
	if (!  -f  $zlib_lib)
	{
		logger("zlib.lib 不存在,   估计编译没有成功\n");
		die("zlib.lib 不存在,   估计编译没有成功\n");
	}
	else
	{
		logger(" $zlib_lib 存在 编译安装成功\n");
	}

	if ( ! -d "d:\\usr\\include\\zlib\\")
	{
		die("zlib include 目录不存在,  copy 也会出错.\n");
		logger("zlib include 目录不存在,  copy 也会出错.\n");
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
		open(FILE, ">>  d:\\log\\zlib_install.log");
	}
	else
	{
		open(FILE, ">> /var/log/zlib_install.log");
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
sub clean_zlib()
{
	my $include_dir= "d:\\usr\\include\\zlib\\" ;
	system("erase /S   /Q  $include_dir ");
	check_dir_delete($include_dir);
	

	my $lib_file= "d:\\usr\\lib\\zlib.lib" ;
	system("erase /S   /Q  $lib_file ");
	check_file_delete($lib_file);

	my $extract_dir= "tinxyml";
	system("erase /S /Q $extract_dir ");
	check_dir_delete($extract_dir);

}
sub install_zlib()
{
	check_cpp_env();
	zlib_have_install();
	download_zlib();
	extract_zlib();

	if(! -d "$g_output_dir")
	{
		logger("Error: 解压之后的目录 , 不存在, 解压错误");
		die("Error: 解压之后的目录 , 不存在, 解压错误");

	}
	chdir("$g_output_dir");
	if( ! -f "makefile.vc")
	{
		create_zlib_bkl();
	}
	else
	{
		logger("源码目录 存在, makefile.vc 文件, 不用再去生成bkl 文件了\n");
	}
	compile_zlib_and_copy_install();
	chdir("..");
	check_zlib();
}
$mode= shift;
if(defined($mode))
{
	clean_zlib();
}
else
{
	install_zlib();
}
