#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#2011_03_24_21:41:58   星期四   add by greshem
linux 安全体系分析
把一个类的接口转换成 另一个接口 
	如: TPM 模块的 TDDL层, TSPI 层 提供了接口转接函数. 
#==========================================================================
1.  log4perl 有把java 的接口转换成了 perl 的接口. 


#==========================================================================
proxy 和adapter有一定类似，都是属于一种衔接性质的。

区别是很明显的，从大体上说：proxy是一种原来对象的代表，其它需要与这个对象打交道的操作都是和这个代表交涉，就象歌星的经纪人一样. 
	被虚拟出来的代表者, 的接口不限, 不会变的. 
adapter目的则不是要虚构出一个代表者，而是为应付特定使用目的，将原来的类进行一些修改, 被虚拟出来的接口一定是特定的. 
