#!/usr/bin/perl
#20100601, 添加lmy库的支持。 
use POSIX qw(strftime);
$file=$ARGV[0] or die("$0 filename \n");
$file=gen_html($file);
system(" cp   $file /var/www/html/ ");

$file2=gen_php_data($file);
system(" cp   $file2 /var/www/html/ ");


if(! -f "/var/www/html/js/")
{
    mkdir("/var/www/html/js");
}
if(! -d "/root/eden_cache/")
{
    die("#you  should checkout   eded cache \n");
}
system("cp /root/eden_cache/jquery_all_version/jquery-1.3.1.js.gz  /var/www/html/js/");
system(" gzip -f  -d  /var/www/html/js/jquery-1.3.1.js.gz ");

########################################################################
sub gen_html($)
{
    (my $file)=@_;
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
    print ("#OK,  $file  generated \n");
    return $file;
}

sub gen_php_data($)
{
    (my $file)=@_;
    #$file=~s/\.php$//g;
    #$file=~s/\.html$//g;

    $file.=".php";

    open(FILE, ">$file") or die("create error \n");
    print FILE <<EOF
<?php
header("Content-Type:text/html; charset=utf-8");
\$status=strftime("%Y_%m_%d_%T", time());
echo "<div class='comment'><h6>process info :  \$status </p></div>\n";
?>
EOF
;
    close(FILE);
    print "#OK: $file generated \n";
    return $file;
}

__DATA__

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>new_html </title>
<script src="js/jquery-1.3.1.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
    $(              function(){
                        $("#resText").html("<h3> hello  __TEMPLATE__  </h3>"); //
                    }
     )
</script>
<script> 
setInterval(function() {
			$.get("__TEMPLATE__.php", $("#form1").serialize() , function (data, textStatus){
                        $("#resText").html(data); //
					}
			);
}, 1000);  //one second 
</script>


<body>
	<strong><font>__TEMPLATE__</font></strong>
    <div id="resText">
    </div>
</body>
</html>

