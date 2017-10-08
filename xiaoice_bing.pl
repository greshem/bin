    use Mojo::SinaWeibo;
    use Data::Dumper;
    my $m = Mojo::SinaWeibo->new(
         ua_debug=>0,
         log_level=>"info",
         user=>'13524304099',#微博帐号
         pwd=>'q**************n',  #帐号密码
    );
    $m->ask_xiaoice("你是谁",sub{print Dumper \@_}); #中文使用UTF8编码
	print "#curl 接口 \n";
	print "  curl  192.168.1.21:8000/openxiaoice/ask?q=你是猪头吗 \n";

    $m->run(enable_api_server=>1,host=>"192.168.1.21",port=>8000);

