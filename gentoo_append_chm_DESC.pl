#!/usr/bin/perl
# txt2/4Suite_源码_分析_todo.txt 

#get_first_keyword("aaa_bbb");
#have_sub_package("virt");
#exit(0);

#search_in_everything("txt2/ceph_libs_源码_分析_todo.txt");


for $each (glob("*分析_todo.txt"))
{

	#search_in_everything("$each");


	$keyword=$each;
	$keyword=~s/^txt2\///g;
	$keyword=~s/_源码_分析_todo.txt$//g; 
	$keyword2=$keyword;
	$keyword2=~s/_/\.\*/g;

	#append with  gentoo fedora 
	#print "grep $keyword \*.txt |grep chm\n  " 	;
	#system(" grep -h $keyword *.txt |grep chm  >>  $each ");
	#$keyword=~s/_/-/g;
	#system(" grep -h $keyword *.txt |grep chm  >>  $each ");

	print ("#Deal with $keyword  $keyword2\n");

	append_chm_path($each, $keyword2);
	append_summary_with_eix($each, $keyword2);
	append_summary_with_yum($each, $keyword2);

	#append_from_block_from_file($each, $keyword2);
	#append_from_block_from_file($each, $keyword2);
}

#==========================================================================
sub append_from_block_from_file($$)
{
	(my $filename, my $keyword)=@_;

	#print ("perl /bin/grep_block_section.pl  /tmp/apache_子项目_简介_列表_.txt  $keyword   >> $filename \n");
	print ("perl /bin/grep_block_section.pl  /root/apache_子项目_.txt   $keyword   >> $filename \n");
}


sub append_tarball_path($$)
{
	(my $filename, my $keyword)=@_;
	system(" grep -R -h  $keyword  /root/source_analyse_chm/eden_cache/  |grep tar  >>  $filename \n");

	#print(" grep -R -h  $keyword   eden_cache/  |grep chm  >>  $each ");
	#print(" grep -R -h  $keyword2  eden_cache/  |grep chm  >>  $each \n");
}

sub append_chm_path($$)
{
	(my $filename, my $keyword)=@_;

	print(" grep -R -h  '\\\\$keyword2\'  /root/chm_all.txt    >>  $each \n");
	system(" grep -R -h  '\\\\$keyword2'  /root/chm_all.txt     >>  $each \n");
}

sub append_summary_with_eix($$)
{
	(my $filename, $keyword)=@_;

	system(" echo  >> $filename ");
	system(" echo  SUMMARY:   >> $filename ");
	print (" eix -n -y    $keyword | grep -v  Available |grep -v Homepage >>  $filename \n");
	system(" eix -n -y    $keyword | grep -v  Available |grep -v Homepage >>  $filename ");
}

sub append_summary_with_yum($$)
{
	(my $filename, $keyword)=@_;
	system(" echo  >> $filename ");
	system(" echo  SUMMARY:   >> $filename ");
	system(" /root/bin/yum_search.pl   $keyword >>  $filename ");

}
########################################################################
sub search_in_everything($)
{
	(my $file)=@_;

	$keyword=$file;
	$keyword=~s/^txt2\///g;
	$keyword=~s/_源码_分析_todo.txt$//g; 

	$first_keyword=get_first_keyword($keyword);
	if( keyword_exists_in_everything($first_keyword))
	{
		if(have_sub_package($first_keyword))
		{
			logger("#DELETE:  txt2/$keyword*.txt  应该删除 \n");
		}
	}

	
}

sub get_first_keyword($)
{
	(my $input)=@_;
	my @tmp=split(/_/, $input);
	return $tmp[0];
}

sub have_sub_package($)
{
	(my $name)=@_;
	my @all=glob("txt2/".$name."_*");
	if(scalar(@all) > 1)
	{
		print "#OK: $name have sub package \n";
		return 1;
	}

	return undef;
}

sub keyword_exists_in_everything($)
{
	(my $keyword)=@_;
	$tmp=$keyword;
	$tmp=~s/_/+/g;
	$tmp=~s/-/+/g;

	system(" wget http://127.0.0.1:8888/\?s=$tmp+txt  -O output.html     ");
	system("sed 's/tr>/tr>\\n/g' output.html -i ");

	$count= count_line();
	print "COUNT: $count \n";
	if($count == 7)
	{
		return undef ;
	}
	return 1;

}

#==========================================================================
sub count_line($)
{
	my $count=0;
	open(FILE, "output.html") or die("output.html error \n");
	for(<FILE>)
	{
		$count++;
	}
	return $count;
}

#==========================================================================
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> all.log") or warn("open all.log error\n");
	print FILE $log_str;
	print $log_str;
	close(FILE);
}

