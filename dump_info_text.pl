#!/usr/bin/perl
#Time=91645, Title=(600109)������֤ȯ�������ش������..., Path=shmsg1.txt, Offset=11361, Length=273
while(<STDIN>)
{
	#if(/Path\=(.*)\,\s+Offset\=([0-9]+)\,\s+Length\=([0-9]+/)
	if(/Title=(.*), Path=(.*), Offset\=(.*), Length=(.*)$/)
	{
		print "dd if=",$2," skip=",$3," bs=1 ","count=",$4,"  #",$1,"\n"
	}
}
