#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__
docker run -p 9200:9200 --name=elasticsearch1 elasticsearch

curl http://localhost:9200

curl -XPOST localhost:9200/mails/message/1 -d '{ "message": "Hello world!" } '

curl -XGET localhost:9200/mails/message/1
