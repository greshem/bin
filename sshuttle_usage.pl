foreach (<DATA>)
{
	print $_;
}
__DATA__
#qb
sshuttle  -r  root@localhost:7764   192.168.177.0/24

#tailong
sshuttle  -r  root@localhost:7771   10.4.0.0/16 

#emoti
git clone ssh://root@greshem.51vip.biz:6787/home/git_linux_src/sshuttle 
sshuttle  -r root@mail.emotibot.com.cn:6787  192.168.1.0/24  


#single ip addr
sshuttle  -r root@mail.emotibot.com.cn:6787 192.168.1.11/32

 sshuttle  -r root@localhost:7767   192.168.1.11/32 
 sshuttle  -r root@localhost:7768   192.168.1.11/32 

#sshuttle 
pip install  --upgrade  --trusted-host  pypi.douban.com  -i http://pypi.douban.com/simple/    sshuttle
mkdir  /root/.pip/
cat    > /root/.pip/pip.conf  <<EOF
[global]
index-url = http://pypi.douban.com/simpl
EOF

#owncloud 
sshuttle  -r  root@192.168.1.5:17764   192.168.166.7/32

sshuttle  -r  root@localhost:7764    192.168.131.75/32
scp  gitlab://home/username/opt/gitlab/data/repositories/*.tar.gz ./

