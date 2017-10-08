#!/usr/bin/perl
use Encode;
use GD;
use GD::Graph;
use GD::Image;

$todo_path = `echo ~\/doc_collaboration\/日志\/`;
chomp($todo_path);

todo_plot();

sub todo_plot()
{
	#创建并设置图片
 	$im = new GD::Image(800,800);
	
	$white = $im->colorAllocate(255,255,255);
	$black = $im->colorAllocate(0,0,0);
	$red = $im->colorAllocate(255,0,0);
	$blue = $im->colorAllocate(0,0,255);

	# make the background transparent and interlaced
	$im->transparent($blue);
 	$im->interlaced('true');
    
	#读取todo文件并绘制图片
    my (@flle_list,@todo_text);
    #@file_list=get_all_file();
    @file_list=get_todo_file_list();
	@todo_text=get_todo_text(@file_list);
    plot_img($im,@todo_text);
    
	#生成图片并进行图片格式转化
	binmode STDOUT;
    open(FILE,">workimg.gif") or die("Open png file error\n");
    binmode FILE;
	print FILE $im->gif();
    close FILE;
    system("convert workimg.gif workimg.bmp");
}

#读取所有todo文件中没有完成的任务描述
sub get_todo_text(@)
{
	my (@file_list)=@_;
    my(@todo_text,$bprint);
    $bprint=1;
    #print @file_list;
    foreach $file_list(@file_list)
	{
        push(@todo_text,$file_list);
    	open(FILE, $file_list)  or die("Open file error\n");
    	while(<FILE>)
    	{
        	if(/#\d+/i)
        	{
       			$bprint=0;
       		}
        	elsif(/\d+\./i)
        	{
            	$bprint=1;
        	}
        	if($bprint==1)
        	{
            	push(@todo_text,$_);
	    	}	
     	}
     	close(FILE);
	}
    return @todo_text;
}

#将所有todo任务绘制到图片中
sub plot_img($@)
{
	my ($im,@todo_text)=@_;
	my $str_line=40;
	my $black=$im->colorAllocate(0,0,0);
	foreach $todo_text(@todo_text)
	{
		$buf=decode("gb2312",$todo_text);
		if ( $^O =~ /MSWin32/ )
		{
 			$im->stringFT($black,'C:/WINDOWS/Fonts/SIMLI.TTF',10,0,50,$str_line,$buf,{charmap => 'Unicode',});
    	}
    	else
    	{
        	$im->stringFT($black,"/bin/simsun",10,0,50,$str_line,$buf,{charmap => 'Unicode',});
    	}
    	$str_line=$str_line+20;
    	print $todo_text."\n";
	}
}

sub getTodayStr()
{
    use POSIX 'strftime';
	$hour=POSIX::strftime('%H',localtime(time()));
	$today=POSIX::strftime('%Y%m%d',localtime(time()));
	return $today;
}

#获得todo文件列表
sub get_todo_file_list()
{
    my @file_list;
	if ( $^O =~ /MSWin32/ )
	{
		 @files= grep { -f } glob("E:\\svn_working_path\\doc_collaboration\\日志\\*_todo.txt");
	}
    else
	{
		my $todo_path = `echo ~\/doc_collaboration\/日志\/`;
        chomp($todo_path);
        $todo_path=$todo_path."*_todo.txt";
		@files= grep { -f } glob($todo_path);
		#@files= grep { -f } glob("*_todo.txt");
	}
	#@files= grep { -f } glob("*_todo.txt");
	foreach (@files)
	{
        push(@file_list,$_);
        print $_,"\n";
	}
	return @file_list;
}
