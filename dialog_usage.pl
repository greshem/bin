#!/usr/bin/perl

#2011_02_25_10:42:50   星期五   add by greshem
foreach (<DATA>)
{
	print $_;
}
__DATA__
# 相同类型的软件是 zenity 软件. gtk 下面产生 DIALOG 的工具.   newt
# pinentry python-dialog PolicyKit-gnome kgtk gtweakui
#dialog   --calendar     text 10 10 day month year
dialog   --calendar      calendar 10  10  2010  1  3

dialog   --fselect      /root/ 10 20

dialog   --gauge        text 10 20  30

dialog   --infobox      text 10 20
dialog   --inputbox     text 10 20 "please input a number"
dialog   --msgbox       text 10 20
dialog   --passwordbox  text 10 20 "please input a password";
dialog   --pause        text 10 20 10

dialog   --tailbox      file 10 20
dialog   --tailboxbg    file 10 20
dialog   --textbox      file 10 20
dialog   --timebox      text 10 20 22 22 22 
dialog   --yesno        text 10 20



########################################################################
#注意之后的  第三个参数 都是指 内部的框的高度. 
########################################################################
dialog   --inputmenu    text 40 40  30   tag1 item1 tag2 item2 tag3 item3 tag4 item4 
dialog   --menu         text 40 40  30   tag1 item1 tag2 item2 tag3 item3 tag4 item4 

########################################################################
#checkbox 可以多选  							
dialog   --checklist    text 40 40  30  tag1 item1 status1 tag2 item2  status2  tag3 item3  status3  tag4 item4  status4

########################################################################
dialog   --form         text height widh  form_height  10 label1 l_y1 l_x1 item1 i_y1 i_x1 flen1 ilen1 
dialog   --form         qian 40     40    30     label1 l_y1 l_x1 item1 i_y1 i_x1 flen1 ilen1  label2 2_y1 2_x1 item2 2_y1 2_x1 flen2 ilen2  label 3_y1 3_x1 item3 3_y1 3_x1 flen3 ilen3

########################################################################
#单选框. 
#dialog   --radiolist    text  40  20   内部的list的高度.       |tag0  item0   0|tag1  item1   1| tag2  item2   2|
dialog   --radiolist    text  40  20   30        tag0  item0   0  tag1  item1   1  tag2  item2   2  tag3  item3   3 tag4  item4   4

#==========================================================================
#form 的一个例子 比较复杂
dialog --ok-label "Submit" \
	  --backtitle "linux" \
	  --form "Here is a possible piece of a configuration program." \
20 50 0 \
	"Username:" 1 1	"$user" 1 10 10 0 \
	"UID:"      2 1	"$uid"  2 10  8 0 \
	"GID:"      3 1	"$gid"  3 10  8 0 \
	"HOME:"     4 1	"$home" 4 10 40 0 \

#更多的例子参考  /usr/share/doc/dialog/sample/  
