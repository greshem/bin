#!/usr/bin/python
DATA="""


#https://hub.docker.com/r/tim03/rsync-server/
docker pull tim03/rsync-server


#server 
docker  run     -v /tmp3:/data/  -p 873:873   tim03/rsync-server
docker  run     -v /root:/data/  -p 873:873   tim03/rsync-server

#client 
rsync  -avz   rsync://localhost/volume

#==========================================================================
#或者通过ssh 协议 不启动rsync 服务器了
rsync -avH   '-e ssh -p 7764' root@localhost:/root/ /mnt/d/wzcloud_back/


"""
print DATA;
