#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#2010_12_22_ add by greshem
python  的中文注释有 写不同， 具体可以参见
/root/develop_python/ code_comment_annotate.py
########################################################################

html
<!--    <body></body> --> 

########################################################################
bat
	rem 这是注释
########################################################################
perl 
	## 这是注释
########################################################################
asm  at&t
	# 这是注释	
	#
########################################################################
asm intel 
	; 这是注释
########################################################################
python 
	"""
		这是注释
	"""
	这里是说明函数的作用的一种用法。	
	还有### 也是注释的方式

########################################################################
vb
	'这是注释	
########################################################################
pascal
	//这是注释

########################################################################
注册表文件
;; 这是注释


