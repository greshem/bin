#!/bin/bash


#iso=$1;
for iso in $(/bin/for_each_file.pl iso$)
do
	mkdir dir 
	/bin/qloop.sh $iso
	cd dir 

	for each in $(find . |grep tar.gz$); 
	do 
	tar -tzf $each > /dev/null ; 
	echo $each; 
	done
	cd ..
	umount dir 
done
