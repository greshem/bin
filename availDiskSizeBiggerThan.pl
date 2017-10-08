#!/usr/bin/perl
$in=shift or die("$0 size_G \n");
$line=`df --block-size=1  `;
@lines=split(/\n/, $line);
for (@lines)
{
#	print $_,"\n";
}
@root=grep{/\/$/ } @lines;
print $root[0],"\n";
@remain=split(/\s+/, $root[0]);

$remain_df=int(($remain[3])/1024/1024/1024);
print "remain " , $remain_df, "G\n";
if($remain_df > $in)
{
	exit 0
}
else
{
	exit 1
}
