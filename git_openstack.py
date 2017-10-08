#!/usr/bin/python 
import os;
import glob;

for each in glob.glob("/mnt/dir/git/*"):
    if os.path.isdir(each):
        print("git co ssh://root@192.168.1.48:2222%s"%(each));
        #print("git co ssh://root@mail.emotibot.com.cn:6787%s"%(each));


for each in glob.glob("/mnt/dir/repo/*"):
    if os.path.isdir(each):
        print("git co ssh://root@mail.emotibot.com.cn:6787%s"%(each));
