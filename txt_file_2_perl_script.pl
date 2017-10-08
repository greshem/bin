#!/usr/bin/perl
#20100919 orgin.
#2011_02_24_14:07:51   星期四   add by greshem
# 代码写的不是太好， __DATA__的 __DATA__ 有点复杂了, 还用到了perl  的Template. 
# 绝对是技术的过度的使用了., 用到了 没有达到这里的复杂度的 技术.  

use Template;
$file=shift or warn("Usage: $0 file file no exists will create \n");

my $config=undef;

my $template=Template->new();
if(! -f $file)
{
	#open(FILE, ">".$file) or die("create file error $!\n");
}
else
{
	open(FILE, $file) or die("open file error $!\n");
}

#把文件的输入都转成内存数据 array了.
@array= (<FILE>);

my $var={
	array=>\@array,
};

#__DATA__ 里面的循环实在说, 把@array 里面的东西都打印一遍. 
$template->process(\*DATA, $var, $file.".pl") || die $template ->error();

if($file=~/pl$/)
{
	print "mv $file.pl $file \n";
}
__DATA__
#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
[% FOREACH line IN array %][% line %][%END%]
