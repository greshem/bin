#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

cat >> /etc/mail.rc <<EOF
set from=zjqian@tnsoft.com.cn smtp=smtp.qq.com  
set smtp-auth-user=zjqian@tnsoft.com.cn smtp-auth-password=T*************1 smtp-auth=login  


# set smtp-use-starttls
# set from=petty.china@yahoo.com  smtp=smtp.mail.yahoo.com 
# set smtp-auth-user=petty.china smtp-auth-password=9**************1 smtp-auth=login  
# set nss-config-dir=/root/.mozilla/firefox/59ovxvss.default/
# set ssl-verify=ignore


#set from=greshem1983@163.com smtp=smtp.163.com
#set smtp-auth-user=greshem1983 smtp-auth-password=q************8 smtp-auth=login  


set from=greshem@sogou.com smtp=smtp.sogou.com
set smtp-auth-user=greshem smtp-auth-password=q****************n smtp-auth=login  


# set smtp-use-starttls
# #set nss-config-dir=~/.mozilla/firefox/yyyyyyyy.default/
# set nss-config-dir=/root/.mozilla/firefox/59ovxvss.default/
# set ssl-verify=ignore
# #set smtp=smtp://smtp.gmail.com:587
# set smtp=smtp://smtp.gmail.com:465
# set smtp-auth=login
# set smtp-auth-user=greshem
# set smtp-auth-password=1*********2
# set from=greshem@gmail.com


EOF


letter_sara_teresa.pl| mailx -s "demo title" mark.sinopet@yahoo.com.cn  
letter_sara_teresa.pl| mailx -s "demo title" greshem@gmail.com
letter_sara_teresa.pl| mailx -s "demo title" greshem@qq.com  
letter_sara_teresa.pl| mailx -s "demo title" zjqian@tnsoft.com.cn

letter_sara_teresa.pl| mailx -s "demo title" china.pond@yahoo.com
letter_sara_teresa.pl| mailx -s "demo title" china_pond@yahoo.com
letter_sara_teresa.pl| mailx -s "demo title" pond_china@yahoo.com
letter_sara_teresa.pl| mailx -s "demo title" pond.china@yahoo.com

letter_sara_teresa.pl| mailx -s "demo title" sara_wen@hotmail.com
letter_sara_teresa.pl| mailx -s "demo title" sino_pet@163.com  
letter_sara_teresa.pl| mailx -s "demo title" sara@petty-china.com
letter_sara_teresa.pl| mailx -s "demo title" 605695163@qq.com

letter_sara_teresa.pl| mailx -s "demo title" sale@petty-china.com  	#"Joanna" 
letter_sara_teresa.pl| mailx -s "demo title" info@petty-china.com  	#"Shanghai Petty"
letter_sara_teresa.pl| mailx -s "demo title" shanghai_pretty@yahoo.com  
letter_sara_teresa.pl| mailx -s "demo title" info@petty-china.com  
letter_sara_teresa.pl| mailx -s "demo title" petty-china@263.net 
letter_sara_teresa.pl| mailx -s "demo title" sino_pet@yahoo.com.cn



