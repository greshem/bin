#!/usr/bin/perl
#mplayer AVSEQ07_十个小印第安人.DAT  -novideo -ao pcm
#处理 钱奕程的钢琴的光盘的时候 时候整理出来的.
sub encode_with_paint()
{
	for $each (glob("*.DAT"))
	{
	print <<EOF
	mplayer $each  -novideo -ao pcm
	oggenc   audiodump.wav 
	lame -V2 audiodump.wav    ${each}.mp3
	mv  audiodump.ogg  ${each}.ogg
EOF
;

	}
}

#==========================================================================
#托马斯的处理方式.  cctv1 
sub encode_with_thomash()
{
	for $each (glob("*.avi"))
	{
	print <<EOF
	mplayer $each -ao pcm:file=audiodump.wav -vo null
	lame -V2 audiodump.wav    ${each}.mp3
EOF
;

	}
}

#==========================================================================
#哈利波特魔法石 的处理方式 
sub encode_with_rm()
{
	for $each (glob("*.rm"))
	{
	print <<EOF
	mplayer $each -ao pcm:file=audiodump.wav -vo null
	lame -V2 audiodump.wav    ${each}.mp3
EOF
;

	}
}

sub encode_with_wma()
{
	for $each (glob("*.wma"))
	{
	print <<EOF
	mplayer $each  -novideo -ao pcm
	lame -V2 audiodump.wav    ${each}.mp3
EOF
;

	}
}



#encode_with_rm();
#encode_with_thomash();
encode_with_paint();
encode_with_wma();
