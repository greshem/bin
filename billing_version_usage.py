#!/usr/bin/python
#coding=utf-8
DATA="""
#####################################################################
mv billing-1.0.0-1.el7.centos.noarch  		billing
mv billing-frozen-1.0.0-1.el7.centos.noarch   	billing-frozen

mv billing_payment-1.0.0-1.el7.centos.noarch   	billing_payment
mv billing_web-1.0.0-1.el7.centos.noarch  	billing_web
mv python-billing-1.0.0-1.el7.centos.noarch     python-billing
mv python-billing-frozen-1.0.0-1.el7.centos.noarch  python-billing-frozen



#####################################################################
/root/bin/for_each_dir.pl   " cpio  -ivmd  <   *.cpio "


#####################################################################
grep  "Created on" -R ./ -n  -l  |grep py$  > /tmp/tmp
for each in $(cat /tmp/tmp) ; 
do 
	sed '/Created on/d'  -i  $each; 
done


#####################################################################
#baoguodong.kevin

grep  "baoguodong.kevin" -R ./ -n  -l |grep py$  > /tmp/tmp

for each in $(cat /tmp/tmp) ; 
do 
	sed '/baoguodong.kevin/d'  -i  $each; 
done

########################################################################
grep  "baoguodong.kevin" -R ./ -n  -l   > /tmp/tmp
for each in $(cat /tmp/tmp) ;  do  sed '/baoguodong.kevin/d'  -i  $each;  done

########################################################################
grep  "syscloud" -R ./ -n  -l  > /tmp/tmp
for each in $(cat /tmp/tmp) ;  do  sed 's/syscloud/wzcloud/g'  -i  $each;  done

########################################################################
grep  "Syscloud" -R ./ -n  -l   > /tmp/tmp
for each in $(cat /tmp/tmp) ;  do  sed 's/Syscloud/Wzcloud/g'  -i  $each;  done

########################################################################
grep  "犀思云" -R ./ -n  -l  > /tmp/tmp
for each in $(cat /tmp/tmp) ;  do  sed 's/犀思云/微烛云/g'  -i  $each;  done

grep  "犀思" -R ./ -n  -l  > /tmp/tmp
for each in $(cat /tmp/tmp) ;  do  sed 's/犀思/微烛云/g'  -i  $each;  done


"""
print DATA;
