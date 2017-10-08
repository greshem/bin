#!/usr/bin/python


import  requests;
from BeautifulSoup import BeautifulSoup

def  get_url(url):
    r=requests.get(url);
    soup = BeautifulSoup(r.content)

    for a in soup.findAll('a', href=True):
            if  a['href'].endswith("xz"):
                print "wget  {web_site}/{href}".format(web_site=url, href=a['href'] );

if __name__=="__main__":
    url="http://cloud.centos.org/centos/7/images/";
    get_url(url);

    DATA="""
#output as follow 
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1701.qcow2
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1503.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1503.raw.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1508.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1509.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1510.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1511.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1511.qcow2c.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1601.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1602.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1603.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1604.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1605.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1606.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1607.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1608.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1611.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1612.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-1701.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-20141129_01.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud-20150628_01.qcow2.xz
wget  http://cloud.centos.org/centos/7/images//CentOS-7-x86_64-GenericCloud.qcow2.xz
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1701.qcow2


"""
