#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
ctags  cscope global ida   Grep ranger vim newrw Taglist

#==========================================================================
#res
/root/vim_common/vim_install/cscope_maps.vim		#keyborad map 
rpm -ql global |grep vim 
/usr/share/gtags/gtags-cscope.vim
/usr/share/gtags/gtags.vim

#==========================================================================
#help
#csope  :cs
#Grep -r 
#netrw F1
#Taglist  F1

#==========================================================================
:Gtags keyword
:Gtags -R keyword  #reference

#Taglist
:Tlist
p Enter
#cscope
:cs find  s keyword #string
:cs find  d keyword #define
:cs find  e keyword #reference
#nmap
ctrl-\ d  
ctrl-\ e

:Grep

#ctags 
ctrl-]  ctrl-T
ctrl-o	#return 
[{ 转到上一个位于第一列的"{"
}]  转到下一个位于第一列的"{"
{   转到上一个空行
}   转到下一个空行

#vim 
* n p 

#table
nt gt gf 	#open file
ctrl-o 		#return 
#==========================================================================
#build database db
gtags 
find . |egrep '\.cpp$|\.cc$|\.C$|\.h$|\.hpp$|\.c$' >  cscope.files
cscope -bkq -i cscope.files
ctags -R . 



