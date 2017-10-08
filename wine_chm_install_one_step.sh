#!/bin/bash
#2010_07_26_19:02:48 add by qzj
#wine 初始化 一下。 
#20100802
yum install  wine
yum install global
/bin/cpan_init_f13.sh 
yes |cpan Template
if test ! -d /root/.wine/ ;then
	wine notepad 
fi
# 假如在/root/wine_chm 目录， 把所需要的文件都拷贝到当前目录下面。 
if [ ! -d /root/wine_chm/ ];then
	echo " /root/wine_chm not exist ";
	exit
fi
yes |cp htmlhelp/htmlhelp/hhc.exe /root/.wine/drive_c/windows/
yes |cp htmlhelp/htmlhelp/hhc.exe . 



cp -a itircl.dll /root/.wine/drive_c/windows/system32/
cp -a itss.dll /root/.wine/drive_c/windows/system32/
wine regsvr32 /s 'C:\WINDOWS\SYSTEM32\itircl.dll'
wine regsvr32 /s 'C:\WINDOWS\SYSTEM32\itss.dll'


cp htmlhelp/htmlhelp/hha.dll . 
cp hha.dll /root/.wine/drive_c/windows/system32/


#cp -a mfc40.dll ~/.wine/drive_c/windows/system32/

wine regedit htmlhelp.reg 

cp hha.dll itircl.dll Itircl.dll itss.dll /root/.wine/drive_c/windows/system32/


cd /root/
wine hhc.exe
