
# 杀死所有正在运行的容器.
# alias dockerkill='docker kill $(docker ps -a -q)'

# # 删除所有已经停止的容器.
# alias dockercleanc='docker rm $(docker ps -a -q)'

# # 删除所有未打标签的镜像.
# alias dockercleani='docker rmi $(docker images -q -f dangling=true)'

# # 删除所有已经停止的容器和未打标签的镜像.
# alias dockerclean='dockercleanc || true && dockercleani'
#
#
docker rmi $(docker images -q -f dangling=true)
docker rm $(docker ps -a -q)
#!/bin/bash
# Ref: http://blog.yohanliyanage.com/2015/05/docker-clean-up-after-yourself/
set +x

echo "(1/4) Delete images that are not running and size > 1GB"
docker rmi $(docker images | grep GB | awk '{print $3}')

echo "(2/4) Make sure that exited containers are deleted."
docker rm -v $(docker ps -a -q -f status=exited)

echo "(3/4) Remove unwanted ‘dangling’ images."
docker rmi $(docker images -f "dangling=true" -q)

echo "(4/4) Clean unused volumes"
docker run -v /var/run/docker.sock:/var/run/docker.sock \
	-v /var/lib/docker:/var/lib/docker \
	--rm martin/docker-cleanup-volumes
