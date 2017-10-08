#!/usr/bin/perl

#2011_01_06_22:21:54 add by greshem, ����������ػ����̵�ģʽ�� ���� ����Ľ�������. 
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
	print "  ���������� ��ʼ������\n";
	exit(-1);
}
else
{
	print " ���첻�������壬 �˳�\n";
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
		@new_article=grep {/������\d+/ } keys %tmp;
			
		$newest= maxstr @new_article,"\n";
		if($newest gt get_last_week())
		{
			$newest_url=$tmp{$newest};
			$newest_name=$newest;
			$newest_url.=".js";
			print "���������� $week_day  $hour:$minute ���º�����  ������������\n";		
			last;
		} 
		else
		{
			print "������������ ��$hour:$minute ��û�� ���º�����  \n";		
		}
	}
	else
	{
		print "GET: ERROR: $response->error_code()\n";	
	}	
	print "sleep 1hour\n";
	sleep(3600);
}

#��js ��β��url �� ������javascriptд�� ���� ͼƬ��ַ��js�ű�
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
		if( $_->{_TEXT}=~/������/)
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
	open(FILE, "last_week") or return("������000");
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
#���� js$ ��β��url ��ַ�� 
sub download_comic($)
{
	(my $in)=@_;
	my $LX= new HTML::LinkExtractor();		
	print "��ʼ���غ�����  ����\n";
	print "���� $in\n";
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
	print "�������\n";
}
#����һ�� url ��ͼƬ�ĵ�ַ��
#��ʵ����һ�� url ͬ�����ԣ� 
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
