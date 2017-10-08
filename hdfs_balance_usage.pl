#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#==========================================================================
#同步的带宽  上限 设置成   512M   解决同步的效率 太慢的关系  
	hadoop dfsadmin -setBalancerBandwidth 524288000


hadoop balancer -Threshold 10   #每个磁盘的利用率 之间的差距  都不会 超过 10%  
