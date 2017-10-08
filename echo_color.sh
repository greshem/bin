#!/bin/sh
#echo_color  41 31 rtest
#一共三个参数 第一个  40 - 49 
#			  第二个  30 - 39 
#			  第三个  字符串 

#echo_color  41 38 red_back_ERROR_错误信息.


dump_all()
{
	for each in $(seq 40 1 49 ); 
	do 
	 for each2 in $(seq 30 1 39 ) ;
	  do  
	  #echo -e "\033[$each;${each2}m  $each something here $each2  \033[0m";
	  echo_color $each $each2  "$each  $each2"
	  done; 
	done   
}
echo_color() 
{	
	echo $#
	if [ $# -eq 3 -a $1 -gt 40 -a $1 -lt 49 -a $2 -gt 30 -a $2 -lt 39 ];then
		echo -e "\033[$1;$2m$3 \033[0m"
	else
		echo color1 color2 string
		echo 40\<color1\<49 30\<color2\<39 
	fi
}

echo_color  41 38 rtest

#dump_all
