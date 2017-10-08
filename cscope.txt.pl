#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

cscope -Rbkq
-R: 在生成索引文件时，搜索子目录树中的代码
-b: 只生成索引文件，不进入cscope的界面
-k: 在生成索引文件时，不搜索/usr/include目录
-q: 生成cscope.in.out和cscope.po.out文件，加快cscope的索引速度

这个命令会生成三个文件：cscope.out, cscope.in.out, cscope.po.out。
其中cscope.out是基本的符号索引，后两个文件是使用"-q"选项生成的，可以加快cscope的索引速度。
上面所用到的命令参数，含义如下：



