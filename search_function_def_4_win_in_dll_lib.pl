#!/usr/bin/perl
do("c:\\bin\\repaire_perl_path_2_win32.pl");
use strict;

#gen_function_txt_file();
#print "DDDDDDD\n";
my $pattern = shift or  usage();
search("$pattern");

#第一次初始化的时候执行 dumpbin dump 二进制到文本  便于索引 
if($pattern=~/init_search/)
{
	gen_function_txt_file();
}

sub usage()
{
	warn("Usage: $0  input_function_name \n");
	warn("\t  init_search,  init  to disassemble  all libs \n");
	die("\n");
}

########################################################################
#sub function , 历遍 %LIB% 目录下的 静态的库的    *.DISASM.asm *.EXPORT.asm 文件, grep 并打印.
sub search($)
{
	(my $pattern)=@_;
	my $lib_path_str=$ENV{"LIB"};
	my @lib=split(/\;/, $lib_path_str);

	for(@lib)
	{
		chdir($_) or die("chdir error \n");;
		my @libs=glob("*.lib");
		my $each_lib;
		for $each_lib (@libs)
		{
			my $file_to_grep= "$each_lib.DISASM.asm";
			if ( -f $file_to_grep) {shell_grep($pattern, $file_to_grep ); };
			$file_to_grep="$each_lib.EXPORTS.asm";
			 if ( -f $file_to_grep){ shell_grep($pattern,  $file_to_grep);};
		}
	}
}	

#仿 grep 的函数.
sub shell_grep($$)
{
	(my $pattern, my $file)=@_;
	if(! open(GREP, $file))
	{
		warn("[shell_grep]:Open file $file error\n");
		return;
	}

	my $count=undef;
	for(<GREP>)
	{
		if($_=~/$pattern/)
		{
			$count++;
			#print $_;
		}
	}
	close(GREP);
	if( $count > 0)
	{
		print "$pattern  -->   $file \n";
	}
	return $count;
}

#==========================================================================
# 对所有的静态, 全部 dumpbin 出来到   DISASM.asm EXPORTS.asm 文件. 
sub gen_function_txt_file()
{
	print "gen_function_txt_file start  \n";
	my $lib_path_str=$ENV{"LIB"};
	my @lib=split(/\;/, $lib_path_str);

	for(@lib)
	{
		print "开始处理, $_ \n";
		my $win_path=repaire_to_win_path($_)."\n";

		chdir($_) or die("chdir error \n");;

		my @libs=glob("*.lib");

		my $each_lib;
		for  $each_lib (@libs)
		{
			#$each_lib=~s/^/\"/g;
			#$each_lib=~s/$/\"/g;
			print ("dumpbin /DISASM \"$_\\$each_lib\"  >   \"$_\\$each_lib.DISASM.asm\"\n");
			system("c:\\bin\\dumpbin.exe /DISASM \"$_\\$each_lib\"  >   \"$_\\$each_lib.DISASM.asm\"\n");
			print ("dumpbin /EXPORTS \"$_\\$each_lib\"  >   \"$_\\$each_lib.EXPORTS.asm\"\n");
			system ("c:\\bin\\dumpbin.exe /EXPORTS \"$_\\$each_lib\"  >   \"$_\\$each_lib.EXPORTS.asm\"\n");
		}	
	}
}


sub deal_with_a_static_lib()
{
	print "#start dumpbin  \n";
	system(" file_type_lib_dumpbin.pl  ");
	system(" ./a.bat ");
}
