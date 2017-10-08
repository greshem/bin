#!/bin/bash
#2011_03_07_18:33:30   ÐÇÆÚÒ»   add by greshem
#only in f8 
if [ ! -f /usr/bin/i686-pc-mingw32-gcc ];then
	yum install mingw32-gcc
fi


package=$(echo   mingw32-binutils-2.19.51.0.14-1.fc12 mingw32-cpp-4.4.2-2.fc13 mingw32-crossreport-6-3.fc12 mingw32-filesystem-56-2.fc13 mingw32-gcc-4.4.2-2.fc13 mingw32-nsis-2.46-1.fc13 mingw32-nsiswrapper-5-1.fc13 mingw32-pthreads-2.8.0-10.fc13 mingw32-runtime-3.15.2-5.fc13 mingw32-w32api-3.13-5.fc13 )

function show_rpm()
{
	for each in  $package
	do
	echo "rpm -ql " $each
	done
}


function show_all_files()
{
	for each in  $package
	do
	rpm -ql $each
	done

}

if [ !  $# -eq 1 ];then
	#echo "#Usage: " $0  "    input";
	show_rpm  
	echo "#$0 files  while list all file "
	exit 
else
		show_all_files 	
fi



