#!/usr/bin/perl    
use XBase;
my $path="/opt/qianlong/sysdata/history/shase/shbase.dbf";
my $table = new XBase $path or die XBase->errstr;
    my $cursor = $table->prepare_select("STOCK_CODE", "STOCK_NAME", "START_DATE","AG","FIELD","VOCATION");
    while (my @data = $cursor->fetch) {
	### do something here, like print "@data\n";
	#print join("|", @data),"\n";
	if($data["STOCK_CODE"] == $ARGV[0])
	{
		print "CODE=",$data[0], "  NAME=",$data[1], "  DATE=",$data[2], "  AG=",$data[3]*100," ÷ ", $data[4]," ",$data[5],"\n";
		#print @data,"\n";
		#exit(1);
	}
    }

