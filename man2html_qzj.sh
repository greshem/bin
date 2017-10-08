#!/bin/bash
command=$1;
for each in $( /bin/man_glob.pl $command)
{
	#echo $comand man not exist
	echo $each
	cat $each   |gzip -d |man2html > $command.html
}
