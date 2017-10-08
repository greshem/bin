#!/bin/bash

if [ ! -f /bin/gen_makefile_from_file_latest.pl ];then
	echo "gen_makefile_from_file_latest.pl not exists ";
	exit -1;
fi

for each in $(dir -1 |grep '\.cpp$'|tac); 
do 
	echo "########################################################################"
	echo "#DEAL with " $each;
	if  grep $each /tmp/ok;then
	continue;	
	fi	
	/bin/gen_makefile_from_file_latest.pl  $each; 
	sed 's/-Wall/-w/g' Makefile -i
	make ; 
	if [  ! $? -eq 0 ];then
		echo "stop ,compile  error"
		exit
	fi
	make exec 

	if [ !  $? -eq 0 ];then
		echo "stop , exec  error"
		exit 
	fi
	make clean
	echo $each >> /tmp/ok
done

for each in $(dir -1 |grep '\.c$'); 
do 
	echo "#DEAL with " $each;
	gen_makefile_from_file.pl $each; make ; 
done
