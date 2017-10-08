#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#2011_03_24_21:41:58   星期四   add by greshem

Builder模式定义:
将一个复杂对象的构建与它的表示分离,使得同样的构建过程可以创建不同的表示.

Builder模式是一步一步创建一个复杂的对象,它允许用户可以只通过指定复杂对象的类型和内容就可以构建它们.用户不知道内部的具体构建细节.Builder模式是非常类似抽象工厂模式,细微的区别大概只有在反复使用中才能体会到.

为何使用?
是为了将构建复杂对象的过程和它的部件解耦.注意: 是解耦过程和部件.

因为一个复杂的对象,不但有很多大量组成部分,如汽车,有很多部件:车轮 方向盘 发动机还有各种小零件等等,部件很多,但远不止这些,如何将这些部件装配成一辆汽车,这个装配过程也很复杂(需要很好的组装技术),Builder模式就是为了将部件和组装过程分开.

如何使用?
首先假设一个复杂对象是由多个部件组成的,Builder模式是把复杂对象的创建和部件的创建分别开来,分别用Builder类和Director类来表示.

########################################################################
简单地说，就好象我要一座房子住，可是我不知道怎么盖（简单的砌墙，层次较低），也不知道怎么样设计（建几个房间，几个门好看，层次较高）， 于是我需要找一帮民工，他们会砌墙，还得找个设计师，他知道怎么设计，我还要确保民工听设计师的领导，而设计师本身也不干活，光是下命令，这里砌一堵墙，这里砌一扇门，这样民工开始建设，最后，我可以向民工要房子了。在这个过程中，设计师是什么也没有，除了他在脑子里的设计和命令，所以要房子也是跟民工要，记住了！

就象国内好多企业上erp一样，上erp，首先得找软件公司呀，找到软件公司后，软件公司说，我只知道怎么写软件，就知道怎么实现，不清楚整个erp的流程。好，那我们还得找一个咨询公司，好，找到德勤了，德勤说好，我要软件怎么做，软件公司怎么做，我就能保证软件能为你们提供erp系统了。

此模式是为了让设计和施工解耦，互不干扰。
########################################################################
1. 再如 我和jl, 我把接口接口写好之后, jl开始填充, 里面的东西了 ， 把我的设计 和jl 的使用解耦了. 

所以这里不变的量是 builerPartA, builderPartB,  假如 builder  的过程 经常再变, 不打适合 builder 模式了. 
