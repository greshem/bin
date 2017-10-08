#!/usr/bin/perl

if( ! -f "/tmp3/cran_list.html ")
{
    system("wget  http://mirror.its.dal.ca/cran/web/packages/available_packages_by_name.html -O /tmp3/cran_list.html \n");
#system(" curl  http://mirror.its.dal.ca/cran/web/packages/available_packages_by_name.html \n");
}
else
{
    system(" cat /tmp3/cran_list.html \n");
}

