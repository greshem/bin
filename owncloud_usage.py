#!/usr/bin/python
DATA="""
#server 
docker run -d -p 80:80  -v /owncloud:/var/www/html owncloud:9.1.3 
docker run -d -p 44444:80    -v //mnt/d/owncloud:/var/www/html owncloud:9.1.3
docker run -d -p 33333:80    -v //mnt/d/owncloud:/var/www/html owncloud:9.1.3
docker run --restart=yes  -d -p 33333:80    -v //mnt/d/owncloud2:/var/www/html owncloud:9.1.3
docker run   -d -p 33333:80    -v //mnt/d/owncloud2:/var/www/html owncloud:9.1.3

#client
owncloudcmd -u admin -p password /root/owncloud_sync/  http://192.168.166.7:8077/


#upload   上传 
#pip install ownSync.py  
 ownSync.py  --url  http://192.168.166.7:8077/ --user  admin --local  /root/bin/

"""
print DATA;
