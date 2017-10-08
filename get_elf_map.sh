#!/bin/bash
#2011_02_18 add by greshem

foo ()
{
	$in=$1;
	for each in $(cat $in  ); 
	do 
		 echo $each;  
	done 
}
########################################################################
#mainloop 

if [ !  $# -eq 1 ];then
	echo "Usage: ", $0 , "in";
	exit 
fi

in=$1;

nm --extern-only --defined-only -v --print-file-name $in


