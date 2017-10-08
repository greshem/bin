import requests;
#from bs4 import BeautifulSoup
from  BeautifulSoup  import BeautifulSoup
import re;

def get_links():
    base="http://mirrors.aliyun.com/ceph/tarballs/"
    r=requests.get(base)

    s = BeautifulSoup(r.content)
    r = re.compile(r'[.*tar.bz2$|*.tar.gz$]')
    for a in s.findAll('a', href=r):
        if a['href'].endswith("tar.gz") or  a['href'].endswith("tar.bz2"):
            print("%s/%s"%( base, a['href']));

get_links();
