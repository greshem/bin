#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
dolphin
thunar
nautilus
konquerer
konqueror programs:/
wine file manager
pcmanfm
emelfm2

#下面的命令可以找到更多.
yum search  file manager

#vim netrw , F1, t,p
#vim 中文手册7.2 , 22.1 文件浏览器.

ranger #vim 
mutt ncmpcpp

#zsh 配合ZSH 的补全的方式 真的 比bash 爽了很多. 
zsh 
