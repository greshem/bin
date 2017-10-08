#!/bin/bash
#qianlong script
#2010_08_30_10:10:10 add by greshem
#挂载的顺序从膝盖调整了一下。 
##################################################
function do_mount_loop()
{
 IMG=$1
 for each in  iso9660 ext3  cramfs   vfat squashfs romfs  
 do
  mount -t $each $IMG dir -o loop 2>/dev/null
  if [ ! $? -eq 0 ] ;then
        echo "mount somtthing wrong ,and now exit "
  else
	echo "mount with $each"
  break;
  fi
 done
}
###########main########################################
#对压缩文件进行处理。 

if [ -d dir ];then
	umount dir 	
else
	mkdir dir
fi

COMPRESS_IMG=$1
IMG=
rand=$RANDOM
echo "-------------"$1
if file $1  |grep gzip ;then
## ok ,file is the bz2 type or not!
	echo "gzip file"
	cp $1 $1_$rand.gz
   	gzip -d $1_$rand.gz 
	if file $1_$rand |grep cpio;then
		[[ ! -d dir ]] && mkdir dir 
		cd dir	
		
		echo cpio -imd \< ../$1_$rand
		cpio -imd < ../$1_$rand
		cd ..   
		rm $1_$rand
	else
		do_mount_loop $1
	fi

else 
do_mount_loop $1
fi
################################################################
#
# umount dir 	
# mkdir dir 2>/dev/null
#  if [ ! $? -eq 0   ];then
#    if [ $(find dir |wc|awk '{print $1}') -lt 3 ];then
#  #     rm -rf dir	
#       mkdir dir
#    else 
# 	echo "you should see if dir have something important"
#    fi
#  else 
# 	exit -4
#  fi
###############################################################
if [ -z $IMG ] ;then
{
	echo "you should expect the image name "
        exit -5 
}
fi
################################################################

