#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#2012_01_17_15:59:48   星期二   add by greshem
1. cpan Net-Jabber-2.0-tar.gz/examples/client.pl
有对应的perl 的客户端的实现. 可以通过这个客户端 进行调试.
2. /etc/jabberd/s2s.xml 里面的log 本来是 syslog 可以把他修改成 file 
	然后在 对应的俄 /var/lib/jabberd/log/ 就可以 有对应的日志便于调试检查.



#2012_01_16_21:44:17   星期一   add by greshem
1.f16 上jabber 默认是 mysqlist 的 sqlite 里面  有默认的 .read 的命令 用来执行 数据库的初始化.
2. http://wiki.jabbercn.org  有更加详细的介绍
3. gajim 本地登录的话 就可以有对应的帐号. 可以专门用 gajim  测试.
4.  freetalk 也可以用来做测试 是命令行的

########################################################################
c2s.xml 文件配置Jabberd的 客户端-服务器 组件. c2s 组件负责和Jabberd客户端之间的通讯, c2s.xml 主要和客户端通讯相关: 

    PID文件
    和Router通讯
    日志
    网络配置
    输入输出控制
    客户端验证和注册 

########################################################################
s2s.xml 文件配置Jabberd 2的 服务器-服务器 组件. s2s.xml 文件为本组件和 router 组件通讯提供网络设置: 

    PID文件
    和Router通讯
    日志
    网络配置
    S2S连接检查 
########################################################################
sm.xml 文件配置Jabberd 2的 session manager 组件. session manager 在router和外部可用的组件 (s2s 和 c2s) 之间扮演一个层的角色. sm.xml 文件配置以下功能: 
    Jabberd身份
    和Router通讯
    日志
    数据库连接和配置
    管理功能的访问控制
    会话调用的模块
    外部组件的静态浏览设置
    用户选项 
########################################################################
router.xml 文件提供 router 组件的配置, 它是Jabberd服务器的中枢. router组件接受从其他组件的连接, 然后在它们之间传递XML包. router.xml 文件包含了以下主要章节:

    ID,PID和日志
    网络
    输入输出控制
    别名
    功能访问控制 
########################################################################
Router-users.xml配置

router-users.xml 文件的唯一的用途是提供一个用户和密码对的列表给 router 来验证. 缺省的用户( jabberd ) 是给其他Jabberd组件 ( sm , resolver , s2s 和 c2s ) 连接验证用的. 

