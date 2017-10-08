#!/usr/bin/perl
#2011_04_01_15:59:07   星期五   add by greshem
#用来生成 string 的代码  用来单元测试的 时候 进行断言. 
#fixme  对于 '[]=-!~,.//., 这些特殊符号的处理. 
#对于 自己 还不能自举. 
my $file=shift  or die("Usage: $0 input_file\n");
#$file="txt_file_2_cpp_string.pl";
sub gen_cpp_src($)
{
	(my $file)=@_;
	open(FILE, $file) or die("open file error\n");
	print "string file_str;\n";
	for(<FILE>)
	{
			chomp;
			$_=~s/\\/\\\\"/g;
			$_=~s/"/\\"/g;
			print "file_str+=\"".$_."\\n\"".";\n";
	}
}
gen_cpp_src($file);
