if [ -f /usr/src/libmenu.so.5.3_for_2.6 -a -f libform.so.5.3_for_2.6 ];then
 yes |cp /usr/src/libmenu.so.5.3_for_2.6 /usr/lib/
 yes |cp /usr/src/libform.so.5.3_for_2.6 /usr/lib/
else 
 echo WARNING:can't patch for the libmenu libform 
	exit -1
fi

cd /usr/lib
rm -rf libmenu.so.5
ln -s libmenu.so.5.3_for_2.6 libmenu.so.5
rm -rf libform.so.5
ln -s libform.so.5.3_for_2.6 libform.so.5
