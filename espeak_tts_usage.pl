#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__
#==========================================================================
#这个包已经有中文语言了>
https://downloads.sourceforge.net/project/e-guidedog/eSpeak-Chinese/1.47.11/espeak-1.47.11-source.tar.xz


cdd linux_src/
tar -xJf espeak-1.47.11-source.tar.xz
cd espeak-1.47.11-source/
cd src/
make
make install

espeak -vzh  钱奕程是个傻瓜   -w /tmp/60000.wav

#==========================================================================
#
/root/voice/Linux_voice_1135_570b6a73.zip
/root/voice/bin/tts_sample  , 运行生成  语音wav 
