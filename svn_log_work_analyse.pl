#!/usr/bin/perl
use GD;
use GD::Graph;
use GD::Graph::pie;
use Encode;

use SVG::TT::Graph::Bar;

use POSIX;
use Time::Local;

#use encoding utf8;
#our $logtmp="/tmp/svnLog_time_anysle.txt";
our $logtmp="svnLog_time_anysle.txt";
our $g_from_abs_time;
our $g_to_abs_time;
our @g_data_serial,@g_geb_minutes_serial,@g_qzj_minutes_serial,@g_hhb_minutes_serial,@g_total_minutes_serial;

system("svn log -g >$logtmp");

#system("cp detallog.txt $logtmp");  


get_local_time();
log_filter();
plot_bars("greshem.svg","Ǯ�ҽ���־",@g_qzj_minutes_serial);
plot_bars("huanghaibo.svg","�ƺ�����־",@g_hhb_minutes_serial);
plot_bars("gengerbin.svg","��������־",@g_geb_minutes_serial);
plot_bars("gongzuozu.svg","��������־",@g_total_minutes_serial);


#����������� ��ʼ����Χ����
sub get_local_time()
{
	my ($from_date) = $ARGV[0];
	if(length($ARGV[0])==0)
	{
		$from_date=getTodayStr(); 
	}
	$g_from_abs_time=&get_abs_time($from_date);

	my $to_date = $ARGV[1];
	if(length($ARGV[1])==0)
	{
		$to_date=getTodayStr(); 
	}
	$g_to_abs_time=&get_abs_time($to_date);
	#print "������ʱ�����xxxx-xx-xx"."\n";
}

#ʱ��ת�� ת���ɿɱȽϵ�ʱ���ʽ
sub get_abs_time($)
{
	my $str=$_[0];
    if($str=~/\s*(\d\d\d\d)-(\d\d)-(\d\d)\s*/i)
	{   
		$str=$str." 00:00:00";
		my @arr = split(/[- :]/,$str);
		my $abs_time = timelocal($arr[5],$arr[4],$arr[3],$arr[2],$arr[1],$arr[0]);
		#print $abs_time."\n";
		return $abs_time;
	}
	return 0;
}


#***************************************************************************
# Description ������־�ļ� ͳ�Ƴ�ָ����Χ�ڵ���־�ֲ���һ��Ϊ��λ �����ָ��ˣ����壩
# @param 	
# @return 	
# @notice: �õ�ͳ������
# 
#***************************************************************************
sub log_filter()
{
    my($geb,$qzj,$hhb,$geb_totol_minutes,$qzj_totol_minutes,$hhb_totol_minutes,$b_geb,$b_qzj,$b_hhb,$b_cac)={0};
    $geb_totol_minutes=$qzj_totol_minutes=$hhb_totol_minutes=0;
  	$geb=decode("gb2312","������");
    $qzj=decode("gb2312","Ǯ�ҽ�");
    $hhb=decode("gb2312","�ƺ���");

	my $filter_date=$ARGV[0];
    if(length($ARGV[0])==0)
    {     
		$filter_date=&getTodayStr();    
		print $filter_date."\n";       
    } 
	open(FILE, $logtmp)  or die("Open file error\n");
	while(<FILE>)
	{
		my $line = $_;
		if(/\s*(\d\d\d\d)-(\d\d)-(\d\d)\s*/i)
        { 
			my $curr_date=$1."-".$2."-".$3;
			$curr_abs= get_abs_time($curr_date);
			if(($g_from_abs_time<=$curr_abs)&&($curr_abs<=$g_to_abs_time))
			{
				unless($filter_date eq $curr_date)
				{
					push(@g_data_serial,$filter_date);
 					push(@g_geb_minutes_serial,$geb_totol_minutes);
 					push(@g_qzj_minutes_serial,$qzj_totol_minutes);
					push(@g_hhb_minutes_serial,$hhb_totol_minutes);
					push(@g_total_minutes_serial,$hhb_totol_minutes+$geb_totol_minutes+$qzj_totol_minutes);
					$geb_totol_minutes=$qzj_totol_minutes=$hhb_totol_minutes=0;
					$filter_date = $curr_date;
				} 
				#��˭�޸ĵļ�¼
				if($line=~/\s*(gengerbin)\s*/i)
				{
					$b_geb=1;
				}
				if($line=~/\s*(greshem)\s*/i)
				{
					$b_qzj=1;
				}
				if($line=~/\s*(huanghaibo)\s*/i)
				{
					$b_hhb=1;
				}
				$b_cac=1;
			}				
		}
		if(/[add|mdf|ref|chg|bug]_(\d+)([m|h])/i)
        {
			if($b_cac==1)
			{ 
				my($num);
				if($b_geb==1)
				{
					$geb_totol_minutes=$geb_totol_minutes+&add_minutes($1,$2);
					$b_geb=0;
				}
				if($b_qzj==1)
				{
					$qzj_totol_minutes=$qzj_totol_minutes+&add_minutes($1,$2);
					$b_qzj=0;
				}
				if($b_hhb==1)
				{
					$hhb_totol_minutes=$hhb_totol_minutes+&add_minutes($1,$2);
					$b_hhb=0;
				}
				$b_cac=0;
			}
        }	
	}
	close(FILE);
	unlink($logtmp);

	print("ʱ�����У�");
	printarr(@g_data_serial);
	print("���������ʱ��:");
	printarr(@g_geb_minutes_serial);
    print("Ǯ�ҽܴ���ʱ��:");
	printarr(@g_qzj_minutes_serial);
    print("�ƺ�������ʱ��:");
	printarr(@g_hhb_minutes_serial);
	print("�ܵĴ���ʱ��:");
	printarr(@g_total_minutes_serial);

	#д�ļ�workansy.dat
	my(@data);
 	push(@data,$geb_totol_minutes);
 	push(@data,$qzj_totol_minutes);
 	push(@data,$hhb_totol_minutes);
	#&plot_bars(@data);
	&write_file(@data);
}

