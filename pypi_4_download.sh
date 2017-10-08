while  [  1 ];
do
set -x 
nohup perl /root/bin/for_each_dir.pl "perl /root/bin/pypi_download_src.pl  *.html  |sh  " > nohup & 
sleep 1
nohup perl /root/bin/for_each_dir.pl "perl /root/bin/pypi_download_src.pl  *.html  |sh  " > nohup2 & 
sleep 1
nohup perl /root/bin/for_each_dir.pl "perl /root/bin/pypi_download_src.pl  *.html  |sh  " > nohup3 & 

sleep 1
nohup perl /root/bin/for_each_dir.pl "perl /root/bin/pypi_download_src.pl  *.html  |sh  " > nohup4 & 
sleep 1

sleep 3000
done
