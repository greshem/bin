#!/usr/bin/perl  
#这里 实现 txt 文件的发送: 

use MIME::Lite;           
use   Net::SMTP;  
        	
if($ARGV[0] eq "" )  
{ 
    print " Usage ",$ARGV[-1],"file\n";
    exit(-1);
}
open(FILE, $ARGV[0])  or die "cannot open the file \n";
@msg=<FILE>;   
close(FILE);

sub  change_img_to_string()
{
    my $msg2=MIME::Lite->new();
    $msg2->attach(
    Type     => 'image/gif', # the attachment mime type
    Path     => '/root/a.gif', # local address of the attachment
    Filename => 'asuwish.gif', # the name of attachment in email
    );
    my $str=$msg2->as_string();
    return $str;
}

#$smtp   =   Net::SMTP->new('192.168.1.2');  
$smtp   =   Net::SMTP->new('mail.emotibot.com.cn',  
    Hello   =>   'mail.emotibot.com.cn',  
    Timeout   =>   30,  
    Debug       =>   1,  
    )   or   die;      

$smtp->mail()   or   die;  
$smtp->to('greshem@emotibot.com.cn');  

#$smtp->auth("greshem", "0***************3","PLAIN");
#$smtp->data("From: qiazonjie <qianzhongie@gmail.com> \r\n To: Qianzhogjie <greshem@emotibot.com.cne> \r\n Subject: lovleove  \r\nTo:   postmaster\n");  

$smtp->data();
$smtp->datasend("From: Qzj<greshem\@emotibot.com.cn>\n");
$smtp->datasend("To: Qzj<greshem\@emotibot.com.cn>\n");
$smtp->datasend("Subject: ".$ARGV[0]."\n");
$smtp->datasend("testt start \n");  
$smtp->datasend("\n");  

for (@msg)
{
    $smtp->datasend($_);  
}	 

#$str=change_img_to_string()
#$smtp->datasend($str);

$smtp->dataend();  
$smtp->quit;       
