#!/usr/bin/perl
use GD;
use GD::Graph;
use GD::Graph::pie;
use Encode;

#2011_07_29_17:08:41   ������   add by greshem
#ʹ��֮ǰ ע��һ��, ����ļ���Ҫת����utf8, ��Ϊtruetype Ҫ����utf8 �� ����. 
#�����ļ��� /bin/simsun ���� �� /tmp2/root_backup20100206/gd_perl_php/simsun �ҵ�.

print "Content-type: image/png\n\n";
# create a new pie
my $pie = new GD::Graph::pie(800,600);
# data
@data = (
  ["��һ(10%)","�ڶ�(33%)","����","����","����","����","����","�ڰ�","�ھ�","��ʮ"],
  [ 160,350,100,300,300,300,300,300,343,123],
);
$data1 = GD::Graph::Data->new(\@data);
#       dclrs=>;[qw(green pink yellow white blue red cyan purple orange gray)],
$pie->set(
   dclrs=>[qw(#22FF44 #24A3F1 #FF0000 #FFFF00 #FF00FF #00FF00 #0000FF #00FFFF #FD0931 #FFFFFF)],
   pie_height =>60,
   show_values=>1,
   borderclrs =>"black",
   title=>"������",
   label=>"�ǲ����ö�",
);
$pie->set_label_font("/bin/simsun",10);
$pie->set_value_font("/bin/simsun",10);
$pie->set_title_font("/bin/simsun",10);
#$pie->plot(\@data);


# make sure we are writing to a binary stream
binmode STDOUT;

# Draw the pie, Convert the image to GIF and print it on standard output
#���.
open(FILE,">out.png");
print FILE $pie->plot($data1)->png;
close FILE;
