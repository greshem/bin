#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#2011_03_24_21:41:58   星期四   add by greshem
tomcat 源码分析. 
Chain of responsibility（责任链）
作为一个基于请求响应模式的服务器，在Tomcat3.3中采用一种链状处理的控制模式。请求在链上的各个环节上传递，在任一环节上可以存在若干个"监听器"处理它。这样做的目的是避免请求的发送者和接受者之间的直接耦合，从而可以为其他的对象提供了参与处理请求的机会。采用这个方式不但可以通过 "监听器"实现系统功能，而且可以通过添加新的"监听器"对象实现系统功能的扩展
########################################################################

#==========================================================================
boost 库 完全开发指南
1. boost 的 assign 库的工作原理 类似 责任链模式 但是链上 仅有一个对象， 他实用重载操作符 operator () operator , 讲 赋值请求 逐个处理， 完成最后的赋值 或者 初始化工工作
2. iostreams 库 也使用了 责任链 责任链 责任链 他定义了 source sink filter 的概念 对象之前可以串联起来 一个输出可以作为另一个的输入, 完成流处理的功能, 
	那么 LINUX 的管道是不是可以算成是责任链模式呢？

