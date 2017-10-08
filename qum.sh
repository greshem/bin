#!/bin/sh
####################################################################
function deal_index()
{ sed -i 's/<[^>]*>//g' $1
  sed -i 's/rpm/rpm\ \ \ /g' $1
}
[[ $# -eq 2 ]] &&echo Usage $0: install_package &&exit -1 
RPM_ROOT=/root/as5.0
INDEX_FILE=/root/as5.0/index.html
if [ ! -d $RPM_ROOT ];then
	echo "the RPM_ROOT does not exitsk, now will create it "
	mkdir $RPM_ROOT
fi
if [ ! -f $INDEX_FILE ];then
  echo "the index.html does not exist ,and will get the new one"
  cd $RPM_ROOT
  wget 192.168.3.189/as5.0
  deal_index index.html
fi

temp=$(cat $INDEX_FILE|grep $1|awk '{print $1}') 

if [ -z "$temp" ];then
 echo "no $1  package find, now exit"
 exit -2
fi

dir=$(pwd)
[[ ! -d $RPM_ROOT  ]] &&mkdir $RPM_ROOT
cd $RPM_ROOT

for each in  $temp

do
 if [ ! -f $each ];then
 		wget  192.168.3.189/as5.0/$each 2>/dev/null 
	if [ $? -eq 0 ] ;then
	   echo "wget $each success"
	 else 
	   echo "wget $each error"
	 fi
 else
	#echo "$each exits now will remove it " 
  	#rm -rf $each
	a=1
 fi
done
cd $dir
