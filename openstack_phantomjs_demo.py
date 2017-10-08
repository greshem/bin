import os
from selenium import webdriver
import time

if not   os.path.isfile("/tmp3/linux_src/phantomjs-2.1.1-linux-x86_64/bin/phantomjs"):
    print """
# phantomjs not exists,  do as flow 
wget http://npm.taobao.org/mirrors/phantomjs/phantomjs-2.1.1-linux-x86_64.tar.bz2 -O /tmp3/linux_src/
PATH=$PATH:/tmp3/linux_src/phantomjs-2.1.1-linux-x86_64/bin

""";

dr = webdriver.PhantomJS('phantomjs')
SERVER_URL='http://192.168.82.173:3333'
dr.get(SERVER_URL+'/auth/login')


form = dr.find_element_by_id("login-form")
if form:
    elem = dr.find_element_by_id("id_username")
    elem.clear()
    elem.send_keys("admin")
    elem = dr.find_element_by_id("id_password")
    elem.clear()
    elem.send_keys("admin")
    form = dr.find_element_by_id("login-form")
    form.submit();

time.sleep(4);

#api list 
dr.get(SERVER_URL+'/api/ImageList')
print dr.page_source;
dr.quit()
