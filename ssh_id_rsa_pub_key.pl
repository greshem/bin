#!/usr/bin/perl 

#use strict;
#use warnings;
gen_id_rsa();
gen_id_rsa_pub();

system(" chmod 400 id_rsa* ");
print "chmod 000 /root/.ssh/id_rsak*  \n ";
#==========================================================================
#private key
sub gen_id_rsa()
{
	open(OUTPUT, ">id_rsa.greshem") or die("create file error\n");
print OUTPUT <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAped8ttQ7P7geyHTZpGz0rb3Lj0FfPukW1VSVm/VOO6Ff1t4n
vgiXolwjSGjs9UX6vwnoBXiU5ovb22/CDyDzxMW+rKtQ1dkMc5MW+djBE+6Mkon7
8k2iISpGGj/2nB25BtuN28O+B1evQgd2Rgxo0kHC97Q1f+TCP0pFAi0xzbqkHwrM
vJ7fEKRexv0W6mwODPcTTEvBi8Eon1yIaFN1FS3R93JGr7T5zkWBauHDBrN3980w
VFsl8onSjUrC72zmZaeFkeQ9HUAghrRQK1CAeGfqGpKI6guvFIy6FDZKxF6nBgEC
K/WyCZtek6kzYxZ90vtCAfWyYTxYmI7YUF4NYQIDAQABAoIBAG5o20/VeETUpO/l
C/7oYAHMgM8qw1dbyk1ZCGQNYe4/XEfj+vD2SOvNg9GpuqEU3GYNErOpZvbzdvLX
sn9c/74hl97T+G0JEMdNyYmnHf/Ezxqq59h+n/qQZq0LinSlN0EAFq193FaInWNF
EgpWMeBT0YwGC2C8/iUeqURkjXOKw0wH/UdHfuvBSo462prcZzbUhstUNF/TyShE
Wr+YG0YC3RsQ0PqxMvFKObUzHaAYkXAm1KJBHuywCxuGM31TCMDcD58yklh7PO+7
V3lbjZ3hLNZC7FWIRl9+vG2h919GzDVbf+9HoVMcLzJgxvPuKQzQflKbHXwCmvMz
rp9z2wECgYEA09M4/EbogbVk3h3WLBbI1i5DSwKisXvXwyNnkhUwJqddRSUeTaKe
eXEBoh9XdK72vqilf6/c9f+32q0M7lxJ/BxIutjMaGGP64EWu2AY0OFa9m+bOJNm
yqOtSRob2BjpudNR1stp6MKozARvuJ7H/1HnK2C9ZZnMmGekGydiihECgYEAyICs
UV72ngsNINxlhdTJt1NcZJsutUKbIc7fdMRGLxc+dmB7nY9C8p4v53IEIR3eRuJY
C2ca1qICMA/M9AJI6IO+c2l+wAxwIfy4uISBy3xE4+TRUpn202iqo66H2arB3JSV
gxBA1yR8B4q/CHuTlCm4Cp0+YVbdNMdlgdp8flECgYBnpSt17TAo/1u6fvjjm8Zr
XjmZA1Id683X8oPj67AiybOOeKoKLK7EFzJIZHODaXTcN2K7Ro6kY5pPSmtQWiHt
VN2VZy0lSc+E2SYJSuz5j7rVaCiYFy+tqUbJxReotg/u1+Jsah2JQW4cXXNY74BG
gonNJMmnZAjC7btTegLyMQKBgQCdGvXq7JYhUFeBIDEMpKdKVq9WxaHbtc0IuKiv
Pfwgef4fk4pI8zBqGzk+CUDjEhxRPpnulWOaOmescTUPHZszVcetd0QyB4z1lKjJ
LErnvv/b8jdymeGl1aWfi+o2zG4LAQIGKH4mFhh5cGYvp2UD+4ySBJQUgZPi/zqy
fRh/gQKBgQCGWV44Dir//ORrMCf3CnNBI545fgnxITwyzjuCNalByghssnRvHZFT
fPDYlIO23BGBxqY8ueb7gBbXexcOQfcszF4XNuRUWDwAoPMafIIs2+X6hOpO6L2b
2lkSl/D5ioAzkSm81J5FDRuVrzg9euTV+m+irU7R6dqv1gX70+2WQA==
-----END RSA PRIVATE KEY-----
EOF
;
close(OUTPUT);
print "#save as id_rsa.greshem\n";
print "mv  id_rsa.greshem /root/.ssh/id_rsa \n";

}

#==========================================================================
#public key
sub gen_id_rsa_pub()
{

	open(OUTPUT, ">id_rsa.pub.greshem") or die("create file error\n");
	print OUTPUT <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl53y21Ds/uB7IdNmkbPStvcuPQV8+6RbVVJWb9U47oV/W3ie+CJeiXCNIaOz1Rfq/CegFeJTmi9vbb8IPIPPExb6sq1DV2Qxzkxb52MET7oySifvyTaIhKkYaP/acHbkG243bw74HV69CB3ZGDGjSQcL3tDV/5MI/SkUCLTHNuqQfCsy8nt8QpF7G/RbqbA4M9xNMS8GLwSifXIhoU3UVLdH3ckavtPnORYFq4cMGs3f3zTBUWyXyidKNSsLvbOZlp4WR5D0dQCCGtFArUIB4Z+oakojqC68UjLoUNkrEXqcGAQIr9bIJm16TqTNjFn3S+0IB9bJhPFiYjthQXg1h root@acer
EOF
;	
print "#save as id_rsa.pub.greshem\n";
print "mv id_rsa.pub.greshem /root/.ssh/id_rsa.pub \n";
system(" cat  id_rsa.pub.greshem   >> /root/.ssh/authorized_keys ");
}
