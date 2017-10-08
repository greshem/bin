#!/usr/bin/perl -w

#use strict;
my %g_OBJS; # name.cpp $g_OBJS{"name.cpp"} => "name.o" 
my %g_COMP; # 编译列表.  "name.o"  =>"name.cpp"
my %g_SUFFIX;
my %g_MAIN; 	# 含有 main 的 文件名，"name.cpp" => "name" 
		  	# "name.c" => "name" 
my %g_NOMAIN; # 没有main 的 .c .cpp 文件. 
my $g_EXEC; # name.cpp 有main 然后可以 添加成  $g_EXEC{"name"} => "name.cpp", 注意有main函数才可以. 

my $g_LIBS = "";
my $g_TOTAL_LINES = 0;
my $g_CUR_LINES = 0;
my $g_CXXFLAGS = "";
my $g_LDFLAGS="";

my $g_cur_cpp_have_main=0;
my $g_cur_cpp_filename=undef;

#my $GCC="gcc  -ftest-coverage -fprofile-arcs ";
#my $CPP="g++  -ftest-coverage -fprofile-arcs ";
my $GCC="gcc  ";
my $CPP="g++   ";


our @ARGV;
our @argv;

sub logger($);
sub WriteBakefile();

logger("########################################################################\n");
#mainloop
@argv=@ARGV;


if(scalar(@argv) ==0)
{
	die("Usage: $0 file1 file2 file3 . . . etc\n");
}
#pre_process();
foreach (@ARGV)
{
	print "#Deal with $_ \n";
	if( ! -f $_)
	{
		#continue;
		next;
	}
	if($_=~/\.c$/i)
	{
		&ParseFile($_,"c");
	}
	elsif ($_=~/\.cpp$/i)
	{
		
		&ParseFile($_,"cpp");
	}
	elsif( $_=~/\.h$/)
	{
		&ParseFile($_,"h");
	}
}
print "Total lines:" . $g_TOTAL_LINES . "\n";
if($0=~/makefile/)
{
	WriteMakefile();
}
else
{
	WriteBakefile();
}


