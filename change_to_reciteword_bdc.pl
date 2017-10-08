#!/usr/bin/perl
#my $file=shift or die("Usgae: $0 input_file \n");
$file="m1.txt";
my $bok=$file.".bok";

get_input_file_word($file, $bok);
#get_one_word("sheep", "aaa.txt");

#
sub get_input_file_word($$)
{
	(my $input, my $output)=@_;
	my $count=0;
	open(FILE, $file) or die("open file $file error \n");
	for(<FILE>)
	{
		my $word=$_;
		chomp($word);
		get_one_word($word, $output);
		$count++;
	}
	close(FILE);
	append_bok_header($output, $count);
}


sub get_one_word($$)
{
	(my $word, my $output)=@_;
	#$word=$_;
	#chomp($word);
	#system("grep -h  \]$word\[ -R fkbdc/ la/ ljjy/ qqssbdc/  wyabdc/ |utf8_to_gb2312.sh    |sort -n   |uniq -c  |sort -n    | tail -n 1  ") ;
	system("grep -h   \]$word -R fkbdc/ la/ ljjy/ qqssbdc/  wyabdc/ |utf8_to_gb2312.sh    |sort -n   |uniq -c  |sort -n    | tail -n 1  >> $output ") ;
}

#==============================
sub append_bok_header()
{
	(my $output)=@_;
	open(FILE, ">> $output") or die("open file $output error \n");
	print FILE  <<EOF
	[H]recitewordbookfile[N]test[C]20[R]bbbbbbb[P]http://www.baidu.com[E]greshem@gmail.com[A]from_xxxxxxx
EOF
;
	close(FILE);
}
