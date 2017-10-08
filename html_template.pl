#!/usr/bin/perl
#20100601, 添加lmy库的支持。 
use POSIX qw(strftime);
$file=$ARGV[0] or die("$0 filename \n");
if($file!~/html$/)
{
	$file.=".html";
}
$time=strftime("%Y_%m_%d", localtime(time()));
print $time;
open(FILE,">".$file) or die("open file error $!\n");
while(<DATA>)
{
	if(/__TEMPLATE__/)
	{
		$_=~s/__TEMPLATE__/$file/g;
		print FILE $_;
	}
	elsif(/__TIME__/)
	{
		$_=~s/__TIME__/$time/g;
		print FILE $_;
	}
	else
	{
		print FILE $_;
	}
}
close(FILE);

__DATA__

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>new_html </title>
<script src="scripts/jquery-1.3.1.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
    $(              function(){
                        $("#resText").html("<h3> hello  </h3>"); // 靠靠靠靠靠靠
                    }
     )
</script>



<body>
	<strong><font>__TEMPLATE__</font></strong>
    <div id="#resText">
    </div>
</body>
</html>

