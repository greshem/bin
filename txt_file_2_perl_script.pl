#!/usr/bin/perl
#20100919 orgin.
#2011_02_24_14:07:51   ������   add by greshem
# ����д�Ĳ���̫�ã� __DATA__�� __DATA__ �е㸴����, ���õ���perl  ��Template. 
# �����Ǽ����Ĺ��ȵ�ʹ����., �õ��� û�дﵽ����ĸ��Ӷȵ� ����.  

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

#���ļ������붼ת���ڴ����� array��.
@array= (<FILE>);

my $var={
	array=>\@array,
};

#__DATA__ �����ѭ��ʵ��˵, ��@array ����Ķ�������ӡһ��. 
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
