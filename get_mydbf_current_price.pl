#!/usr/bin/perl
#$3 �������̼۸�
#$4 ���쿪�̼۸�
#$5 �ɽ���
#$8 ���¼۸�
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
		#print "CODE=",$data[0], "  NAME=",$data[1], "  DATE=",$data[2], "  AG=",$data[3]*100,"��", "\n";
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
		print "֤ȯ����:",$data[0], "֤ȯ����:",$data[1],"\n";
		print "#"x80,"\n";
		print "�ɽ����:", $data[4], "���¼۸�:",$data[7],"\n";
		print "#"x80,"\n";
		print "��ǰ�����:",$data[8],"��ǰ������:",$data[9],"�ɽ�����:",$data[10],"\n";
		print "#"x80,"\n";
		print "����: ", $data[31], "\t",$data[32]/100,"\n";
		print "����: ", $data[29], "\t",$data[30]/100,"\n";
		print "����: ", $data[23], "\t",$data[24]/100,"\n";
		print "����: ", $data[21], "\t",$data[22]/100,"\n";
		print "��һ: ", $data[9],  "\t", $data[20]/100,"\n";

		print "��һ: ", $data[8],  "\t", $data[14]/100,"\n";	
		print "���: ", $data[15], "\t", $data[16]/100,"\n";		
		print "����: ", $data[17], "\t", $data[18]/100,"\n";	
		print "����: ", $data[25], "\t", $data[26]/100,"\n";	
		print "����: ", $data[27], "\t", $data[28]/100,"\n";	
		$total_sell=$data[32]+$data[30]+$data[24]+$data[22]+$data[20];
		$total_buy =$data[14]+$data[16]+$data[18]+$data[26]+$data[28];	
		$AG=get_AG(@data[0]);
		#if($AG!=0 && $AG< 100000*1000 && $AG > 80000*1000&& ($data[7]>$data[3])  && (($data[7]-$data[3])/$data[3])<0.04 ) #��ͨ�ɱ� С��100�ڹɵ�. �ҽ��� �Ƿ������< 4%
		if($AG!=0 && $AG< 100000*1000  )
		{
			print STDERR "���� " , $data[0], " ", $data[1], " AG= ", $AG, " ��ί��= ",$total_buy," ��ί��= ",$total_sell;
			print STDERR " ί��/AG= ", 100*$total_sell/$AG,"%";
			print STDERR "\t\tί��/AG= ", 100*$total_buy/$AG,"%";
			print STDERR " ��ί����/AG= ", 100*($total_buy+$total_sell)/$AG,"%\n";
		}
		print "#"x80,"\n";
		print "����  ",$data[3],"\n";
		print "�ּ�  ",$data[7],"\n";
		print "�Ƿ�  ",(($data[7]-$data[3])/$data[3]),"\n";
		exit(-1);
	}
    }

	#print "X"x80,"\n";
	#print "AG=",$AG;
	#print "ί��/AG=", $total_sell*100/$AG;
	#print "\t\tί��/AG=", $total_buy*100/$AG,"\n";

