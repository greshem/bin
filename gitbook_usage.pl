#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
cd /root
git clone https://github.com/tobegit3hub/understand_linux_process.git

rm   /root/understand_linux_process/book.json 

docker run -it  -p 33443:4000 -v  /root/understand_linux_process/:/srv/gitbook  fellah/gitbook 
