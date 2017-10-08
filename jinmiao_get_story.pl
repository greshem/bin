#!/usr/bin/perl
#金苗网 get story    原来是  ntfs_link_rename_v5.pl

mkdir ("output");
if( ! -d  "mp3list")
{
	mkdir ("mp3list");
}

#mp3file/02mingzhu/12/xila625mf.mp3','')">第27章26从夜晚到天明</a></div><div class='zhuanjicishu'>75人听过</div></li><li><div class='zhuanjiname'><a href='javascript:void(0)' title='第27章27宴会' onclick="add3('739','12527','第27章27宴会','/
sub deal_with_one_file($$$)
{
	(my $file, my $id, my $name )=@_;
	$output_dir="output\\".$id.".html.".$name;
	if (! -d $output_dir)
		{mkdir($output_dir) ;}
	
	open(FILE, $file) or die("open file $file error \n");
	for(<FILE>)
	{
		
		if($_=~/(mp3file.*\.mp3).*\>(.*)\<\/a.*/)
		{
			my $from=$1;
			my $to=$2;
			$to=~s/ /_/g;
			$from=~s/\//\\\\/g;
			$to=~s/\//\\\\/g;
			# 
			#print "copy  J:\\sdb1\\_xfile\\2014_all_iso\\_xfile_2014_05\\_misc\\金苗网\\jingmiao\\huiben\\www.jinmiao.cn\\$from $output_dir\\$to.mp3\n";
			if(0)
			{
				print "mklink  $output_dir\\$to.mp3  J:\\sdb1\\_xfile\\2014_all_iso\\_xfile_2014_06\\金苗网\\jingmiao\\huiben\\www.jinmiao.cn\\$from \n";
				system("mklink  $output_dir\\$to.mp3  J:\\sdb1\\_xfile\\2014_all_iso\\_xfile_2014_06\\金苗网\\jingmiao\\huiben\\www.jinmiao.cn\\$from ");
			}
			else
			{
				print "cp  J:\\sdb1\\_xfile\\2014_all_iso\\_xfile_2014_06\\金苗网\\jingmiao\\huiben\\www.jinmiao.cn\\$from   $output_dir\\$to.mp3   \n";
				system("cp  J:\\sdb1\\_xfile\\2014_all_iso\\_xfile_2014_06\\金苗网\\jingmiao\\huiben\\www.jinmiao.cn\\$from   $output_dir\\$to.mp3   ");
			}
			#print "#mv $to.mp3 $from \n";
		}
	}
}
#for (glob("*.html"))
#{
#	deal_with_one_file($_);
#}
#deal_with_one_file("huiben.mp3_url.list");
#my $input_file=shift or die("Usage: $0 input_file.txt \n");
#my $input_file="todo_听/1207.html_汤姆叔叔的小屋.txt";

my  @files= glob("mp3list/*.txt");
print join("\n", @files)."\n";
if(scalar(@files) == 0)
{
	warn("#mp3list 没有故事 , 请 自己添加故事\n");
	die("从 这里 拷贝 txt  J:\\sdb1\\_xfile\\2014_all_iso\\_xfile_2014_06\\金苗网\\7_故事_分类  \n");

}
for (glob("mp3list/*.txt"))
{
	#chomp;
	print $_."\n";;
	my $input_file=$_;
	(my $id, my $name)= ($input_file=~/mp3list\/(\d+).*\.html_(.*)\.txt/);
	#mkdir("output/${id}___$name");
	print "|$input_file|\n";
	deal_with_one_file($input_file, $id, $name);
}
