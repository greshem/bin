#!/bin/bash
for each in $(dir -1 *.tar.cpt)
do
	ccdecrypt $each -K q******************************n
	tar -xf ${each%%\.cpt}
	if [ $? -eq 0 ];then
		 	rm -f ${each%%\.cpt}
	else
		echo "tar failuer";
	fi	
done
