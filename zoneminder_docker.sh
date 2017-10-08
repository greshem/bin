
docker run -d --name="Zoneminder" --privileged=true -v /tmp/config:/config:rw -v /etc/localtime:/etc/localtime:ro -p 8188:80 aptalca/docker-zoneminder
