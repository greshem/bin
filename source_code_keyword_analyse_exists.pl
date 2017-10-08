#!/usr/bin/perl
#做这个程序之前 ,需要在windows 上制作一下端口转发的功能, 
#	 cygwin 的ssh 的转发的效果 比 putty.exe 的转发的效果好一些 
# ssh -CfNg -R 8888:127.0.0.1:80 root@192.168.1.101 #
# ssh -CfNg -R 8888:127.0.0.1:8080 root@192.168.1.101 # svn server 
# 运行这个程序 就是  192.168.1.101 
#bug: 新的版本  提交的 需要是中文 utf8 否则会失败。 

#change_uri_url_to_chinese_str("a");


my $keyword=shift or warn("Usage: $0  keyword \n");
our %g_related_keyword;
our $keyword_exists_fun;
if( nmap_8888_port()) 
{
    $keyword_exists_fun=\&keyword_exists_in_everything;
}
else
{
    print "search in  local with git \n";
    $keyword_exists_fun=\&keyword_exists_in_git_repo;
}

#$keyword_exists_fun=\&keyword_exists_in_git_repo;
#$keyword_exists_fun->("linux");
if(! defined($keyword))
{
    #gentoo  helper 
	for $each (grep {-d } glob("*"))
	{

		deal_with_one_keyword($each);
	}
	append_chm();

	die("\n");
}



if(-f $keyword)
{
	open(FILE, "$keyword") or die("Open $keyword error \n");
	for(<FILE>)
	{
		chomp;
		print $_."\n";

		deal_with_one_keyword($_);
		#sleep(1);
	}
}
else
{
	deal_with_one_keyword($keyword);
}

print "######################################################################## \n";
print "#Related \n";
print join("|", keys(%g_related_keyword))."\n";


########################################################################
sub append_chm()
{
	print "######################################################################## \n";
	print "Add related chm \n";
	print " perl /root/bin/gentoo_append_chm_DESC.pl \n";
	system(" perl /root/bin/gentoo_append_chm_DESC.pl ");
}

########################################################################
#最简单的.
sub logger($)
{
	(my $log_str)=@_;
	use POSIX 'strftime';
	my $log_time=POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));

	open(FILE, ">> /var/log/keyword_exists.log") or warn("open all.log error\n");
	print FILE $log_time.":".$log_str;
	print  $log_str;
	close(FILE);
}
sub logger_not($)
{
	(my $log_str)=@_;

	use POSIX 'strftime';
	my $log_time=POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));


	open(FILE, ">> /var/log/keyword_not_exists.log") or warn("open all.log error\n");
	print FILE $log_time.":".$log_str;
	print  $log_str;
	close(FILE);
}


sub deal_with_one_keyword($)
{
	(my $keyword)=@_;

	if( -f "${keyword}_源码_分析_todo.txt")
	{
		print "${keyword}_源码_分析_todo.txt 已经存在\n";
		return  ;
	}
	#if(! keyword_exists_in_everything($keyword))
	#if(! keyword_exists_in_git_repo($keyword))
    if( !  $keyword_exists_fun->($keyword)  )
	{
			print "# $keyword 关键字 不存在, 创建 文档  ${keyword}_源码_分析_todo.txt\n";
			print(" perl /root/bin/create_source_src_analyse.pl  $keyword  \n");
			system(" perl /root//bin/create_source_src_analyse_utf8.pl   $keyword  \n");
			
			logger_not("# $keyword 关键字不 存在, \n");
			print ("# append src chm  path,  执行  perl append_chm.pl  \n");
	}
	else
	{
		logger("# $keyword 关键字 存在, \n");
        print(join("\n", $keyword_exists_fun->($keyword) ));
		get_file_name_uri();
	}

}

#or 
sub change_to_egrep_or($)
{
    (my $pattern)=@_;
    $pattern=~s/\+/\|/g;
    $pattern=~s/^/\'/g;
    $pattern=~s/$/\'/g;
    return  $pattern;
}
sub change_to_egrep_and($)
{
    (my $pattern)=@_;
    $pattern=~s/\+/\|grep -i /g;
    return  $pattern;
}


#and 

sub  keyword_exists_in_git_repo($)
{
	(my $keyword)=@_;
	$tmp=$keyword;
	#$tmp=~s/_/+/g;
	#$tmp=~s/-/+/g;
    
    if(! -d "/root/_pre_cache_greshem/")
    {
        die("you should  git clone   _pre_cache_greshem  \n");
    }
    $tmp=change_to_egrep_and($tmp);
    
    print "GGGG: find  /root/_pre_cache_greshem/ |grep -i  $tmp   |grep txt \n" ;
    @lines=`find  /root/_pre_cache_greshem/ |grep  $tmp -i  |grep txt\$ `;
    $count=scalar(@lines); 
    return @lines;
}


