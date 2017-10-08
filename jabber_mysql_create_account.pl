#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
从MySQL控制台创建用户

现在 auto-create 激活了, 你可以从MySQL控制台创建一个用户.

以Jabberd用户登录到MySQL控制台:

        mysql -u jabberd2 -p

从MySQL控制台, 切换到 jabberd2 数据库:

        mysql> use jabberd2

从MySQL控制台, 插入一行到 authreg 表. 这一行应该包含 username , realm 和 password 的值:

        mysql> insert into authreg (username, realm, password)
            -> values ('myusername', 'somedomain.com', 'mypassword');

把 somedomain.com 修改成符合你的配置的值. 大部分情况下, realm将会和Jabber服务器的ID相同. 把 myusername 和 mypassword 修改成你的新用户的名称和密码.

你的新用户现在可以用Jabber客户端登录了. 
########################################################################

