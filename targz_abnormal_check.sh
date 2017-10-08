#!/bin/bash 
for each in $(dir *.tar.gz); 
do
	tar -tzf $each> /dev/null ;
	if [ !  $? -eq 0 ]; then 
		echo $each ;
		echo $each >> /var/log/targz_abnorm.log
	fi  ; 
done  
