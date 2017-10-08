#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__


docker pull sameersbn/gitlab:7.11.2
docker pull sameersbn/postgresql:9.4
docker pull sameersbn/redis:latest


docker run --name=postgresql -d \
-e 'DB_NAME=gitlabhq_production' -e 'DB_USER=gitlab' -e 'DB_PASS=password' \
-v /home/username/opt/postgresql/data:/var/lib/postgresql \
sameersbn/postgresql:9.4


docker run --name=redis -d sameersbn/redis:latest

docker run --name='gitlab' -d \
--link redis:redisio \
-v /home/username/opt/gitlab/data:/home/git/data \
-v /var/log/supervisor/:/var/log/supervisor/\
    -v /var/log/nginx/:/var/log/nginx/\
-p 10022:22 -p 10080:80 \
-e 'GITLAB_PORT=10080' \
-e 'GITLAB_SSH_PORT=10022' \
--link postgresql:postgresql \
-e 'GITLAB_EMAIL=greshem@qq.com' \
-e 'GITLAB_BACKUPS=daily' \
-e 'GITLAB_HOST=gitlab' \
-e 'GITLAB_SIGNUP=true' \
-e 'GITLAB_GRAVATAR_ENABLED=false' \
sameersbn/gitlab:7.11.2

#==========================================================================
#密码
#user:  root
#pass:   5iveL!fe
5iveL!fe 
#==========================================================================
ls /home/username/opt/gitlab/data/backups 
