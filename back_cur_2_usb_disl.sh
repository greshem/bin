#/bin/bash
for each in $(for_each_dir.pl |grep -v /mnt  ); 
do 
echo echo $each ; 
echo tar -cvf /mnt/sdb2/${each}.tar.gz  $each; done  
> back.sh 
