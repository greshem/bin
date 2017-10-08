#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#服务器
#修改 dhcpd.conf 文件, 添加下面的行
#in server side 

key defomapi {
        algorithm hmac-md5;
        secret +bFQtBCta6j2vWkjPkNFtgA==;
};

omapi-key defomapi;
omapi-port 7911;

########################################################################
#重启服务器; 
#on client side . 

omshell 
key  defomapi +bFQtBCta6j2vWkjPkNFtgA==
connect
new host
set name="WKS001


