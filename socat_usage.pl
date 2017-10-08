#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
socat TCP4-LISTEN:1234,reuseaddr,fork, TCP4:localhost:80
socat TCP4-LISTEN:5672,reuseaddr,fork, TCP4:localhost:22

#bind  will not conflict with    localhost:bind 
socat TCP4-LISTEN:7777,bind=192.168.1.48,reuseaddr,fork, TCP4:localhost:7777
socat TCP4-LISTEN:7776,bind=192.168.1.48,reuseaddr,fork, TCP4:localhost:7776
socat TCP4-LISTEN:7775,bind=192.168.1.48,reuseaddr,fork, TCP4:localhost:7775
socat TCP4-LISTEN:7774,bind=192.168.1.48,reuseaddr,fork, TCP4:localhost:7774
socat TCP4-LISTEN:7773,bind=192.168.1.48,reuseaddr,fork, TCP4:localhost:7773

socat TCP4-LISTEN:8889,bind=192.168.1.48,reuseaddr,fork, TCP4:localhost:8889

socat TCP4-LISTEN:8890,bind=192.168.1.48,reuseaddr,fork, TCP4:localhost:8890

echo "uname " |  socat -  TCP:192.168.1.48:8889 
