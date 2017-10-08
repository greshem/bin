#!/usr/bin/perl -W
#2011_08_03_11:16:45   星期三   add by huanghaibo
#
#这里处理的dsp文件 是通过个人的 是读取dsp的关键字段，生成bakefile
#
our $g_exe;
our $g_lib_path;
our $g_rc;
our $g_cxx;
our $g_ldflags;
sub deal_with_one_dsp_file($);


$dsp_file = shift or warn("usage: $0 input_file.dsp\n");
if(!defined($dsp_file))
{
	@dsps=glob("*.dsp");
	@tmp=glob("*.DSP");
	push(@dsps, @tmp);

	$dsp_file=shift(@dsps);

	if(  defined($dsp_file) )
	{
	}
	else
	{
		die("usage: $0 input_file.dsp\n");
	}
}

$bkl=deal_with_one_dsp_file( $dsp_file);

print "#执行:   bakefile -f msvc  $bkl";
system("bakefile -f msvc  $bkl");

print "#执行:  nmake /f makefile.vc";
system("nmake /f makefile.vc");



########################################################################
#解析dsp文件,  并输出一个bakefile 文件.
sub deal_with_one_dsp_file($)
{
	(my $dsp_file)=@_;
	(my $name)=($dsp_file=~/(.*)\.[dsp|DSP]/);
	my $output_bkl=$name.".bkl";
	open(BKL, "> ".$output_bkl) or die("open file $output_bkl 错误, $!\n");
	#open(BKL, "> /tmp/".$output_bkl) or die("open file $output_bkl 错误, $!\n");
	parse_dsp_file($dsp_file);

	my $tmp_str=gen_bkl_dsp_tag_start();
	print BKL $tmp_str;
	$tmp_str=gen_bkl_dsp_tag_mid();
	print BKL  $tmp_str;
	$tmp_str=gen_bkl_dsp_tag_end();
	print BKL $tmp_str;
	close(BKL);

	return $output_bkl
}

