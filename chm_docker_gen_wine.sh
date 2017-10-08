gtags && htags 

if [ -d HTML ];then
cd HTML 
else 
 	echo "globals ²»´æÔÚ"
	exit -1
fi


perl /root/bin/template_HHC_v2.pl 
perl /root/bin/template_HHK_v2.pl
perl /root/bin/template_HPP_v2.pl 

#wine hhc.exe HTML.hpp
docker run  -it  -v /root/:/root/ -v /tmp3/portage:/tmp3/portage   -v /root/.wine/:/root/.wine  -v /home/:/home/  -w $(pwd)  chm_make    wine  hhc.exe HTML.hpp

#if [ -f  HTML.chm ];then
#mv HTML.chm ../${name}.chm

