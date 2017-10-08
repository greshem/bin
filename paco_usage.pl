#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#list all 
paco -a

#安装包  编译安装 
paco -lp "pgname" "make install"

# # 列出所有的文件,  
# paco -f   pgname

