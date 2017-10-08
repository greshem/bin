#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__


#1. 获取redis、postgres、sentry。sentry对redis和postgres的版本有要求，不能使用太低版本的。

docker pull redis
docker pull postgres
docker pull sentry

#2.启动redis和postgres。
docker run -d --name sentry-redis redis
#docker run -d --name sentry-postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=sentry postgres
docker run -d --name sentry-postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=postgres postgres   #新的版本发生的变化:   USER 变化:
docker run --rm sentry config generate-secret-key
#上一行得到secret-key，然后把key复制到下面四行的单引号中。


#3. 启动sentry。
key='wm0$5o6l4#tv!csx@#kfxk8k@$c&sdof4b6^i46wqozss5ce3)'
docker run -it --rm -e SENTRY_SECRET_KEY=$key                           --link sentry-postgres:postgres --link sentry-redis:redis sentry upgrade
docker run -d -p 9000:9000 --name my-sentry -e SENTRY_SECRET_KEY=$key   --link sentry-redis:redis --link sentry-postgres:postgres sentry
docker run -d --name sentry-cron -e SENTRY_SECRET_KEY=$key              --link sentry-postgres:postgres --link sentry-redis:redis sentry run cron
docker run -d --name sentry-worker-1 -e SENTRY_SECRET_KEY=$key          --link sentry-postgres:postgres --link sentry-redis:redis sentry run worker

#完成后，在浏览器中输入http://192.168.99.100:9000 即可访问。
