#!/usr/bin/perl 
#
our $g_teresa="162.211.181.182";
#our $g_aliyun="139.196.170.125";
#our $g_hukai= "133.130.100.146";

our  $g_ip=$g_teresa;


sub gen_server_conf()
{
        
    open(OUTPUT, ">./sserver.conf") or die("open  /etc/sserver.conf error \n");;
    

    print "############  start gen  ssserver  \n";
    print OUTPUT   <<EOF
{
"server":"0.0.0.0",
"server_port":8388,
"password":"tgbygv",
"timeout":300,
"method":"aes-256-cfb",
"fast_open": false,
"workers": 1
}
EOF
;

    close(OUTPUT);
    print ("#generated: ./sserver.conf  successful ");

    print  ("\n\n");
    print  (" scp ./sserver.conf   $g_teresa:/etc/ \n");
    print  (" ssh $g_teresa  nohup ssserver -c /etc/sserver.conf  2&1  >/dev/null  \n");
    print  ("\n");


}

sub gen_sslocal_conf($)
{
    (my $local_ip)=@_;
    $client_ip=$local_ip;
    $output= "sslocal_${local_ip}.conf";
    print "\n############  start gen  sslocal server  \n";
    open(OUTPUT, ">$output") or die("open  $output  error \n");;

print OUTPUT  <<EOF
{
"server":"$g_teresa",
"server_port":8388,

"local_address": "0.0.0.0",
"local_port":33400,

"password":"tgbygv",
"timeout":300,
"method":"aes-256-cfb",
"fast_open": false,
"workers": 1
}
EOF
;
    print ("#generated: $output  successful \n");

    print  ("scp $output      $client_ip:/etc/$output            \n");
    print  ("ssh $client_ip  \" nohup    sslocal -c /etc/$output     2>&1 >/dev/null   & \"  \n");

    print  ("#you can  connect proxy   $client_ip with socks5  greshem.51vip.biz:33400  in  firefox  \n");

}

sub get_my_ip()
{
    my $buf=`hostname -I |awk '{print \$1}' `;
    chomp($buf);
    return $buf;
}
gen_server_conf();
print get_my_ip();
gen_sslocal_conf( get_my_ip() );

sub chrome_client_install()
{
        print <<EOF

        https://github.com/FelisCatus/SwitchyOmega
        https://github.com/FelisCatus/SwitchyOmega/releases
        #用的是  2.3.21的版本 
        https://github.com/FelisCatus/SwitchyOmega/releases/tag/v2.3.21

#开发模式 把  crx 文件解压  然后 通过加载目录的方式加载 插件 

#==========================================================================
#1. 问题 _ 的目录去掉  去掉下
#SwitchyOmega\_metadata 
#变成
#SwitchyOmega\_metadata 

EOF
;
}

#gen_sslocal_conf("192.168.1.11");
#gen_sslocal_conf("qa");
#$output=gen_sslocal_conf($client_ip);



#print  ("sserver -c /etc/sserver_hukai.conf   \n");
#print  ("sslocal -c /etc/sslocal_hukai.conf  \n");

__DATA__
git clone  https://github.com/shadowsocks/shadowsocks 

开发模式 把  crx 文件解压  然后 通过加载目录的方式加载 插件 

#==========================================================================
#1. 问题 _ 的目录去掉 
#C:\Users\baoguodong\Desktop\SwitchyOmega (1)
#
#_metadata 
#metadata
#
