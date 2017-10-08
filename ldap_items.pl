#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__
    
LDAP是一种通讯协议，如同HTTP是一种协议一样的！ 
在 LDAP 目录中，
·         DC (Domain Component)
·         CN (Common Name)
·         OU (Organizational Unit)


LDAP 目录类似于文件系统目录。 
下列目录： 
DC=redmond,DC=wa,DC=microsoft,DC=com       

如果我们类比文件系统的话，可被看作如下文件路径:    
    Com\Microsoft\Wa\Redmond   

例如：CN=test,OU=developer,DC=domainname,DC=com 
在上面的代码中 cn=test 可能代表一个用户名，ou=developer 代表一个 active directory 中的组织单位。这句话的含义可能就是说明 test 这个对象处在domainname.com 域的 developer 组织单元中。

