#!/usr/bin/perl

#
for(glob("新唐书/*.htm"))
{
	chomp();
	print  <<EOF
#==========================================================================
#总卷名  
get xpath_get_element.pl    $_  /html/body/table/tr[1]/td[2]/table/tr[2]/td/table/tr/td[1]/font/span/em

#分卷
perl xpath_get_element.pl   $_   /html/body/table/tr[2]/td/table/tr/td/font[2]/span    

#百官二
perl xpath_get_element.pl  $_   /html/body/table/tr[2]/td/table/tr/td/p[1]/span[1]/font/strong            

#人名 描述
perl xpath_get_element.pl $_   /html/body/table/tr[2]/td/table/tr/td/p/span[1]/font/strong

EOF
;
}
