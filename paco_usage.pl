#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#list all 
paco -a

#��װ��  ���밲װ 
paco -lp "pgname" "make install"

# # �г����е��ļ�,  
# paco -f   pgname

