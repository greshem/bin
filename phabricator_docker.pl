
#Run with image from hub.docker.com
#Run a mysql container :

docker run --name databasePhabricator yesnault/docker-phabricator-mysql

#Run phabricator :
docker run -p 8081:80 --link databasePhabricator:database yesnault/docker-phabricator

#Go to http://localhost:8081
