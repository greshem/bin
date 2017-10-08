#!/usre/bin/python
import glob
import os;
#A  /etc/yum.repos.d/CentOS-Base.repo
for file in glob.glob("/etc/yum.repos.d/*.repo"):
	if os.path.isfile(file):
		print "#File:   {0}".format(file);
		print 'sed  -i  "s/mirror.centos.org/mirrors.aliyun.com/g"  %s'                 %file;
		print 'sed  -i  "s/download.fedoraproject.org\\/pub/mirrors.aliyun.com/g"  %s'  %file;
        print 'sed  -i  "s/^mirrorlist/#mirrotlist/g"  %s ' %file;
        print 'sed  -i  "s/^#baseurl/baseurl/g"  %s '       %file;
