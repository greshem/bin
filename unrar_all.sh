#!/bin/bash
for each in $(dir -1 |grep rar$)
do

echo unrar x -o+ -r $each ${each%%.rar}
unrar x -o+ -r $each ${each%%.rar}
	if [ $? -eq 1 ];then
		mkdir ${each%%.rar}
		unrar x -o+ -r $each ${each%%.rar}

	fi
done
