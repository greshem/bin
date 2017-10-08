#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#DOT ���ԵĿ�ͷ��
#graph: [strict] (graph | digraph) [ID] '{' stmt_list '}'
#graph��������ͼ��digraph��������ͼ������Chuan��˵��һ���������digraph�ˡ�
#dot ���ͼ������
dot -T(fileformat) filename.dot -o output.(format)

#���磺
dot -Tps input.dot -o output.ps
#�������dot�ļ������Ϊһ��psͼ��ֵ��ע�����layout���Զ��ġ�����ʹ��dot�ļ���û�а���λ����Ϣ��dot�������ɿ��ԺܺõĴ���ͼ�񲼾֣���֪����ʹ�õ�����һ�ֲ��֣��� 

#codeviz �����һ���÷�
dot -Tjpg call.dot -o Addr2line.jpg

########################
#Graphviz�ṩ�˼��ֳ��õ�layout�㷨ʵ�ֹ���, ���ָ����? 

#==========================================================================
# rpm ��ϵͼ����.
repo-graph > repo-graph.dot
dot -Tjpg  repo-graph.log  -o repo-graph.jpg 

