
#for each in $(find -type d   |sed 's/\.\///g' )
#do
#echo "KEYWORD: |$each| "

#deal_with_dir();
deal_with_file();


sub deal_with_file()
{
	#for $each (glob("*_Դ��_����_todo.txt"))
	for $each (glob("*.txt"))
	{
		@array=split(/_/, $each);	
		$new_keyword=$array[0];		
		check_one($new_keyword, $each );
	}
}

sub deal_with_dir()
{
	for $each (grep  {-d } glob("*"))
	{
		if(!  -f "${each}_Դ��_����_todo.txt")
		{
		check_one($each, $each);
		}
	}
}

sub check_one()
{
	(my $keyword, my $path)=@_;
	open(PIPE, "perl /root/bin/source_code_analyse_exists.pl  $keyword  |")  ;

	for(<PIPE>)
	{
		print $_;
		if($_=~/�ؼ��� ����/)
		{
			print " $keyword  �ؼ��� ����\n";

			mkdir("/tmp/OKK");
			system(" mv $path /tmp/OKK/");
			return 1;
		}
	}

	return undef;
}

#done 
