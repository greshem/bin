#!/usr/bin/perl
use Cwd;
$pwd=getcwd();

for( grep { -f } glob($pwd."/*.rar"))
{
	my $dest_dir=$_;
	$dest_dir=~s/\.rar//g;
	my $each=$_;
	if($^O=~/win/i)
	{
		$dest_dir=~s/\//\\/g;
		$each=~s/\//\\/g;
	}
	print "mkdir $dest_dir\n";
	print "unrar x -o+ -r  $each $dest_dir\n"; 
		
}

sub shell_usage()
{
	foreach (<DATA>)
	{
		print $_;
	}
}
__DATA__
#!/bin/bash
for each in $(dir -1 |grep rar$)
do
#x extrace
#-o+   ����ģʽ. 
#r 	 �ݹ�ģʽ.
#  $each �� ��ѹ�ļ�. 
#  ���һ���� �����Ŀ¼�� ����û�����Ŀ¼�� �����´������Ŀ¼.  
echo unrar x -o+ -r $each ${each%%.rar}
unrar x -o+ -r $each ${each%%.rar}
	if [ $? -eq 1 ];then
		mkdir ${each%%.rar}
		unrar x -o+ -r $each ${each%%.rar}

	fi
done

