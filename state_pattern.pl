#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#2011_03_31_19:12:15   星期四   add by greshem
1. 把 class state {
	int state;
	public:
		getState();
		setState();
	};
然后让每个类继承 state， 初步的模型是这个样子 具体 这些类 如何发生关系以减少耦合 确实值得看看的. 
#==========================================================================
boost 库 完全开发指南
boost.statechat实现了 有限状态机, 他是 状态模式的泛化. 


