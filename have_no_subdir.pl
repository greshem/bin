#!/usr/bin/perl
#20100113
#���Դ����Ŀ¼�б�����û����Ŀ¼�ˡ� ���� ������ļ��� Ŀ¼�б� 
$file=shift or die("Usage: $0 all_dir \n");
open(FILE, $file) or die("open file error\n");
for $line (<FILE>)
{
	chomp $line ;
	if( ! -d $line)
	{
		warn("���Դ���:  $line  not dir\n");
	}
	else
	{
		opendir(DIR, $line) or warn("open dir $line error\n");
		@dirs= grep { -d $line."/".$_ && !/^\./} readdir(DIR);
		if(scalar(@dirs)>0)
		{
			for(@dirs)
			{
				print "rm -rf ", $line."/".$_,"\n";
			}
		}
		close(DIR);
	}
}
