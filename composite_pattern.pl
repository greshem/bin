#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#2011_03_24_21:41:58   星期四   add by greshem

boost 库 完全开发指南
	命令经常和 责任链 组合模式一起实用:
		责任链模式处理命令模式封装的对象, 组合模式可以把简单的命令对象组合成复杂的命令对象.
	1. 命令模式 同样能够 把请求的发送者 和 接受者 解耦. 

	和 解释器模式很像 常常利用 解释器模式 实现语法树的构架. 

