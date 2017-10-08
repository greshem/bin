#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
ctags   -n   -R # 生成行号
ctags -x -R .  	# 生成正则表达: 产生可读的 用行好定位 TAG的文件
ctags -R . 		# 一般的用法

ctags -R -h ".php"  #support php file, suffix 
