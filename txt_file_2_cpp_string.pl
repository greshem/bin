#!/usr/bin/perl
#2011_04_01_15:59:07   ������   add by greshem
#�������� string �Ĵ���  ������Ԫ���Ե� ʱ�� ���ж���. 
#fixme  ���� '[]=-!~,.//., ��Щ������ŵĴ���. 
#���� �Լ� �������Ծ�. 
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
