#!/usr/bin/perl
our $file=$ARGV[0] or die("Usage: $0 filelist");

@txtFiles;
open(FILE, $file) or die("open file error\n");

while(<FILE>)
{
	chomp;
	if( ! -T $_)
	{
		print  $_, "\tnot text file\n";
	}
	else
	{
		push(@txtFiles, $_);	
	}
}

open(IDX, ">$file".".idx");
open(CNT, ">$file".".cnt");
$header=pack("Z8CCSZ4","QIANLONG", 1,1,scalar(@txtFiles),"    "); 
print "pack length -> ",length($header),"\n";
syswrite(IDX, $header, length($header));
$Offset=0;
for (@txtFiles)
{
	$record=packOneRecord($_);
	print length($record),"\n";
	syswrite(IDX, $record, length($record));

	open(TMP,$_);
	$size=(-s $_);
	sysread(TMP, $fileBuffer, $size);
	syswrite(CNT, $fileBuffer, $size);
	$/="\n";
	close(TMP);
}
close(IDX);
close(CNT);
sub packOneRecord($)
{

	(my $in)=@_;
	$Type=1;
	$Group=1;
	$Market=1;
	$Date=time();
	$Time=time();
	$Title=$_;
	$FilePath=$file.".cnt";
	$Offset+=(-s $in);
	$Length=(-s $in);

	#相关代码
	$Code="aaaaaaaaa";
	$UpdateDate="        ";
	$Updatetime="        ";

	$Reserved16=0;
	#
	$Reserved="            ";
	#菜单id
	$ChannelId=1;
	#同步实时咨询
	$SYNCSSZX=1;
	#
	$Reserved52=0;
	#1-24 菜单项序号
	$ProviderId=0;
	$SendIpx=0;
	#上传
	$UpFlag=0;
	$Chksum=0;
	#
	$record=pack("C C C i i Z64 Z80 i i Z36 C8 C8 C C32 S C C C C C C", $Type , $Group, \
		$Market, $Date, $Time, $Title, $FilePath, $Offset, $Length, $Code, $UpdateDate,\
		$UpdateTime, $Reserved16, $Reserved[32], $ChannelId, $SYNCSSZX, $Reserved52, \
		$ProviderId, $SendIpx, $UpFlag, $Chksum);
	#print length($record),"\n";
	return $record;
} 
