#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

packstack  --allinone --provision-demo
packstack  --gen-answer-file=answer_file.conf
packstack  --answer-file=answer_file.conf

