#!/bin/bash

# if [ !  $# -eq 1 ];then
# 	echo "Usage: " $0  "    file.ogg";
# 	exit 
# fi

file=$1;
#file=$1

#”–√ª”– mpg123√¸¡Ó.
mpg123=$(which lame);
if [ -z  $mpg123 ];then
	echo "lame not exists "
	echo "Please install it,  install  "
	exit
fi

if [ ! -f $file ];then
	echo $file " not exists";
	exit
fi


if [   $# -eq 1 ];then
	echo "##One FILE";
	echo oggdec  -o test.wav $file
	oggdec  -o test.wav $file
	echo lame -V2 test.wav ${file%%ogg}mp3
	lame -V2 test.wav ${file%%ogg}mp3
else

	for file in $(dir -1 |grep ogg$); 
	do 
		echo oggdec  -o test.wav $file
		oggdec  -o test.wav $file
		echo lame -V2 test.wav ${file%%ogg}mp3
		lame -V2 test.wav ${file%%ogg}mp3

	done


fi


