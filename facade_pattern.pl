#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#2011_03_24_21:32:54   星期四   add by greshem
目的 对外部提供一个统一的接口 。 
如 openssl 库 接口 实用BIO 接口 封装了 EVP 接口. 
#2011_03_24_21:41:58   星期四   add by greshem


#==========================================================================
Facade模式定义了一个更高层的接口，使子系统更加容易使用

#==========================================================================
GOF《设计模式》一书对Facade模式是这样描述的: 为子系统中的一组接口提供一个统一接口。

#==========================================================================
boost 的书. 
1. random 变量发生器, 屏蔽了内部 大量细节 给用户 一个可以轻松生成随机数的operator()

