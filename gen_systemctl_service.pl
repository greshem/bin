
my $name=shift or die("Usage: $0 input_serveice \n");
gen_service($name);

sub gen_service($)
{
    (my $name)=@_;

    my $output="/lib/systemd/system/$name.service";
    open(FILE, ">$output") or die("create  file error \n");
print FILE  <<EOF
[Unit]  
Description=$name  
After=network.target  

[Service]  
Type=forking  
ExecStart=/root/bin/logger$name.pl   start  
ExecReload=/www/lanmps/init.d/$name restart  
ExecStop=/www/lanmps/init.d/$name  stop  
PrivateTmp=true  

[Install]  
WantedBy=multi-user.target  

EOF
;
    close(FILE);
    
}
