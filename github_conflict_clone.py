#coding=utf-8
# 1. 先用 github_search.pl   生成    /tmp/datasets.log 
# 2.  vim  把   url 转换成 对应的项目  
#!/usr/bin/python 

import sys, os
def chomp(line):
    if line[-1] == '\n':
        line = line[:-1]
    return line;


name=None;
if len(sys.argv)==2:
    name=sys.argv[1];
else:
    name="/tmp/datasets.log";
print(name);



fh=open(name);
for line in fh.readlines():
        tmp=chomp(line).split('/');
        if "201" in tmp[0]:
            #print tmp;
            add= tmp[-2]+"/"+tmp[-1]
            add_to=tmp[-2]+"_"+tmp[-1]
            print "git clone http://www.github.com/%s %s"%( add, add_to  );
        else:
            if len(tmp)==5:
                print "git clone %s %s"%( chomp(line),  tmp[3]+"_"+tmp[4]);
            #https://api.github.com/repos/summitech/yanni
            elif len(tmp)==6:
                print "git clone http://www.github.com/%s/%s   %s_%s"%( tmp[4], tmp[5], tmp[4],tmp[5])
            else:
                print "len=%s"%len(tmp);

print "#python  github_conflict_clone.py  > tmp.sh ";
print "#cat tmp.sh  |parallel ";

