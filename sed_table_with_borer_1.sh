#!/bin/bash
if [ $# -eq 2 ];then
	echo "Usage: $0 $1";
	exit
fi

file=$1;
if grep "table  border=0" $file;then
	echo "have sed it ";
else
	echo sed -i  's/<table >/<table  border=0 cellpadding=0 cellspacing=1 bordercolor=#3366FF bgcolor=#000000>/g' $file 
	sed -i  's/<table >/<table  border=0 cellpadding=0 cellspacing=1 bordercolor=#3366FF bgcolor=#000000>/g' $file 
fi



