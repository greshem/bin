#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__


cat iput_shell.sh  |parallel 

#==========================================================================
cat bigfile.bin | parallel --pipe --recend '' -k bzip2 --best > compressedfile.bz2 

#==========================================================================
grep pattern bigfile.txt 
#现在你可以这样：
cat bigfile.txt | parallel --pipe grep 'pattern' 
#或者这样：
cat bigfile.txt | parallel --block 10M --pipe grep 'pattern' 
这第二种用法使用了 –block 10M参数，这是说每个内核处理1千万行——你可以用这个参数来调整每个CUP内核处理多少行数据。

#==========================================================================
cat bigfile.txt | parallel --pipe wc -l | awk '{s+=$1} END {print s}' 

#==========================================================================
cat bigfile.txt | parallel --pipe sed s^old^new^g 
