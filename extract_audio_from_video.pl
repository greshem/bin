#!/usr/bin/perl
#mplayer AVSEQ07_ʮ��Сӡ�ڰ���.DAT  -novideo -ao pcm
#���� Ǯ�ȳ̵ĸ��ٵĹ��̵�ʱ�� ʱ�����������.
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
#����˹�Ĵ���ʽ.  cctv1 
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
#��������ħ��ʯ �Ĵ���ʽ 
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
