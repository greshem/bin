#!/usr/bin/perl

mkdir("/root/.getmail/");

open(CONF, ">/root/.getmail/emotibot.conf")  or die("open getmai/emotibot.conf error \n");

print   CONF <<EOF
[options]
verbose = 1
delete = false
message_log = /tmp/getmail.log

[retriever]
type = SimplePOP3Retriever
server = mail.emotibot.com.cn
username = greshem
password = q*********************n

[destination]
type = Maildir
path = /tmp/mail_dir/
path_commit= path  must be absolute  
EOF
;
close(CONF);

print "OK: /root/.getmail/emotibot.conf \n";
print "yum install getmail  \n";
print "pip install getmail  \n";
print "\n getmail -r /root/.getmail/emotibot.conf \n";

mkdir("/tmp/mail_dir/");
mkdir("/tmp/mail_dir/cur/");
mkdir("/tmp/mail_dir/new/");
mkdir("/tmp/mail_dir/tmp/");
print "generated:  /root/.getmail/emotibot.conf OK \n";
