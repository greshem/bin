#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

yum install     supervisor
systemctl restart  supervisor

cat > /etc/supervisord.d/my.ini <<EOF
[program:dbqs]
autorestart = true
stopwaitsecs = 600
command =     python -m SimpleHTTPServer 33446 /root  
autostart = true
log_stdout = true
log_stderr = true
logfile_maxbytes = 50MB
logfile_backups = 10
stdout_logfile=/tmp/output.log
EOF
;

# lsof -i:33446 
