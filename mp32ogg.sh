#!/bin/bash
#2011_06_27_13:58:08   星期一   add by greshem
# if [ !  $# -eq 1 ];then
#     echo "Usage: " $0  "    file.mp3";
#     #exit 
# fi
file=$1;
#file=$1

#有没有 mpg123命令.
mpg123=$(which mpg123);
if [ -z  $mpg123 ];then
	echo "mpg123 not exists "
	echo "Please install it "
	exit
fi

if [ ! -f $file ];then
	echo $file " not exists";
	exit
fi


if [   $# -eq 1 ];then
	echo "##One FILE";
	echo mpg123 -v -w test.wav $file
	mpg123 -v -w test.wav $file
	oggenc test.wav -o ${file%%mp3}ogg
else

	for each in $(dir -1 |grep mp3$); 
	do 
		echo mpg123 -v -w test.wav $each
		mpg123 -v -w test.wav $each
		oggenc test.wav -o ${each%%mp3}ogg
	done


fi


