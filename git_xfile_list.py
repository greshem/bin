#!/usr/bin/python 
import time;
import datetime;
import string;

# _xfile_2016_04
#month 
d2 = datetime.datetime(2015, 12, 31)  

#print  time.strftime("_xfile_%Y_%m",time.localtime())
print d2
for each in range(0,12):
    mon=string.zfill(each,2);
    print  ("git clone ssh://root@mail.emotibot.com.cn:6787/mnt/dir/svn_git/_xfile_2016_%2s")%(mon);

print "\n########################################################################";
for each in range(0,12):
    mon=string.zfill(each,2);
    print  ("git clone ssh://root@192.168.1.48:2222/mnt/dir/svn_git/_xfile_2016_%2s")%(mon);


