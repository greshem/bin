#!/usr/bin/perl 
# Mailgraph: An postfix/sendmail log file analyzer
#
use Cwd;
use File::Basename;
our $g_pwd= getcwd();
our $g_base=basename($g_pwd);
$output= "/etc/httpd/conf.d/$g_base.conf";


gen_for_http2_2($output."_v2.2");
gen_for_http2_4($output);
print "#注意:  /etc/httpd/conf/httpd.conf 添加 监听端口\n" ;

print ("#$output generated ok \n");
gen_print_env();

##########################################################
sub gen_for_http2_4($)
{
	(my $output)=@_;
    print ("#Generated 2.4  $output \n");
	open(FILE, ">".$output)  or die("open $output error \n");
	print FILE  <<EOF
<VirtualHost *:8888>

Alias /$g_base    $g_pwd
<Directory "$g_pwd">
  Options +Indexes +FollowSymlinks
  AllowOverride All
  Require all granted

#   Options -Indexes
    #AllowOverride All
    #Require all granted

</Directory>
</VirtualHost>

EOF
;
	close(FILE);
}

sub gen_for_http2_2()
{
	(my $output)=@_;
    print ("#Generated 2.2  $output \n");

	open(FILE, ">".$output)  or die("open $output error \n");
	#select(FILE);
	while(<DATA>)
	{
		if(/^Alias/)
		{
			s/__PWD__/$g_pwd/;
			s/__BASEDIR_PWD__/$g_base/;
			print FILE  $_;
		}	
		elsif(/__PWD__\>/)
		{
			s/__PWD__/$g_pwd/;
			print FILE $_;
		}
		else
		{	print FILE  $_;
		}
	}
	close(FILE);
	#select(STDOUT);
}


sub gen_print_env()
{
	open(FILE, ">print_env.pl") or die("open  print_env.pl error \n");
	print FILE <<EOF
#!/usr/bin/perl
print "Content-type: text/html\\n\\n";
foreach \$key (keys %ENV) 
{
print "\$key --> \$ENV{\$key}<br>";
}


EOF
;
	close(FILE);
}

__DATA__
Alias /__BASEDIR_PWD__    __PWD__

<Directory __PWD__>
    Options Indexes MultiViews FollowSymLinks
    AllowOverride None
    Options +ExecCGI
    DirectoryIndex index.php

    Order Deny,Allow
    Allow from all
	AddHandler cgi-script cgi pl
</Directory>


