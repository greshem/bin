#!/usr/bin/perl
#if [ ! $# -eq 1 ];then
#	echo "$0 file.php"
#	exit 1
#fi
#if ! grep "require_once 'Log.php'" $1;then
#
#sed -i -e '/<?/q;r  /root/php_logger_append/logger.php;q'  $1
#else
#echo "already add logger"
#fi
$file=shift or die("Usage: $0 file");
open(FILE, $file) or die("open file error\n");
$first=1;

for(<FILE>)
{
	if(/<?/)
	{
		if($first)
		{
			print $_;
			appendFile();
			$first=undef;
		}
		else
		{
			print $_;
		}
	}
	else
	{
		print $_;
	}
}

sub appendFile()
{
	for(<DATA>)
	{
		print $_;
	}
}
__DATA__
echo '<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />';
require_once 'Log.php';
$conf = array();
$logger = &Log::singleton('firebug', '', 'PHP', $conf);
$logger->log(' php 调试开始',     PEAR_LOG_DEBUG);
