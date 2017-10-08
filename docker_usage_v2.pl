
docker pull  fedora
docker pull  centos
docker pull  ubuntu

docker run -i -t fedora  /bin/bash

#server 
docker daemon 


#迁移:
docker export       befa4bab3a07 > /tmp/bbb.tar 
docker import    http://localhost/bbb.tar    ubuntu_wget  new_version 


