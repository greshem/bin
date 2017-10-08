#!/usr/bin/perl 
do("/root/bin/system_exec_or_die.pl");


mkdir("/var/repo/");
gen_git_web_dav_conf();
my_system("htpasswd -b   -c /etc/httpd/conf.d/git.passwd  test  test   ");
my_system("htpasswd -b    /etc/httpd/conf.d/git.passwd  root root  ");
my_system("setenforce 0");
my_system("iptables -F  ");

print <<EOF

yum -y  install php-mysql
yum -y  install mod_dav_svn 
yum -y  install mod_dav
yum -y  install git\*

#vim  /etc/httpd/conf/httpd.conf 
Listen 80
Listen 8080
Listen 8081


git clone https://github.com/openstack/nova/  /var/repo/nova/
git clone git://git.openstack.org/openstack/nova  /var/repo/nova/

git clone http://192.168.1.11:8080/nova    /var/repo/nova/


#本地的 httpd  git  server 开始 生效, 测试一下 
service httpd restart
git clone http://localhost:8080/nova    /tmp/nova/


EOF
;

####################################################
sub  gen_git_web_dav_conf()
{
	open(FILE, ">/etc/httpd/conf.d/git_web_http.conf") or die("open  http git_web_http.conf error ");
	print FILE <<EOF
<VirtualHost *:8080>

ServerName xxx.xxx.xxx

DocumentRoot   /var/repo/
#git目录
	SetEnv GIT_PROJECT_ROOT /var/repo/       
	SetEnv GIT_HTTP_EXPORT_ALL
#将/上的请求转发给git
	ScriptAlias / /usr/libexec/git-core/git-http-backend/ 

    <Location "/">
	DAV on           
	#开启dav扩展
	Order allow,deny
	Allow from all
#开启密码验证
	AuthType Basic   
	AuthName "Git"
	AuthUserFile /etc/httpd/conf.d/git.passwd
	Require valid-user
    </Location>
</VirtualHost>
EOF
;
	close(FILE);
}
