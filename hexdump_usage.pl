#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
1. xxd file 
xxd ISO-8859_text.reg 

2. 和下面功能等同  -C 的选项记住， hexdump  /etc/passwd -C 
3. 编辑16 进制 则通过 hexedit 
yum install hexedit 

################
1. hexdump 
2. 
.以字符名称格式显示文件内容
# od -t a sparse_file

.以ASCII格式显示文件的内容
# od -c sparse_file

.以八进制格式显示文件的内容
# od  sparse_file

以十六进制格式显示文件的内容 (内容与上面相同，只是偏移量不同)
# od -A x sparse_file

xxd  默认就是， 很标准的格式了
hexdump  和XXD一样， 默认输出就是标准格式。 

1. windows 可以用 hexplorer
2. fshred  的工具， MFC 单文档的界面， 
#==========================================================================
od, hdump, hexdump, bpe, hexed, beav.

bvi #bin 的vi 编辑器.

