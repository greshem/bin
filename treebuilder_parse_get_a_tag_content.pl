#!/usr/bin/perl 
#20100310. 
# 只获取一个页面里面的一个 TAG的内容，处理 "/root/python_handbook/" 里
# <pre>code </pre>  ,是典型用法。 
#没有添加任何的上下文 TAG的判断， 想要的话，可以参考 __DATA__里面的
#上下文  tag 的判断的用法。 
use HTML::TreeBuilder;
use HTML::Element;
use Data::Dumper;
$file=shift or die("Usage file.html tag \n");
$tag=shift or die("Usage file.html tag \n");

my $tree=HTML::TreeBuilder->new();
$tree->parse_file($file) || die $!;
%todo;
$title;
$url;
$tmp;
@tmp2;
foreach my $a ($tree->find_by_tag_name($tag))
#foreach my $a ($tree->find_by_attribute(class=>"project"))
{
	my @children=$a->content_list();
	print "######################################################### \n";
	print  $a->as_text(),"\n";

}
for  (keys %todo)
{
	#print "wget ", $todo{$_},"  -O ",$_,".html\n"
}
#print Dumper(%todo);
#print keys %todo;
#http://97.163wyt.com/
__DATA__

    if( ref $children[3]  and $children[0]->tag eq 'td')# and $children[0]->attr{"class"} eq "project")
	{	
	#print %{$children[0]}->content_list();
	 #@tmp= $children[0]->look_down("a", sub {$_[0]->attr('href')=~/Project/}) ;
	 $tmp= $children[0]->look_down(_tag=>"a");
	 #@tmp= $children[0]->content_list();
	print "DDDDDDDDDD",$tmp->attr('href'),"\n";
	#print $a->as_text(),"\n";
	print $children[0]->as_text(),"\n";
	print $children[1]->as_text(),"\n";
	print $children[2]->as_text(),"\n";
	print $children[3]->as_text(),"\n";
	print $children[4]->as_text(),"\n";
	print $children[5]->as_text(),"\n";
	}
	else
	{
p://97.163wyt.com/List_feizhuliu/
