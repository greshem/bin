#!/usr/bin/perl
#$3 昨天收盘价格
#$4 今天开盘价格
#$5 成交额
#$8 最新价格
##############3
#$9 
#
use XBase;
sub get_AG
{
my ( $code)=@_;
my $path_base="/opt/qianlong/sysdata/history/shase/shbase.dbf";
my $table = new XBase $path_base or die XBase->errstr;
    my $cursor = $table->prepare_select("STOCK_CODE", "STOCK_NAME", "START_DATE","AG");
    while (my @data = $cursor->fetch)
    {
	### do something here, like print "@data\n";
	#print join("|", @data),"\n";
	if($data["STOCK_CODE"] == $code)
	{
		#print "CODE=",$data[0], "  NAME=",$data[1], "  DATE=",$data[2], "  AG=",$data[3]*100,"手", "\n";
		#print @data,"\n";
		#exit(1);
		return $data[3]*100*100;
	}
    }
}
#	$code="600000";
	#$AG=get_AG("600000");
$file="/opt/qianlong/sysdata/remote/show2003.dbf";
my $table = new XBase $file or die XBase->errstr,"aaaaaaaaaaaaaa";
    my $cursor = $table->prepare_select("S1", "S2", "S3","S4", "S5","S6","S7", "S8", "S9", "S10","S11","S12",\
"S13","S14","S15","S16","S17","S18","S19","S20","S21", "S22","S23", "S24", "S25", "S26", "S27", "S28", "S29", "S30", "S31", "S32","S33" );
    while (my @data = $cursor->fetch) {
	### do something here, like print "@data\n";
#	if(@data[0]=~/^60/ && @data[1]!~/ST/)
	if(@data[0]=~/^60/ && @data[0]=~/$ARGV[0]/)

	{
		#print join("|", @data),"\n";
		print "证券代码:",$data[0], "证券名称:",$data[1],"\n";
		print "#"x80,"\n";
		print "成交金额:", $data[4], "最新价格:",$data[7],"\n";
		print "#"x80,"\n";
		print "当前买入价:",$data[8],"当前卖出价:",$data[9],"成交数量:",$data[10],"\n";
		print "#"x80,"\n";
		print "卖五: ", $data[31], "\t",$data[32]/100,"\n";
		print "卖四: ", $data[29], "\t",$data[30]/100,"\n";
		print "卖三: ", $data[23], "\t",$data[24]/100,"\n";
		print "卖二: ", $data[21], "\t",$data[22]/100,"\n";
		print "卖一: ", $data[9],  "\t", $data[20]/100,"\n";

		print "买一: ", $data[8],  "\t", $data[14]/100,"\n";	
		print "买二: ", $data[15], "\t", $data[16]/100,"\n";		
		print "买三: ", $data[17], "\t", $data[18]/100,"\n";	
		print "买四: ", $data[25], "\t", $data[26]/100,"\n";	
		print "买五: ", $data[27], "\t", $data[28]/100,"\n";	
		$total_sell=$data[32]+$data[30]+$data[24]+$data[22]+$data[20];
		$total_buy =$data[14]+$data[16]+$data[18]+$data[26]+$data[28];	
		$AG=get_AG(@data[0]);
		#if($AG!=0 && $AG< 100000*1000 && $AG > 80000*1000&& ($data[7]>$data[3])  && (($data[7]-$data[3])/$data[3])<0.04 ) #流通股本 小于100亿股的. 且今天 涨幅不大的< 4%
		if($AG!=0 && $AG< 100000*1000  )
		{
			print STDERR "代码 " , $data[0], " ", $data[1], " AG= ", $AG, " 总委买= ",$total_buy," 总委卖= ",$total_sell;
			print STDERR " 委买/AG= ", 100*$total_sell/$AG,"%";
			print STDERR "\t\t委卖/AG= ", 100*$total_buy/$AG,"%";
			print STDERR " 总委买卖/AG= ", 100*($total_buy+$total_sell)/$AG,"%\n";
		}
		print "#"x80,"\n";
		print "开盘  ",$data[3],"\n";
		print "现价  ",$data[7],"\n";
		print "涨幅  ",(($data[7]-$data[3])/$data[3]),"\n";
		exit(-1);
	}
    }

	#print "X"x80,"\n";
	#print "AG=",$AG;
	#print "委买/AG=", $total_sell*100/$AG;
	#print "\t\t委卖/AG=", $total_buy*100/$AG,"\n";

