#!/bin/bash
#2011_03_01_13:03:56   星期二   add by greshem
gtags&&htags -n
name=$(basename $(pwd))
if [ -d HTML ];then
cd HTML 
else 
 	echo "globals 不存在"
	exit -1
fi

#/bin/chm_template_build_v2.sh
#把 /bin/chm_template_build_v2.sh dump 成下面的3行. 

perl /root/bin/template_HHC_v2.pl 
perl /root/bin/template_HHK_v2.pl
perl /root/bin/template_HPP_v2.pl 

chmod -R 000 /tmp/.wine-0/

#wine hhc.exe HTML.hpp
docker run  -it  --privileged=false  -v /root/:/root/ -v /tmp3/portage:/tmp3/portage   -v /root/.wine/:/root/.wine  -v /home/:/home/  -w $(pwd)  chm_make    wine  hhc.exe HTML.hpp

if [ -f  HTML.chm ];then
mv HTML.chm ../${name}.chm
cd ..
fi

rm -rf HTML

