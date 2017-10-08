#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#record 
sar -A -o /root/sar_stat_$(getToday.sh).dat  1     100000000 > /dev/null & 
sar -A -o /root/sar_stat_$(getTodayTime.sh).dat  1 100000000 > /dev/null & 
sar -A -o /root/sar_stat_$(getTodayTime.sh).dat  1 100000000 & 

#dump record info 
sar -f  /root/star_stat.dat 

#print , time , strftime ,   
set xlabel "time"  
set xdata time   
set timefmt "%H:%M:%S"
plot "data.txt" using 0:3 with lines   #cpu , centos5_2 
replot "data.txt " using 1:4 with line  #diff , compare  
plot "sarx.txt" using 0:3 title "%user", '' using 0:4 title "%sys"  #multi  line 



#==========================================================================
yum install  sysstat
sar 2 100 #each 2 seconds. 100 totals.

#Report CPU utilization
sar -u 2 5

#Report statistics on IRQ 14  , Data are stored in output file called int14.file.
sar -I 14 -o int14.file 2 10

#Display memory and network statistics saved in daily data file 'sa16'.
sar -r -n DEV -f /var/log/sa/sa16

sar -A			#dump all 


#==========================================================================
#cross
adc sa1 sa2 sadf
pidstat mpstat iostat vmstat


