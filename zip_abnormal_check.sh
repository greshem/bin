#!/bin/bash 
for each in $(dir *.zip); 
do
	unzip -l  $each> /dev/null ;
	if [ !  $? -eq 0 ];then 
		echo $each ;
		echo $each >> bad_zip.log
	fi  ; 
done  
