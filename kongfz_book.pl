#!/usr/bin/perl

sub download_all()
{
	for $each  ((1..10))
	{
		if(! -f "p$each.html")
		{
		system(" wget http://book.kongfz.com/28104/p$each/ -O p$each.html  ");
		system(" /root//bin/utf8_to_gb2312.sh   p$each.html   > p$each.html.gb2312 ");
		}
	}
	#system("  egrep  'result_tit|grid_3 txt_right m_r10'  *gb2312 ");
}

sub get_newest_day()
{
	if(! -f "p1.html")
	{
		system(" wget http://book.kongfz.com/28104/p1/ -O p1.html  ");

		system(" /root//bin/utf8_to_gb2312.sh   p1.html   > p1.html.gb2312 ");
	}

	my %hash;
	open(PIPE, "  grep  \'grid_3 txt_right m_r10\'  p1.html.gb2312|") or die("open p1.html error \n");
	for(<PIPE>)
	{
		if($_=~/(\d\d\d\d-\d\d-\d\d)/)
		{
			$hash{$1}=1;
		}
	}

	my @tmp= keys(%hash);
	return @tmp;
}

sub get_book_name_time($)
{
	(my $input_file)=@_;

	if(! -f $input_file)
	{
		download_all();
	}
	my $name;
	my $time;
	my %hash;
	open(FILE,  $input_file) or die("open $input_file error \n");
	for(<FILE>)
	{
		if($_=~/result_tit.*_blank">(.*)<\/a.*/)
		{
			#print $1."|";;
			$name=$1;	
		}
		elsif($_=~/grid_3 txt_right m_r10">(....-..-..)</)
		{
			#print  $1."\n";
			$time=$1;
			$hash{$name}=$time;
		}
	}
	close(FILE);
	return %hash;
}

#@array=get_newest_day();
#print join("\n", @array);

my @tmp=get_newest_day();
my $time=$tmp[0];
print "Time: $time \n";

for(1..10)
{
	my $number=$_;
	my %hash=get_book_name_time("p$number.html.gb2312");
	my $Key;
	for $key (keys(%hash))
	{
		if($hash{$key}=~/$time/)
		{
			print  "FFFF".$key." =>  ".$hash{$key}."\n";
		}
		else
		{
			#print  "FFFF".$key." =>  ".$hash{$key}."\n";
		}
	}
}

