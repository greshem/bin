#!/usr/bin/perl
$input_dir=shift or die("Usage: input_dir \n");

print ("mv $input_dir ${input_dir}_1of2 \n");
print ("mkdir  ${input_dir}_2of2  \n");
print ("mkdir  ${input_dir}_2of2/arch/  \n");
print ("mkdir  ${input_dir}_2of2/drivers/  \n");


for $each (qw( alpha arm26 avr32 cris frv h8300 m32r m68k m68knommu mips parisc ppc s390 sh sh64 sparc sparc64 um v850 x86_64 xtensa))
{
	if( -d "${input_dir}_1of2/arch/$each")
	{
		print " mv ${input_dir}_1of2/arch/$each   ${input_dir}_2of2/arch/  \n";
	}

}

for $each   (qw(  ./acorn ./amba ./atm ./bluetooth ./clocksource ./connector ./cpufreq ./dio ./edac ./fc4 ./firmware ./hid ./hwmon ./i2c ./ieee1394 ./infiniband ./isdn ./leds ./macintosh ./mca ./md ./media ./message ./mfd ./misc ./mmc ./mtd ./nubus ./oprofile ./parisc ./parport ./pcmcia ./ps3 ./rapidio ./rtc ./s390 ./sbus ./sh ./sn ./spi ./tc ./telephony ./w1 ./zorro))

{
	if( -d "${input_dir}_1of2/drivers/$each")
	{
		print " mv ${input_dir}_1of2/drivers/$each   ${input_dir}_2of2/drivers/  \n";
	}
}