########################################################################
#解析文件, 并把对应的东西存到 全局变量里面去.
sub parse_dsp_file($)
{

	$g_exe="";
	$g_lib_path="";
	$g_rc="";
	$g_cxx="";
	$g_ldflags="";

	(my $filename) = @_;
	open(FILE, $filename) or die("open File error $!\n");
	my $in_debug=undef;
	my $in_release=undef;
	for(<FILE>)
	{
		if($_=~/IF.*CFG.*==.*Win32.*Release/)
		{
			$in_release=1;
		}
		if($_=~/IF.*CFG.*==.*Win32.*Debug/)
		{
			$in_debug=1;
		}

		if( !defined($in_debug)) #不在debug 区段, next, 
		{
			next;
		}
		#CFG==\"DiskClean - Win32 Debug
		if($_=~/CFG.*==.*\"(\S+).*-.*Win32.*Debug.*/)
		{
			print "EXE 为  $1\n";
			my $ret_str="	<exe id = \"$1\">\n";

			#$g_exe .= _gen_bkl_exe_from_dsp_line($_);
			# if($g_exe!~/<exe/g)
			# {
			# 	$g_exe .= $ret_str;
			# }
			$g_exe=$ret_str;
		}
		elsif($_=~/^#\s+ADD.*CPP/)
		{
			$g_cxx .= _gen_bkl_cxx_from_dsp_line($_);
		}
		elsif($_=~/^#\s+ADD.*LINK32/)
		{
			$g_ldflags = _gen_bkl_ldf_and_syslib_from_dsp_line();
		}
		elsif ($_=~/^SOURCE=(.*rc)\s+/)
		{
			print "rc资源文件是 $1\n";
			my $ret_str .="	<win32-res> $1 </win32-res>\n";
			$g_rc.=$ret_str;
			#$g_rc .= _gen_bkl_rc_from_dsp_line($_);

		}


		$_=~s/\\$//;   #dsp 的最后的连接符删除掉.
		$_=~s/^\s+//g; #最前面的空格删除掉.
		$_=~s/\s+$//g; #最后面的空格删除掉.
	}
	close(FILE);
}

########################################################################
#生成bakefile 的 sources 的标签.
#行如下格式:
#CFG=DiskClean - Win32 Debug
sub _gen_bkl_exe_from_dsp_line($)
{
	(my $line_data) = $_;
	my  $ret_str;
	my @exe_tmp;
	my @array=split(/\s+\-/, $line_data );
	my $where=index($array[0],"=");
	$where ++;
	push(@exe_tmp, substr ($array[0],$where,100));

	# for(@exe_tmp)
	# {
	# 	$ret_str.="	<exe id = \"$_ \">\n";
	# }
	my $exe=shift (@exe_tmp);
	$ret_str="	<exe id = \"$_ \">\n";

	return $ret_str;
}

sub gen_bkl_libpath($$)
{
	(my $line_data) = @_;
	my  $ret_str;
	my @array=split(/"/, $line_data );
	for(@array)
	{
		if($_ =~ /lib$/)
		{
			$ret_str.="	<lib-path> $_ </lib-path>\n";
		}
	}
	return $ret_str;
}
#dsp 的rc 行 模式是 SOURCE=(.*rc)\s+/
sub _gen_bkl_rc_from_dsp_line($)
{
	(my $line_data) = @_;
	my  $ret_str;
	my @array=split(/\\/, $line_data );
	
	for(@array)
	{
		$_=~s/\\/\\\\/g;
		if($_ =~ /rc\s+/)
		{
			chomp;
			chomp;
			$ret_str .="	<win32-res> $_ #</win32-res>\n";
			#print $_."\n";
		}
	}
	return $ret_str;
}
########################################################################
#处理下面的行.
# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /c
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /FD /c
#注意: 把 /D A_DEFINE_MACRO  变成  /D_A_DEFINE_MACRO (注意空格), 会更容易处理.
sub _gen_bkl_cxx_from_dsp_line($)
{
	(my $line_data) = @_;
	my  $ret_str;
	$line_data=~s/\/D /\/D_/g; 
	my @array=split(/\s+/, $line_data );
	for(@array)
	{
		if($_=~/^\/O2/) #永远不要出现优化.
		{
			next;
		}
		if($_=~/stdafx/i) #预编译 方面的东西都抛弃掉.
		{
			next;
		}

		if(($_=~/^\//) )
		{
			$_=~s/\/D_/\/D /; #替换回来.
			$ret_str.="	<cxxflags> $_ </cxxflags>\n";
		}
	}
	return $ret_str;
}
########################################################################
#处理下面的行
#
#LINK32=link.exe
## ADD BASE LINK32 /nologo /subsystem:windows /machine:I386 
## ADD LINK32 /nologo /subsystem:windows /machine:I386
## ADD LINK32 winmm.lib comctl32.lib rpcrt4.lib wsock32.lib odbc32.lib kernel32.lib user32.lib gdi32.lib  /nologo /machine:i386 /out:"Release\TableListCtrl.exe" /subsystem:windows /libpath:"D:\usr\lib" /INCREMENTAL:NO /NOLOGO /NODEFAULTLIB:LIBCMTD.lib /DEBUG /SUBSYSTEM:WINDOWS /MAC    HINE:X86
 #
sub _gen_bkl_ldf_and_syslib_from_dsp_line($)
{
	(my $line_data) = $_;
	my  $ret_str;
	my @array=split(/\s+/, $line_data );

	my @lib=grep {/\.lib$/} @array; #
	my @ld_tags= grep {/NOLOGO|NODEFULT|nologo|machine|out|subsystem|libpath|incremental|nodefaultlib|\/debug|\/mac/i} @array; ;#

	for(@array)
	{
		if($_ =~ /(.*)\.lib$/)
		{
			$ret_str.="	<sys-lib> $1 </sys-lib>\n";
		}
		elsif($_ =~/\\lib"$/)
		{
			$ret_str.="\n";
			my @lib = split(/"/,$_);
			for(@lib)
			{
				if($_ =~ /lib$/)
				{
					$ret_str.="	<lib-path> $_ </lib-path>\n";
				}
			}
			$ret_str.="\n";
		}
		elsif(($_ =~/^\//)&& !($_ =~/"/)) #原因?  
		{
			$ret_str.="	<ldflags> $_ </ldflags>\n";
		}
	}
	return $ret_str;
}


########################################################################
#bakefile xml 文件的头部.
sub gen_bkl_dsp_tag_start()
{
	my $header_str= <<EOF
<?xml version="1.0" ?>
<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
<makefile>
EOF
; 
	#print $header_str;
	return $header_str;
} 

########################################################################
#输出: 项目的名称, 库路径, include路径, cl.exe 的选项 , link.exe 的选项.
#
sub gen_bkl_dsp_tag_mid()
{
	#print $g_exe."\n";
	my $mid_str.= $g_exe."\n";

	#print $g_lib_path."\n";
	$mid_str.= $g_lib_path."\n";

	#print $g_rc."\n";
	$mid_str.= $g_rc."\n";

	#print $g_cxx."\n";
	$mid_str.= $g_cxx."\n";

	#print $g_ldflags."\n";
	$mid_str.= $g_ldflags."\n";

	return $mid_str;
}
########################################################################
#bakefile 的结束部分.
sub gen_bkl_dsp_tag_end()
{
	$end_str= <<EOF
	<sources>\$(fileList('*.cpp'))</sources>
	</exe>
</makefile>
EOF
;
	print $end_str;
	return $end_str;
}