sub keyword_exists_in_everything($)
{
	(my $keyword)=@_;
	$tmp=$keyword;
	$tmp=~s/_/+/g;
	$tmp=~s/-/+/g;


	#system(" wget http://127.0.0.1:8888/\?s=$tmp+txt+源码  -O /tmp/output.html     ");
	#use URI::Escape;
	#$content=uri_unescape($input_str);
	my $uri=$tmp;
	#utf8::encode($tmp);
        #my $uri = uri_escape($tmp);

	print (" wget  http://127.0.0.1:8888/\?s=$uri+txt  -O /tmp/output.html     \n");
	system(" wget  --http-user=root  --http-passwd=q**************n http://127.0.0.1:8888/\?s=$uri+txt  -O /tmp/output.html     ");
	system("sed 's/tr>/tr>\\n/g' /tmp/output.html -i ");

	$count= count_line();
	print "COUNT: $count \n";
	if($count == 0)
	{
		return undef ;
	}
	return 1;

}
#==========================================================================
#在 pre_cache  目录下的文件一共有 几个. 
sub count_line($)
{
	my $count=0;
	open(FILE, "/tmp/output.html") or die("/tmp/output.html error \n");
	for(<FILE>)
	{
		if($_=~/pre_cache/)
		{
			$count++;
		}
	}
	return $count;
}

#Starting Nmap 6.01 ( http://nmap.org ) at 2015-03-05 09:40 CST
#Nmap scan report for localhost (127.0.0.1)
#Host is up (0.00019s latency).
#PORT     STATE  SERVICE
#8888/tcp closed sun-answerbook

sub  nmap_8888_port()
{
	open(PIPE, "nmap 127.0.0.1 -p 8888           |") or die("nmap not exists  , yum install nmap   \n");
	for(<PIPE>)
	{
		if($_=~/8888.*closed/)
		{
			warn(" windows  everything 80 port  not  redir to  8888 \n");
			warn("EXEC in win:  ssh -CfNg -R 8888:127.0.0.1:80 root\@192.168.1.6  \n");
			warn("EXEC in win:  ssh -CfNg -R 8888:127.0.0.1:8080 root@192.168.100.51 \n");
			warn("EXEC in win:  ssh -CfNg -R 8888:127.0.0.1:8080 root\@192.168.1.101  \n");
            return undef;
		}
	}
    return 1;
}

#<a href="/K%3A/sdb1/_xfile/2015_all_iso/_xfile_2015_03/_pre_cache/__pre_cache_before_2014/_pre_cache_2014/_pre_cache_2014_02/Mutagen_python_%E9%9F%B3%E9%A2%91_meta_%E4%BF%A1%E6%81%AF_mp3_%E9%95%BF%E5%BA%A6_%E6%97%B6%E9%97%B4.txt" class="dl" >
sub get_file_name_uri()
{

	open(FILE, "/tmp/output.html") or warn("open /tmp/output.html error \n");
	for(<FILE>)
	{
		#if($_=~/pre_cache/ && $_=~/href="(.*\.txt)" class="dl"/)
		if($_=~/pre_cache/ && $_=~/href="(.*\.txt)".*img class=\"icon\"/)
		{	
			#print "EEEEEEEE".$1."\n";;
			change_uri_url_to_chinese_str($1);

		}
	}
}
#everything 里面的中文字  
sub change_uri_url_to_chinese_str($)
{
	#From Tsing of ispublic.com
	(my $input_str)=@_;
	#$input_str="/K%3A/sdb1/_xfile/2015_all_iso/_xfile_2015_03/_pre_cache/__pre_cache_before_2014/_pre_cache_2014/_pre_cache_2014_02/Mutagen_python_%E9%9F%B3%E9%A2%91_meta_%E4%BF%A1%E6%81%AF_mp3_%E9%95%BF%E5%BA%A6_%E6%97%B6%E9%97%B4.txt" ;
	use URI::Escape;
	$content=uri_unescape($input_str);


	use Encode qw(from_to);
	from_to($content,"utf8", "gb2312");

	$content=~s/:\//%3A\//;
	print $content."\n";
	my $wget_str= "wget --http-user root --http-passwd passwd http://localhost:8888/$content\n";
	logger_url_everything_helper("$wget_str\n");
	use File::Basename;
	
	$name=basename($content);
	$name=~s/\.txt$//;
	my @array=split(/_/, $name);
	for(@array)
	{
		#print  "KEYWORD:\t". join("|", @array)."\n";
		$g_related_keyword{$_}=$_;
	}
	#
}
sub logger_url_everything_helper($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/logger_url_everything_helper.log") or warn("open all.log error\n");
	print FILE $log_str;
	print FILE  $log_str;
	close(FILE);
}

