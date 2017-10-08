#!/usr/bin/perl
get_distfile_list();
if(get_portage_count()==0)
{
	get_portage_tar();
}
else
{
	print ("#OK: /tmp3/*portage.tar* exists \n");
}

#######################################################################
#sub function 
sub get_distfile_list()
{
	
	if(! -f  "/tmp3/distfiles.html")
	{
		print ("wget  http://mirrors.163.com/gentoo/distfiles/ -O /tmp3/distfiles.html ");
		system("wget  http://mirrors.163.com/gentoo/distfiles/ -O /tmp3/distfiles.html ");
	}
	else
	{
		print ("#OK: /tmp3/distfiles.html exists \n");
	}
}


#wget http://mirrors.163.com/gentoo/snapshots/portage-latest.tar.bz2
#$mv portage-latest.tar.bz2  portage-$(/bin/getToday.sh).tar.bz2
sub get_portage_tar()
{
	$snapshot="http://mirrors.163.com/gentoo/snapshots/";
	print " curl  http://mirrors.163.com/gentoo/snapshots/ \n";
	open(PIPE, "curl  http://mirrors.163.com/gentoo/snapshots/ | ")  or die(" open  gentoo  portage url  error \n");
	for(<PIPE>)
	{
		my @array=split(/"/, $_);
		print  "wget ".$snapshot."/".$array[1]."\n";
	}

}

sub get_portage_count()
{
	my @array=glob("/tmp3/*portage*.tar*");
	return scalar(@array);
}



__DATA__

http://mirrors.163.com/gentoo/snapshots/
http://mirrors.163.com/gentoo/distfiles/

DIST gtest-1.6.0.zip 1121697 SHA256 5ec97df8e75b4ee796604e74716d1b50582beba22c5502edd055a7e67a3965d8 SHA512 f4718dfbfa3339bb9449c3f14e5b44ae405ea7df64c10a0957a6300985b71c4642981d069a1382e27ae041a4e2873527a9e442aff978447e795a190f99fac115 WHIRLPOOL 745a49020d4353ed2fa38adfc80bbd777358c831719bbe3b7c90d243f84256615222ba5f04d48d98b9e1a803bb40766799b3aedd575024c19d853d9239a12f8a
DIST gtest-1.7.0.zip 1164254 SHA256 247ca18dd83f53deb1328be17e4b1be31514cedfc1e3424f672bf11fd7e0d60d SHA512 8859369f2dd32cbc2ac01aba029aa3ff20a321f40658b9643aff442d34c33468221866b801b28c66a28af47dbcd362d26941fc98db92b6efb7e41ea5b7be1a07 WHIRLPOOL 0c31a385159551859c1afe76480b3fb1b560d666db9a0afc5cbda92bcd53bf129f85a8f902c6ded0779c2b4c49aacec59ba5a4d5ce316a07bf08174f4fc64049

grep DIST Manifest |awk '{print \$2}' 
