#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
rec  -r 16000  -c 1 -b 16    ddd.wav   #科大讯飞。

arecord -D "plughw:1,0" -d 5 file.wav
rec file.wav
rec -r 44100 -4 -u -c2 -t mp3 test.mp3



