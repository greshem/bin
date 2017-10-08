#coding:gbk
#Zipping a file:
#

import os;
import sys;
import zipfile
import time;
import glob;
import time;

def gen_file_name_with_time_dir(destdir, prefix, suffix):
    i=1;
    cur_time=time.strftime("%Y_%m_%d",time.localtime())
    while i:
        filename="%s_%s_%d.%s"%(prefix,cur_time,i,suffix);
        i=i+1;
        abs_path=("%s/%s")%(destdir, filename);
        if not os.path.isfile(abs_path):
            return abs_path;

def gen_file_name_with_time(prefix, suffix):
    i=1;
    cur_time=time.strftime("%Y_%m_%d",time.localtime())
    while i:
        filename="%s_%s_%d.%s"%(prefix,cur_time,i,suffix);
        i=i+1;
        if not os.path.isfile(filename):
            return filename;


			
def getTimeStamp():
    """
    Method to get a timestamp to be used in
    the log message.
    Args:
      None

    Returns: [STRING] The timestamp
    """

    #return time.strftime("%m.%d.%y %H:%M:%S ",time.localtime())
    return time.strftime("%Y-%m-%d",time.localtime())


########################################################################
#��ǰĿ¼�µݹ����е��ļ� mtime < 1
def get_dir_list(path):
	filelist=[];
	cur=time.time();
	for root, dirs, files in os.walk(path):
		for file in files:
			abs_path = os.path.join(root,file)
			#print "%s" %abs_path;
			mtime = os .path.getmtime(abs_path) ;
			#if (cur-mtime) < 24*60*60*7 and  abs_path.endswith("txt"): #һ�ܵ��ĵ�. .ini  .cfg �ĵ�  .pl .py  ���е��ı��ĵ�.
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("txt"): #һ����ĵ�. .ini  .cfg �ĵ�  .pl .py  ���е��ı��ĵ�.
				filelist.append(abs_path);
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("pl"): 
				filelist.append(abs_path);
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("py"): 
				filelist.append(abs_path);
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("cfg"): 
				filelist.append(abs_path);
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("sh"): 
				filelist.append(abs_path);
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("bat"): 
				filelist.append(abs_path);
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("sgf"): 
				filelist.append(abs_path);
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("sql"): 
				filelist.append(abs_path);
			if (cur-mtime) < 24*60*60*1 and  abs_path.endswith("php"): 
				filelist.append(abs_path);
	return filelist;

########################################################################
#�����ǵ�ǰĿ¼�µ��ļ�. 
def glob_cur_dir():	
	list=[];
	for file in glob.glob("*"):
	#if os.path.isdir(file):
		if os.path.isfile(file):
        	#print(file)
			list.append(file);
	return list;


list=get_dir_list(".");
#list=glob_cur_dir();

if sys.platform =='win32':
	#output="c:/%s.zip"%getTimeStamp();
        if not os.path.isdir("c:/_pre_cache_bak"):
            os.mkdir("c:/_pre_cache_bak");
	output=gen_file_name_with_time_dir("c:/_pre_cache_bak", "pre_cache_back", "zip");
else:
	#output="/%s.zip"%getTimeStamp();
	output=gen_file_name_with_time_dir("/tmp3/", "back", "zip");

f = zipfile.ZipFile(output,'w',zipfile.ZIP_DEFLATED)
for file in list:
	print file;
	f.write(file)
	
f.close()

#Replace 'w' with 'a' to add files to the zip archive.

#Unzipping all files from a zip archive:
#import zipfile
#zfile = zipfile.ZipFile('archive.zip','r')
#for filename in zfile.namelist():
#    data = zfile.read(filename)
#    file = open(filename, 'w+b')
#    file.write(data)
#    file.close()
