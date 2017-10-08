
from pymongo import MongoClient

from BeautifulSoup import BeautifulSoup
import urllib2
import re
import os;
import sys;


client = MongoClient("192.168.1.5", 27017);
db = client["oss4aix"];
g_col= db['software'];

def insert_to_mongodb(col,url,html):
    item={};
    item['url']= url;
    item['html']= html;
    col.insert(dict(item));
    

def grabHref(url,localfile):
    global g_col;
    output_file="/tmp/oss4aix_%s.html"%(localfile);
    html=None;
    if os.path.isfile(output_file):
        print "%s exists"%(output_file);
        html=open(output_file).read(); 
    else: 
        print "%s not exists"%(output_file);
        html = urllib2.urlopen(url).read()
        tmp=open(output_file,"a+")
        tmp.write(html)
        tmp.close();
    html = unicode(html,'gb2312','ignore').encode('utf-8','ignore')
    insert_to_mongodb(g_col, url, html);

    content = BeautifulSoup(html).findAll('a')
    for item in content:
           print "%s/%s"%(url,item['href']); 

def main(name):
        if name:
            url="http://www.oss4aix.org/download/RPMS/%s"%(name);
        else:
            url="http://www.oss4aix.org/download/RPMS/"
    
        grabHref(url,name)

if __name__=="__main__":
    if len(sys.argv)>1:
        main(sys.argv[1]);
    else:
        main(None);
        
    
