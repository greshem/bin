#!/usr/bin/perl 

use Cwd;

my $name="aquatic-pond.com";
my $name2="www.aquatic-pond.com";
my $name3="mail.aquatic-pond.com";
my $pwd=  getcwd();

print_virual_host($name);
print_virual_host($name2);
print_virual_host($name3);

sub print_virual_host($$)
{

	(my $name)=@_;
	print <<EOF
#这个选项一定要开启 
NameVirtualHost *:80

<VirtualHost  *:80>  
#        ServerAdmin admin\@$name
    	DocumentRoot  /var/www/html/$name        
#根据这个域名来实现dispatch
	ServerName $name 
        ErrorLog logs/${name}_error_log.txt  
        CustomLog logs/${name}_log.txt common  
</VirtualHost>  
EOF
;
print "#perl $0  >> /etc/httpd/conf/httpd.conf  \n";
print "#echo   127.0.0.1  $name   >> /etc/hosts \n";


}
