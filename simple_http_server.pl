#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}

__DATA__
python -m SimpleHTTPServer 33336

#==========================================================================
#linux_src 
cd /mnt/d/aliyun_emo/
cd /mnt/d/aliyun_emo/all_in_one
nohup  python -m SimpleHTTPServer 33444 ./ & 
nohup  python -m SimpleHTTPServer 33445 ./ & 

#python3
python -m http.server 80
