#!/bin/bash
#2011_02_15_17:32:14 add by greshem
########################################################################
#mainloop 
function gen_core_file()
{
	if [ !  $#  -eq 1  ];then
		echo "Usage: $0 pid"
	fi
	pid=$1
	data=$(/bin/getTodayTime.sh)
	echo gdb --pid=$pid

	gdb --pid=$pid <<EOF
	gcore  $data.core
EOF
}


if [ !  $# -eq 2 ];then
	echo "Usage: ", $0 , "pid output_dir  ";
	exit 
fi


pid=$1;
subject=$2;
if [ ! -d core ];then
mkdir core
fi
cd core

if [ ! -d $subject ];then
mkdir $subject;
fi

cd  $subject

echo $(pwd);
gen_core_file $pid

echo  "gen core in core/$subject/"
