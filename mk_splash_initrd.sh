
file=$1
if [ ! -f /bin/splash ];then
   cd /bin 
  [[ -f splash.gz ]]&& gzip -d /bin/splash.gz
fi
if /bin/jpeginfo  $file  |grep 640x480;then 
	
	sed -i "/^jpeg/{s/.*/jpeg=\/splash_boot\/$file/g}" bootsplash-640x480.cfg 
	sed -i "/^silentjpeg/{s/.*/silentjpeg=\/splash_boot\/$file/g}" bootsplash-640x480.cfg 
	splash -s -f bootsplash-640x480.cfg >initrd_${file%%.jpg}_splash
else
	echo "not corrent 640x480 jpeg "
fi

