#!/bin/sh
####################################################################
function deal_index()
{ 
  sed -i 's/<[^>]*>//g' $1
  sed -i '/[0-9]\{2\}\-[a-zA-Z]\{3\}\-[0-9]\{4\}/!d' $1
  sed -i 's/[0-9]\{2\}\-[a-zA-Z]\{3\}\-[0-9]\{4\}/\ \ \ \ /g' $1
  #sed -i 's/rpm/rpm\ \ \ /g' $1
}
[[ $# -eq 2 ]] &&echo Usage $0: install_package &&exit -1 
TARGZ_ROOT=/root/linux_src
TARGZ_BOOT_INDEX=/root/linux_src/index.html
if [ ! -d $TARGZ_ROOT ];then
	echo "the TARGZ_ROOT does not exitsk, now will create it "
	mkdir $TARGZ_ROOT
 	echo "mkdir success"
fi
echo "start indexfile"
if [ ! -f $TARGZ_BOOT_INDEX ];then
  echo "the index.html does not exist ,and will get the new one"
  cd $TARGZ_ROOT
 echo "now will get the index file"
  wget 192.168.3.189/linux_src
  deal_index index.html
fi
temp=$(cat $TARGZ_BOOT_INDEX|grep $1|awk '{print $1}')
if [ -z "$temp" ];then
 echo "no package find, now exit"
 exit -2
fi

dir=$(pwd)
[[ ! -d $TARGZ_ROOT  ]] &&mkdir $TARGZ_ROOT
cd $TARGZ_ROOT

for each in  $temp

do
 if [ ! -f $each ];then
 		wget  192.168.3.189/linux_src/$each 2>/dev/null 
	if [ $? -eq 0 ] ;then
	   echo " $each "
	 else 
	   echo "wget $each error"
	 fi
 else
	echo "$each exits now will remove it " 
  	rm -rf $each
 fi
done
cd $dir
