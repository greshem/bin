#!/usr/bin/perl

#
for(glob("������/*.htm"))
{
	chomp();
	print  <<EOF
#==========================================================================
#�ܾ���  
get xpath_get_element.pl    $_  /html/body/table/tr[1]/td[2]/table/tr[2]/td/table/tr/td[1]/font/span/em

#�־�
perl xpath_get_element.pl   $_   /html/body/table/tr[2]/td/table/tr/td/font[2]/span    

#�ٹٶ�
perl xpath_get_element.pl  $_   /html/body/table/tr[2]/td/table/tr/td/p[1]/span[1]/font/strong            

#���� ����
perl xpath_get_element.pl $_   /html/body/table/tr[2]/td/table/tr/td/p/span[1]/font/strong

EOF
;
}
