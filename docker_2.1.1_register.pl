# 文档 参考
#  "/root/_pre_cache_greshem/_pre_cache_2016_10/docker_2.2.1.txt"

docker pull registry:2.1.1
docker run -d -v /opt/registry:/var/lib/registry -p 5001:5000 --restart=always --name registry registry:2.1.1

#
docker ps 


docker images

#用本地的 dnsmasq 的镜像.
#docker pull  docker.io/andyshinn/dnsmasq 
#docker.io/andyshinn/dnsmasq                      2.75                e46e9aa1224b        9 months ago        5.116 MB


#docker tag hello-world 127.0.0.1:5001/hello-world
#标记 本地的 一个 镜像 为远程的一个镜像.
docker tag docker.io/andyshinn/dnsmasq:2.75  127.0.0.1:5001/docker.io/andyshinn/dnsmasq
docker push 127.0.0.1:5001/docker.io/andyshinn/dnsmasq

curl http://127.0.0.1:5001/v2/_catalog 


#现在我们可以先将我们本地的127.0.0.1:5001/hello-world和hello-world先删除掉，
#docker rmi hello-world
#docker rmi 127.0.0.1:5001/hello-world
#delete local 
docker   rmi  docker.io/andyshinn/dnsmasq 
docker   rmi  127.0.0.1:5001/docker.io/andyshinn/dnsmasq


#get from my  register server 
docker pull 127.0.0.1:5001/docker.io/andyshinn/dnsmasq
docker tag  127.0.0.1:5001/docker.io/andyshinn/dnsmasq  greshem_dnsmasq

