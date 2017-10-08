
docker run  -it  -v /root/bin:/root/bin -v /tmp3/portage:/tmp3/portage    docker.io/rhoot/wine32   /bin/bash
docker run  -it  -v /root/bin:/root/bin -v /tmp3/portage:/tmp3/portage   -v /root/.wine/:/root/.wine  docker.io/rhoot/wine32   /bin/bash

########################################################################


docker run  -it  -v /root/:/root/ -v /tmp3/portage:/tmp3/portage   -v /root/.wine/:/root/.wine    centos   /bin/bash
#yum install  gcc make 
#docekr commit   gcc_compile 
#yum install global 
#docker commit global5
#
docker run  -it   --privileged=true  -v /root/:/root/ -v /tmp3/portage:/tmp3/portage   -v /root/.wine/:/root/.wine  chm_make   /bin/bash
docker run  -it   --privileged=true  -v /root/:/root/ -v /tmp3/portage:/tmp3/portage   -v /root/.wine/:/root/.wine    -v $(pwd):$(pwd)  chm_make    gtags && htags 
#docker run  -it   --privileged=true  -v /root/:/root/ -v /tmp3/portage:/tmp3/portage   -v /root/.wine/:/root/.wine    -v $(pwd):$(pwd)  chm_make  cd $(pwd) &&  gtags && htags 


cd HTML
perl /root/bin/template_HHC_v2.pl 
perl /root/bin/template_HHK_v2.pl
perl /root/bin/template_HPP_v2.pl 
docker run  -it --rm  -v /root/:/root/ -v /tmp3/portage:/tmp3/portage   -v /root/.wine/:/root/.wine  -v /home/:/home/  -w $(pwd)  chm_make    wine  hhc.exe HTML.hpp
