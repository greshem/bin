#!/usr/bin/perl

#2011_01_06_22:21:54 add by greshem, 添加制作成守护进程的模式， 避免 下面的进程阻塞. 
#
use HTML::LinkExtractor;
use File::Basename;
use LWP::Simple;
#use List::MoreUtils qw(maxstr);
use List::Util qw(maxstr);
use Data::Dumper;
use URI::URL;
use LWP::UserAgent; 
chdir("/var/www/html/one_piece/");
$week_day=(localtime(time()))[6];

my $pid=fork();
print "pid=", $pid,"\n";
if($pid)
{
	print "parent process\n";
	exit(0);
}
else
{
	print ("child process\n");
}


if($week_day == 4)
{
	print "  今天星期五 开始更新了\n";
	exit(-1);
}
else
{
	print " 今天不是星期五， 退出\n";
	exit(-1);
}
$index_html="http://www.9lala.com/";
$onepiece_html="http://www.9lala.com/Html/hzw/";


$ua= new LWP::UserAgent();
$ua->timeout(10);
my @ns_headers = (
   'User-Agent' => 'Mozilla/4.05 [en] (X11; U;Linux 2.6.20 32 i686', 
   'Accept' => 'image/gif, image/x-xbitmap, image/jpeg, 
        image/pjpeg, image/png, */*',
   'Accept-Charset' => 'iso-8859-1,*,utf-8',
   'Accept-Language' => 'en-US',
);

our $newest_url;
our $newest_name; 
$finish=0;
while(!$finish)
{
	
	@time=localtime(time());
	$minute=$time[1];
	$hour=$time[2];
	#$week_day=$time[6];
	$response=$ua->get($onepiece_html);
	if($response->is_success)
	{
		$html=$response->content();
		
		%tmp=get_one_piece_comic_url(\$html);
		#print Dumper(%tmp);
		@new_article=grep {/海贼王\d+/ } keys %tmp;
			
		$newest= maxstr @new_article,"\n";
		if($newest gt get_last_week())
		{
			$newest_url=$tmp{$newest};
			$newest_name=$newest;
			$newest_url.=".js";
			print "九拉拉星期 $week_day  $hour:$minute 更新海贼王  可以下载最新\n";		
			last;
		} 
		else
		{
			print "九拉拉星期五 到$hour:$minute 还没有 更新海贼王  \n";		
		}
	}
	else
	{
		print "GET: ERROR: $response->error_code()\n";	
	}	
	print "sleep 1hour\n";
	sleep(3600);
}

#以js 结尾的url ， 里面是javascript写的 藏着 图片地址的js脚本
download_comic($newest_url);
put_newest_week();
send_to_qzj_via_fetion();

sub send_to_qzj_via_fetion()
{
	open(FETION, ">/tmp/jiulala");
	@time=localtime(time());
	$hour=$time[2];
	$min=$time[1];
	print FETION  " one piece update successfuly  at $hour: $min\n";
	close FETION;
	`/bin/fetion_sendfile /tmp/jiulala`;
}
###################################
sub get_one_piece_comic_url($)
{
	(my $in)=@_;
	my $LX= new HTML::LinkExtractor();
	%comic;
	$LX->parse($in);
	for(@{ $LX->links()})
	{
		if( $_->{_TEXT}=~/海贼王/)
		{
			#print $_->{_TEXT} ,"-->";
			($title)= ($_->{_TEXT}=~/.*\>(.*)<.*/);
			#print $title ,"-->  ";
			$url=new URI::URL($_->{href}, $index_html);
			#print $_->{href}, "\n";
			#print $url->abs,"\n";
			$tmp= sprintf "%s", $url->abs;

			$comic{$title}=	$tmp;
		}
	}
	return %comic;

}

sub get_last_week()
{
	open(FILE, "last_week") or return("海贼王000");
	my @str=(<FILE>);
	close(FILE);
	map {chomp $_} @str;
	return $str[0];	
}
sub put_newest_week()
{
	open(FILE, ">last_week") or warn("open  last_week file error\n");
	print FILE $newest_name,"\n";
	close (FILE);
}
#传入 js$ 结尾的url 地址。 
sub download_comic($)
{
	(my $in)=@_;
	my $LX= new HTML::LinkExtractor();		
	print "开始下载海贼王  漫画\n";
	print "处理 $in\n";
	$url=get $in;
	$url=~s/^/\$/;
	eval($url);
	warn $@ if $@;
	$LX->parse(\$hdwlfContent);
	for (@{$LX->links})
	{
		print $_->{src},"\n";	
		$imgfile= $_->{src};
		lwp_2_firefox_and_referer( $imgfile);
	}	
	print "下载完成\n";
}
#传入一个 url 的图片的地址，
#其实传入一个 url 同样可以， 
sub lwp_2_firefox_and_referer($)
{
	(my $in)=@_;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(10);
	#$ua->env_proxy;

	my @ns_headers = (
	   'User-Agent' => 'Mozilla/4.05 [en] (X11; U;Linux 2.6.20 32 i686', 
	   'Accept' => 'image/gif, image/x-xbitmap, image/jpeg, 
			image/pjpeg, image/png, */*',
	   'Accept-Charset' => 'iso-8859-1,*,utf-8',
	   'Accept-Language' => 'en-US',
	   'Referer'=>'http://www.9lala.com/',
	  );
		
	my $output_file;
	my $response = $ua->get($in, @ns_headers);

	unless ($response->is_success) {
			print "(failed!!! ".$response->code.")\n";}
		
	my $htm =  $response->content;

	$output_file=basename $in;
	$output_file.="jpg" if( ! $output_file=~/jpg$|png$/);
	open(JPG,">$output_file");
	print JPG  $response->content;
	close(JPG);
}