########################################################################
#下面的调用的函数, 主体就是如下的整个循环. 
# 	foreach ( *.cpp)
# 	{
# 		ParseFile;	
# 	}
#	WriteMakefile
########################################################################
sub ParseFile
{
	my ($filename, $suffix) = @_;
	$g_cur_cpp_filename=$filename;

	$g_CUR_LINES = 0;

	open CODE, "< $_" or die "Can not open $_($!)";
	my $obj = &GetObjName($filename, $suffix);
	$g_OBJS{$obj} = 1 if($suffix ne "h");
	&AddToCOMP($obj, $filename) if ($suffix ne "h");
	$g_SUFFIX{$obj} = $suffix if($suffix ne "h");
	while(<CODE>)
	{
		$g_TOTAL_LINES++;
		$g_CUR_LINES++;

	   	if(/#\s*include\s*"(\w+.h)"/)
	   	{
			&AddToCOMP($obj,$1);
			&AddToCOMP($obj, GetCppName($1,"h"));
	   	}
		deal_with_main($_)	;
		########################################################################
		#check_qzjUnit($_);
		check_lmyUnit($_);
		check_ace($_); 			check_boost($_); 		check_tinyxml($_);
		check_baselib($_); 		check_descramble($_); 	check_mysql($_);
		check_ext2fs($_); 		check_gtest($_); 		check_gd($_); 
		check_magiclib($_); 	check_zip($_); 			check_log4cpp($_);
		check_openssl($_); 		check_pthread($_); 		check_numerical($_);
		check_freetype2($_); 	 			check_octave($_);
		check_unp($_);			check_pcap($_);			check_beecrypt($_);
		check_crypt($_);		check_ctemplate($_); 	check_dlopen($_);	
		check_ncurses($_); 		check_stringprep($_); 	check_forkpty($_);
		check_wxWidget($_); check_gtk($_);
		#check_windows($_);
		check_cppunit($_);

		#check_png($_);
		check_png_v2($_);
		check_libcaca($_);
		check_gail($_);
		check_udis86($_);

		check_csmitch($_);
		check_libnet($_);

		check_igraph($_);
		check_thrift($_);


	}
	close CODE;

	if( $g_cur_cpp_have_main == 0) # 这个文件没有 main 函数. 
	{
			my $nomain = &DeSuffix($filename,$suffix);
			$g_NOMAIN{$filename}=$nomain;
			print "g_NOMAIN:  ", $filename, "\t", $nomain, "\n";
	}
}
########################################################################
#/usr/include/igraph
sub check_thrift($)
{
	(my $line)=@_;
	# <thrift/ 
	if($line=~/\#include.*\<thrift.*TBinaryProtocol\.h/)   #
	{
		if($g_LIBS!~/thrift/)
		{
			$g_LIBS.=" -lthrift  ";
		}
		if($g_CXXFLAGS!~/thrift/)
		{
			$g_CXXFLAGS.="-I /usr/include/thrift// ";
		}

	}
}
sub check_igraph($)
{

	(my $line)=@_;
	#if($line=~/^\s*#include\s*igraph.h/) 这种方式就不行了.  无法匹配.
	#if($line=~/\#include\s+igraph\.h/)   # 无法匹配
	if($line=~/\#include.*\<igraph\.h/)   #
	{
		print "#igraph  匹配\n";
		#lib
		if($g_LIBS!~/ligraph/)
		{
			$g_LIBS.=" -ligraph  ";
		}

		if($g_CXXFLAGS!~/igraph/)
		{
			$g_CXXFLAGS.="-I /usr/include/igraph// ";
		}


	}

}
sub check_libnet($)
{
	#include "csmith.h"
	(my $line)=@_;
	if($line=~/^\s*#include\s*"libnet.h/)
	{
		#lib
		if($g_LIBS!~/lnet/)
		{
			$g_LIBS.=" -lnet  ";
		}


	}
}


sub check_csmitch($)
{
	#include "csmith.h"
	(my $line)=@_;
	if($line=~/^\s*#include\s*"csmith.h/)
	{
		if($g_CXXFLAGS!~/csmith/)
		{
			$g_CXXFLAGS.="-I /usr/include/csmith-2.1.0/ ";
		}

	}
}
sub check_udis86($)
{

	(my $line)=@_;
	if($line=~/^\s*#include\s*<udis86.h/)
	{
		#include
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 libudis86  特征.\n");

		if($g_CXXFLAGS!~/libudis/)
		{
			#$g_CXXFLAGS.="-I /usr/include/libudis86/  ";
		}
		#lib
		if($g_LIBS!~/ludis86/)
		{
			$g_LIBS.=" -ludis86  ";
		}
	}

}

########################################################################
#template 添加的模板.  没有规律. 
# sub check_template($)
# {
# 	(my $line)=@_;
# 	if($line=~/#\s*include\s*<template\/(.+).h/)
# 	{
# 		#print "ace\n";
# 		unless( defined($g_LIBS) and $g_LIBS =~ /ltemplate/)
# 		{
# 			$g_LIBS .= " -ltemplate";
# 		}
# 		unless ( $g_CXXFLAGS =~ /-I\$\(template_CFLAG\)/)
# 		{
# 			$g_CXXFLAGS .= " -I\$(template_CFLAG)";
# 		}
# 	}
# }

#alsa/asoundlib.h ->  


########################################################################
#预处理, 根据 具体的目录, 增加 对应的目标文件.  
sub pre_process()
{
	use Cwd;
	our $pwd=getcwd();
	print $pwd."\n";;
	if($pwd=~/netware_emulator/ && $pwd!~/testUnit/i)
	{
		my 	$append_file="/root/netware_emulator/data_engine/log.cpp";
		if( -f $append_file)
		{
			push(@argv, $append_file);
			push(@ARGV, $append_file);
		}

			$append_file="/root/netware_emulator/data_engine/conf_parser.cpp";
		if( -f $append_file)
		{
			push(@argv, $append_file);
			push(@ARGV, $append_file);
		}

	}
}


#***************************************************************************
# Description	 
# @param 	第一个参数 是 待检测的 代码行. 
# 			第二和第三都是成对的 从 pkg-config 对应的 数据库 自己提取找出来的  特征头文件 和他的 名字. 
#			特征头文件一般是只 有了这个头文件其他的头文件可以不用include 了. 	
# @return 	
# @notice:	第三个参数需要检测 可能是pkg-config 不支持的包, 那么需要自己手动来建立了. 
#			检测的原则是 看 pkg-config 对应的数据路径 有没有这个文件. 
#***************************************************************************/
sub _inner_check_pkgcfg($$$)
{
	my ($line, $header, $name)=@_;
	
	if($line=~/#\s*include.*$header/)
	{
		#print "ace\n";
		unless( defined($g_LIBS) and $g_LIBS =~ /pkg-config.*libs.*$name/)
		{
			$g_LIBS .= "\`pkg-config --libs $name\`";
			#$g_LIBS.=" \`wx-config --libs\` -lX11 ";
		}
		unless ( $g_CXXFLAGS =~ /pkg-config.*cflags.*$name/)
		{
			$g_CXXFLAGS .= "\`pkg-config --cflags  $name\`";
		}
	}
}

########################################################################
sub  check_gail($)
{
	(my $line )=@_;
	_inner_check_pkgcfg($line,"gail/","gail");
	_inner_check_pkgcfg($line,"libgail-util/","gail");
}

########################################################################
sub check_libcaca($)
{
	(my $line)=@_;
	_inner_check_pkgcfg($line, "caca.h", "caca");
}

########################################################################
sub check_png_v2($)
{
	(my $line)=@_;
	_inner_check_pkgcfg($line, "png.h", "libpng");
}
########################################################################
sub check_windows($)
{
	(my $line)=@_;
	if($line=~/#include.*windows.h/)
	{
		$GCC="mingw32-gcc ";
		$CPP="mingw32-g++ ";
	}		
}
########################################################################
sub check_cppunit($)
{
	(my $line)=@_;
	if($line=~/#\s*include.*cppunit\/.*/)
	{
			#$g_LIBS.="\`pkg-config --cflags gtk+-2.0\` ";
			#$g_CXXFLAGS.="\`pkg-config  ";
			if($g_LIBS!~/cppunit/)
			{
				$g_LIBS.=" -lcppunit -ldl ";
			}
	}
}

########################################################################
sub check_gtk($)
{
	(my $line)=@_;
	if($line=~/#\s*include.*gtk\/gtk.h/)
	{
			#$g_LIBS.="\`pkg-config --cflags gtk+-2.0\` ";
			$g_CXXFLAGS.="\`pkg-config --cflags gtk+-2.0\` ";
			$g_LIBS.="  \`pkg-config --libs gtk+-2.0\` ";
	}
}
########################################################################
#2010_12_22_15:19:48 add by greshem

sub check_wxWidget($)
{
	(my $line)=@_;
	#if($line=~/#\s*include\s*<wx\/wx.h/)
	if($line=~/#\s*include\s*.*wx\/wx.h/)
	{
		#if($g_LIBS!~/wx-config\s+--libs/)
		{
			#$g_LIBS.=" -lwxregexu -lwx_baseu -lwx_baseu_net -lwx_baseu_xml  ";
			$g_LIBS.=" \`wx-config --libs\` -lX11 ";
		}
		#if($g_CXXFLAGS!~/wx-config\s--cxxflags/)
		{
			$g_CXXFLAGS.=" \`wx-config  --cxxflags\`   ";
		}

	}

}
########################################################################
#2010_12_22_14:32:28 add by greshem
#forkpty , 其实 可以通过 forkpty 来确定 应该需要添加 pty.h 和-lutil 函数库。 
#进一步的需求是， 代码检测， 来完成 整个编译过程. 
sub check_forkpty($)
{
	(my $line)=@_;
	if($line=~/#\s*include\s*<pty.h/)
	{
		#print "ace\n";
		unless( defined($g_LIBS) and $g_LIBS =~ /lutil/)
		{
			 $g_LIBS .= " -lutil";
		}
	}
}



########################################################################
#Parsing main
#遇到这样的情况 void main( 
#if(/^\s+(main)\s*\(.*/)
sub deal_with_main($)
{
	(my $line)=@_;
	my $filename=$g_cur_cpp_filename;
	if($line=~/(winmain|main|tmain|ACE_TMAIN)\s*\(.*/i) #wxwidget 是 IMPLEMENT_APP(MainApp)
	{
		#my $main = &DeSuffix($filename,$suffix);
		(my $main)=($filename=~/(.*)\.[c|cpp|cxx|cc]/);
		$g_MAIN{$filename}=$main;
		$g_cur_cpp_have_main++;
		print "MAIN:  ", $filename, "\t", $main, "\n";
		logger("$filename 第 $g_CUR_LINES 行|$_|, 含有 main\n");
	}
}
########################################################################
#Parsing boost
#if(/#\s*inlcude\s*<boost/(\w+).h>/)
#if(/#\s*include\s*<boost.*\/(.+).hpp/)
#{
#printf "Boost 1 找到\n";
#    &AddBoostLIB($1);
#}
sub check_boost($)
{
	(my $line)=@_;
	if($line=~/#\s*include\s*<boost\/(.+).hpp/)
	{
		printf "Boost 找到\n";
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 boost 特征.\n");
		&AddBoostLIB($1);
	}
}

########################################################################
sub AddBoostLIB
{
	my($boostlib) = @_;
	unless( defined($g_LIBS) and $g_LIBS =~ /$boostlib/)
	{
	   my $boostlibpath = "/usr/lib/libboost_$boostlib.so";
	   #$g_LIBS .= " " . $boostlib if -e $boostlibpath;

	   $g_LIBS .= " -lboost_" . $boostlib if -e $boostlibpath;
	  
		$boostlibpath = "/usr/lib64/libboost_$boostlib.so";
	   	$g_LIBS .= " -lboost_" . $boostlib if -e $boostlibpath;
	}

	print "Boost ",$boostlib . "\n";

}


########################################################################
#ACE
sub check_ace($)
{
	(my $line)=@_;
	if($line=~/#\s*include\s*<ace\/(.+).h/)
	{
		#print "ace\n";
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 ace 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /lACE/)
		{
			$g_LIBS .= " -lACE";
		}
		unless ( $g_CXXFLAGS =~ /-I\$\(ACE_ROOT\)/)
		{
			$g_CXXFLAGS .= " -I\$(ACE_ROOT)";
		}
	}
}
########################################################################
#tinyxml
sub check_tinyxml($)
{
	(my $line)=@_;
	if($line=~/#\s*include\s*<(tinyxml|FMConfig).h/i)
	{
		print "tinyxml匹配到\n";
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 tinyxml 特征.\n");
		#unless( defined($g_LIBS) and $g_LIBS !~ /ltinyxml/)
		unless( $g_LIBS =~ /ltinyxml/)
		{
			print "添加 ltinyxml\n";
			 $g_LIBS .= " -ltinyxml";
		}
	}
}

########################################################################
#lmyUnit
sub check_lmyUnit($)
{
	(my $line)=@_;
	if($line=~/^#\s*include\s*<unitlib.h/)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 lmyunit 特征.\n");
		if($g_LIBS!~/lUnitLib/)
		{
			$g_LIBS.=" -lUnitLib -L ~/lmyunit/lmyunit/ -lpthread";
		}
		if($g_CXXFLAGS!~/LmyUnit/)
		{
			$g_CXXFLAGS.="-I ~/lmyunit/lmyunit/  ";
		}
   }

	#if($line=~/^#\s*include\s*mthread.h/i)
	if($line=~/^#\s*include.*mthread.h/i)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 mthread 特征.\n");
		if($g_LIBS!~/lpthread/)
		{
			$g_LIBS.=" -lpthread";
		}
	}

	#if($line=~/^#\s*include\s+mthread\.cpp/i)
	if($line=~/^#\s*include.*mthread\.cpp/i)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 mthread 特征.\n");
		if($g_LIBS!~/lpthread/)
		{
			$g_LIBS.=" -lpthread";
		}
	}
}
########################################################################
#qzjUnit 库. 
sub check_qzjUnit($)
{
	(my $line)=@_;
	if($line=~/#\s*include\s*<QzjUnit.hpp/)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 qzjunit 特征.\n");
		if($g_CXXFLAGS!~/QzjUnit/)
		{
			$g_CXXFLAGS.="-I /root/QzjUnit/QzjUnit  ";
		}
		if($g_LIBS!~/lpthread/)
		{
			$g_LIBS.=" -lpthread";
		}
	}
}
########################################################################
#################descramble 
sub check_baselib($)
{
	(my $line)=@_;
	if($line=~/^\s*#include\s*<Baselib.hpp/)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 baselib 特征.\n");
		if($g_CXXFLAGS!~/Baselib/)
		{
			$g_CXXFLAGS.="-I ~/lmyunit/Baselib/  ";
		}
	
		if($g_LIBS!~/lpthread/)
		{
			$g_LIBS.=" -lpthread ";
		}
	
	}
}
########################################################################
#netclone Baselib
#
sub check_descramble($)
{
	(my $line)=@_;
	if($line=~/#\s*include\s*<(descramble).h/)
	{
		#print "scramble\n";
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 descramble 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /ldescramble/)
		{
			$g_LIBS .= " -ldescramble";
		}
   }
}
########################################################################
#mysql lib
sub check_mysql($)
{
	(my $line)=@_;
	if($line=~/#\s*include\s*<mysql./)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 mysql 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /lmysqlclient/)
		{
		 $g_LIBS .= " -lmysqlclient";
		}
		unless(defined($g_CXXFLAGS) && $g_CXXFLAGS=~/mysql/)
		{
			$g_CXXFLAGS.="-I/usr/include/mysql";
		}
		unless(defined($g_LDFLAGS) and $g_LDFLAGS=~/mysql/)
		{
			$g_LDFLAGS.="-L /usr/lib/mysql";
		}
	}
}
########################################################################
#
sub check_ext2fs($)
{
	(my $line)=@_;

	if($line=~/^\s*#\s*include\s*<ext2fs|ExtFileSystem.hpp/)
	{

		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 ext2fs 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /lext2fs/)
		{
		 $g_LIBS .= " -lext2fs -le2p";
		}
	}
}

########################################################################
#
sub check_gtest($)
{
	(my $line)=@_;
	if($line=~/^\s*#\s*include\s*<gtest/)
	{

		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 gtest 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /lgtest/)
		{
		 $g_LIBS .= " -lgtest -lpthread";
		}

	}
}
########################################################################
#//gd
sub check_gd($)
{
	(my $line)=@_;
	if($line=~/^\s*#\s*include\s*<gd.h/)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 gd 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /lgd/)
		{
		 $g_LIBS .= " -lgd ";
		}

	}
}
########################################################################
#magiclib
sub check_magiclib($)
{
	(my $line)=@_;
	if($line=~/^\s*#\s*include\s*<magic.h/)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 magicimage 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /lmagic/)
		{
			 $g_LIBS .= " -lmagic";
		}

	}
}

########################################################################
#zip
sub check_zip($)
{
	(my $line)=@_;
	if($line=~/^\s*#\s*include\s*<zip.h/)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 zip 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /lzip/)
		{
			 $g_LIBS .= " -lzip";
		}
	}
}

########################################################################
#log4cpp
sub check_log4cpp($)
{
	(my $line)=@_;
	if($line=~/^\s*#\s*include\s*<log4cpp/)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 log4cpp 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /llog4cpp/)
		{
			 $g_LIBS .= " -llog4cpp -lpthread ";
		}
	}
}

########################################################################
#openssl
sub check_openssl($)
{

	(my $line)=@_;
	if($line=~/^\s*#\s*include\s*<openssl/)
	{
		#include
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 openssl 特征.\n");
		if($g_CXXFLAGS!~/openssl/)
		{
			$g_CXXFLAGS.=" -I /usr/include/openssl ";
		}

		unless( defined($g_LIBS) and $g_LIBS =~ /lssl/)
		{
			 $g_LIBS .= " -lssl -lcrypto";
		}

	}
}


########################################################################
#pthread
#2010_09_07
sub check_pthread($)
{
	(my $line)=@_;

	if($line=~/^\s*#\s*include\s*pthread/)
	{
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 pthread 特征.\n");
		unless( defined($g_LIBS) and $g_LIBS =~ /lphtread/)
		{
			 $g_LIBS .= " -lpthread";
		}
	}
}


########################################################################
#数值计算库
#2010_09_08_10:24:27 add by greshem
sub check_numerical($)
{
	(my $line)=@_;
	if($line=~/^\s*#include\s*<numerical_math.hpp/)
	{

		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 numerical_math 特征.\n");
		if($g_CXXFLAGS!~/numerical/)
		{
			$g_CXXFLAGS.="-I ~/lmyunit//numerical_math/include/  ";
		}
	}
}
########################################################################
#freetype2.
#2010_09_09_10:18:15 add by greshem
sub check_freetype2($)
{
	(my $line)=@_;

	if($line=~/^\s*#include\s*<ft2build.h/)
	{
		#include
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 freetype2  特征.\n");
		if($g_CXXFLAGS!~/freetype/)
		{
			$g_CXXFLAGS.="-I /usr/include/freetype2/  ";
		}
		#lib
		if($g_LIBS!~/freetype/)
		{
			$g_LIBS.="-lfreetype ";
		}
	}
}
########################################################################
#png.
#2010_09_09add by greshem
sub check_png($)
{
	(my $line)=@_;
	if($line=~/^\s*#include\s*<png.h/)
	{
		#include
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 libpng  特征.\n");

		if($g_CXXFLAGS!~/libpng12/)
		{
			$g_CXXFLAGS.="-I /usr/include/libpng12/  ";
		}
		#lib
		if($g_LIBS!~/lpng/)
		{
			$g_LIBS.="-lpng ";
		}
	}
}
########################################################################
#2010_09_13_15:59:33 add by greshem
#octave
sub check_octave($)
{
	(my $line)=@_;
	if($line=~/^\s*#include\s*<octave/)
	{
		#include
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 octave  特征.\n");
		if($g_CXXFLAGS!~/octave/)
		{
			$g_CXXFLAGS.=" -I /usr/include/octave-3.2.4/   ";
		}
		#lib
		if($g_LIBS!~/loctave/)
		{
			$g_LIBS.=" -L /usr/lib/octave-3.2.4/ -lcruft -loctave -loctinterp ";
		}
	}
}

########################################################################
#2010_09_14_12:31:35 add by greshem
sub check_stringprep($)
{
	(my $line)=@_;
	if($line=~/^\s*#include\s*<stringprep.h/)
	{
		#include
		#lib
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 stringprep 特征.\n");
		if($g_LIBS!~/lidn/)
		{
			$g_LIBS.=" -lidn ";
		}
	}
}


########################################################################
#2010_09_19_12:18:03 add by greshem
sub check_unp($)
{
	(my $line)=@_;
	if($line=~/^\s*#include\s*<unp.h>/)
	{
		#include
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 unp 特征.\n");
		#if($g_LIBS!~/lidn/)
		if($g_CXXFLAGS!~/unp/)
		{
			$g_CXXFLAGS.=" -I /root/unix_networkd_programing/unp/lib/   ";
		}

		#lib
		if($g_LIBS!~/lunp/)
		{
			$g_LIBS.=" -lunp -L /root/unix_networkd_programing/unp/lib/";
		}
	}
}
########################################################################
##2010_09_20_11:09:30 add by greshem
sub check_pcap($)
{
	(my $line)=@_;
	if($line=~/^\s*#include\s*<pcap.h>/)
	{

		#include
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 pcap 特征.\n");
		if($g_CXXFLAGS!~/pcap/)
		{
			$g_CXXFLAGS.=" -I /usr/include/pcap   ";
		}

		#lib
		if($g_LIBS!~/lpcap/)
		{
			$g_LIBS.=" -lpcap ";
		}
	}
}

########################################################################
#2010_09_24_15:32:29 add by greshem
sub check_beecrypt($)
{
	(my $line)=@_;
	if($line=~/^\s*#include\s*<beecrypt/)
	{
		#include
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 beecrypt 特征.\n");
		if($g_CXXFLAGS!~/beecrypt/)
		{
			$g_CXXFLAGS.=" -I /usr/include/beecrypt   ";
		}

		#lib
		if($g_LIBS!~/lbeecrypt/)
		{
			$g_LIBS.=" -lbeecrypt ";
		}
	}
}
########################################################################
#crypt 2010_09_27_18:21:16 add by greshem
#这段时间在看密码学， CRYPT函数用的比较多。 
sub check_crypt($)
{

	(my $line) =@_;
	if($line=~/crypt\(/)
	{
		#lib
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 crypt 特征.\n");
		if($g_LIBS!~/-lcrypt/)
		{
			$g_LIBS.=" -lcrypt ";
		}
	}
}

########################################################################
#2010_09_27_18:29:38 add by greshem
# ctemplate
sub check_ctemplate($)
{
	(my $line) =@_;
	if($line=~/^\s*#include\s*<ctemplate/)
	{
		#include lib

		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 ctemplate 特征.\n");
		if($g_LIBS!~/lctemplate/)
		{
			$g_LIBS.=" -lctemplate";
		}
	}
}

########################################################################
# dlopen
sub check_dlopen($)
{
	(my $line) =@_;
	if($line=~/^\s*#include\s*<dlfcn.h/)
	{
		#lib
		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 dlopen 特征.\n");
		if($g_LIBS!~/-ldl/)
		{
			$g_LIBS.=" -ldl";
		}
	}

}
########################################################################
# ncurses
#2010_09_28_18:31:19 add by greshem
sub check_ncurses($)
{
	(my $line) =@_;
	if($line=~/^\s*#include\s*<ncurses.h/)
	{
		#lib

		logger("$g_cur_cpp_filename 第 $g_CUR_LINES 行|$line|, 含有 ncurses 特征.\n");
		if($g_LIBS!~/-lncurses/)
		{
			$g_LIBS.=" -lncurses";
		}
	}
}
#generate makefile

########################################################################
sub WriteMakefile
{
	our @ARGV;
	unlink "makefile" or die "Can not rm makefile ($!)" if -e "makefile";
	open MAKEFILE, ">Makefile" or die "Can not open makefile";
	select MAKEFILE;
	print "CC = ".$GCC." -g  -Wall \n";
	print "CPP = ".$CPP."-g  -Wall \n";
	# print "CC = gcc   -Wall \n";
	# print "CPP = g++ -Wall \n";
	if(scalar(values(%g_MAIN)) > 0 )
	{
	   print "EXEC = ";
		foreach  (values(%g_MAIN))
		{
			print $_."  ";
		}
		print "\n";
	}
	else
	{
	   print "EXEC = compile\n";
	   warn "No main set to compile\n";
		#$g_EXEC="compile";
	}

	print "MAIN_OBJS= ";
	foreach( values %g_MAIN)
	{
	   print $_ . ".o  ";
	}
	print "\n";

	print "NOMAIN_OBJS= ";
	foreach( values %g_NOMAIN)
	{
	   print $_ . ".o ";
	}

	print "\n";
	print "CFLAGS +=$g_CXXFLAGS -Wno-write-strings\n";
	print "LDFLAGS += $g_LDFLAGS\n";
	print "LIBS +=$g_LIBS\n";
	print "\n";

	print 'all: $(EXEC)' . "\n";
	print '$(EXEC): $(MAIN_OBJS)  $(NOMAIN_OBJS) ' . "\n";
	print "\t" . '$(CPP) $(LDFLAGS) -o $@ $@.o $(NOMAIN_OBJS) $(LIBS)' . "\n";
	print "\t" . 'objdump -S  $@  |c++filt   > $@.asm '."\n";
	print "\n";
	print "vim: \n";
	print "\tvim ", $argv[0],"\n";

	my $bin=$argv[0];
	$bin=~s/\.cpp//g;
	$bin=~s/\.c//g;
	print 'exec: $(EXEC) ';
	print "\n";
	print "\t".'./$(EXEC)'."\n";
	#print "\t".'./$@'."\n";;

	print "log:\n";
	print "\t vim ",$bin,"\.log\n";
	print "gdb: \n";
	print "\tgdb ./", $bin,"\n";
	print <<EOF
.PRECIOUS:%.cpp %.c %.C
.SUFFIXES:
.SUFFIXES:  .c .o .cpp .ecpp .pc .ec .C

.cpp.o:
	\$(CPP) -c -o \$*.o \$(CFLAGS) \$(INCLUDEDIR)  \$*.cpp
	\$(CPP) -S   \$(CFLAGS) \$(INCLUDEDIR)  \$*.cpp

.c.o:
	\$(CC) -c -o \$*.o \$(CFLAGS) \$(INCLUDEDIR) \$*.c
	\$(CC) -S   \$(CFLAGS) \$(INCLUDEDIR) \$*.c

.C.o:
	\$(CC) -c -o \$*.o \$(CFLAGS) \$(INCLUDEDIR) \$*.C	
	\$(CC) -S   \$(CFLAGS) \$(INCLUDEDIR) \$*.C	

.ecpp.C:
	\$(ESQL) -e \$(ESQL_OPTION) \$(INCLUDEDIR) \$*.ecpp 
	
.ec.c:
	\$(ESQL) -e \$(ESQL_OPTION) \$(INCLUDEDIR) \$*.ec
	
.pc.cpp:
	\$(PROC)  CPP_SUFFIX=cpp \$(PROC_OPTION)  \$*.pc
	
EOF
;
	# while(my($key,$value) = each %g_COMP)
	# {
	#    print "$key:$value\n";
	#    my $name;
	#    if($g_SUFFIX{$key} eq "cpp")
	#    {
	# 	$name = GetCppName($key,"o");
	#    }
	#    else
	#    {
	# 	$name = GetCName($key,"o");
	#    }
	#    print "\t" . '$(CC) $(CFLAGS) -c ' . "$name\n";
	#    print "\t" . 'gcc -S   $(CFLAGS) ' . "$name\n";
	#    print "\n";
	# }

	print "\n";
	print "clean:\n";
	print "\t" . '-rm -f $(EXEC) *.o *.s *.log *.obj' . "\n";
	close MAKEFILE;
	select STDIN;
}

sub WriteBakefile()
{
	open(BAKEFILE, "> build.bkl") or die("create file build.bkl  error \n");
	select(BAKEFILE);

# my %g_OBJS; # name.cpp $g_OBJS{"name.cpp"} => "name.o" 
# my %g_COMP; # 编译列表.  "name.o"  =>"name.cpp"
# my %g_SUFFIX;
# my %g_MAIN; 	# 含有 main 的 文件名，"name.cpp" => "name" 
# 		  	# "name.c" => "name" 
# my %g_NOMAIN; # 没有main 的 .c .cpp 文件. 
# my $g_EXEC; # name.cpp 有main 然后可以 添加成  $g_EXEC{"name"} => "name.cpp", 注意有main函数才可以. 
# 
# my $g_LIBS = "";
# my $g_TOTAL_LINES = 0;
# my $g_CXXFLAGS = "";
# my $g_LDFLAGS="";
	my $key1;
	my $key2;
	foreach $key1 (keys(%g_MAIN))
	{
		print "############################\n";
		print "EXE= $g_MAIN{$key1}\n";
		foreach $key2 (keys(%g_NOMAIN))
		{
			print " CPP= $key2\n";
		}
	}
	print "LIBS $g_LIBS\n"; 
	print "CXXFLAGS $g_CXXFLAGS\n";
	print "LDFLAGS $g_LDFLAGS\n";
}

########################################################################
#foreach(glob "*.cpp")
#{
#&ParseFile($_,"cpp");
#}

#foreach(glob "*.h")
#{
#&ParseFile($_,"h");
#}
#foreach(glob "*.c")
#{
#&ParseFile($_,"c");
#}


########################################################################
sub DeSuffix
{
	my ($file,$suffix) = @_;
	#print "$file->$suffix\n";

	$file =~ s/.$suffix$//i
	   or die "Can not desuffix $suffix from $file";
	#print "$file->$suffix\n";
	return $file;
}

########################################################################
sub GetObjName
{
	my ($obj,$suffix) = @_;
	$obj =DeSuffix($obj,$suffix) . ".o";
	return $obj;
}

########################################################################
sub GetCppName
{
	my ($cpp,$suffix) = @_;
	$cpp =DeSuffix($cpp,$suffix) . ".cpp";
	return $cpp;
}

########################################################################
sub GetCName
{
	my ($cpp,$suffix) = @_;
	$cpp =DeSuffix($cpp,$suffix) . ".c";
	return $cpp;
}

########################################################################
sub AddToCOMP
{
	my($obj, $file) = @_;
	unless( defined($g_COMP{$obj}) and $g_COMP{$obj} =~ /$file/)
	{
	   $g_COMP{$obj} .= " " . $file if -e $file;
	}
}

#最简单的.
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /var/log/gen_makefile_from_files.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

