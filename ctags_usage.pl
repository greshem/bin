#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
ctags   -n   -R # �����к�
ctags -x -R .  	# ����������: �����ɶ��� ���кö�λ TAG���ļ�
ctags -R . 		# һ����÷�

ctags -R -h ".php"  #support php file, suffix 
