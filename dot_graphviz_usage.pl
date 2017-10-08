#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#DOT 语言的开头：
#graph: [strict] (graph | digraph) [ID] '{' stmt_list '}'
#graph代表无向图，digraph代表有向图，对于Chuan来说，一般就着重于digraph了。
#dot 输出图像的命令：
dot -T(fileformat) filename.dot -o output.(format)

#比如：
dot -Tps input.dot -o output.ps
#此命令即将dot文件保存成为一个ps图像，值得注意的是layout是自动的——即使在dot文件中没有包含位点信息，dot工具依旧可以很好的处理图像布局（不知道他使用的是哪一种布局？） 

#codeviz 里面的一种用法
dot -Tjpg call.dot -o Addr2line.jpg

########################
#Graphviz提供了几种常用的layout算法实现工具, 如何指定呢? 

#==========================================================================
# rpm 关系图依赖.
repo-graph > repo-graph.dot
dot -Tjpg  repo-graph.log  -o repo-graph.jpg 