#�����ӡ����
sub printarr(@)
{
	my @arr = @_;
	foreach $arritem(@arr)
	{
		print $arritem."\t";
	}
	print "\n";
}

#ʱ�����
sub add_minutes($$)
{
	my($arg1, $arg2)=@_;
    #$arg1=$_[0];
    #$arg2=$_[1];
	$add_min=0;
	if($arg2 eq "h")
	{
		$add_min=$arg1*60;
	}
	else
    {
		$add_min=$arg1;
    }

	return $add_min;
}

#***************************************************************************
# Description	
# @param 	
# @return 	
# @notice: �����gnuplot 
# 
#***************************************************************************/
sub write_file(@) 
{
	my @tmp=@_;
  	open LOG,">work_ansy.dat" or warn"can't open the file";
  	#print LOG @_;
  	my $i=0;
  	foreach $tmp(@tmp)
  	{
   		print LOG $i."\t".$tmp."\n";
   		print $tmp."\n";
   		$i=$i+1;
  	}
  	close LOG;
}


sub getTodayStr()
{
	use POSIX 'strftime';
 	$today=POSIX::strftime('%Y-%m-%d',localtime(time()));
 	return $today;
}

sub getTodayWeekday()
{
 	use POSIX 'strftime';
 	$today=POSIX::strftime('%Y-%m-%d_%T_%A',localtime(time()));
 	return $today;
}

#��ֱ��ͼ����
sub plot_bars($$@)
{
	my ($file_name,$title,@data_sales_02)=@_;
	use SVG::TT::Graph::Bar;
	my @fields        = @g_data_serial;
	#my @data_sales_02 = @g_total_minutes_serial;
	 
 	my $graph = SVG::TT::Graph::Bar->new(
 	{
         'height' => '500',
         'width'  => '1000',
		 'fields' => \@fields,
    }
    );
 
    $graph->add_data(
    {
    'data'  => \@data_sales_02,
	#'title' => 'log',
	'title' => $title,
    }
	);
	#open( my $fh, '>', "bar.svg" );
	open( my $fh, '>', $file_name );
    select $fh;
    binmode $fh;
    print $graph->burn();
    close($fh);
 }

#����ͼ����
sub plot_pie(@)
{
	#һ���ǻ�ͼ����
 	my $pie = new GD::Graph::pie(500,200);
    @name=["geb","qzj","hhb"];
	my @data;
	@data[0]=@name;
	@data[1]=@_;
	#@data = (
	#["geb","qzj","hhb"],
	#[ $geb_totol_minutes,$qzj_totol_minutes,$hhb_totol_minutes],
	#);

  	$data1 = GD::Graph::Data->new(\@data);

  	$pie->set(
   	dclrs=>[qw(#22FF44 #24A3F1 #FA125F)],
   	pie_height =>60,
   	show_values=>1,
   	borderclrs =>"black",
   	title=>"svn log",
   	label=>"work ansy",
  	);

  	$pie->set_label_font("/bin/simsun",10);
  	$pie->set_value_font("/bin/simsun",10);
  	$pie->set_title_font("/bin/simsun",10);
  	binmode STDOUT;
  	open(FILE,">workimg.png");
 	print FILE $pie->plot($data1)->png;
  	close FILE;
}

