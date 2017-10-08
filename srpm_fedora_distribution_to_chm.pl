#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
1. wget all,   from   srpm. 
2.  move big file , to ../SRPM_BIG, donot deal with it, or deal with it and end. 
	mkdir ../perl_SRPM	, don't deal with perl package, it all have deal with in cpan.
	

2. change  srpm 2 tar.gz 
	for_each_dir.pl /bin/unpack_all_2_targz_dir_usage.pl 

3. fork  SRPMS  to   SRPMS_extract_to_chm dir,  save all the rpm2targz package. 
	SRPMS save as small_SRPMS 


#$3. unpack all  
	a. change xz tbz2 gz lama  to tar.gz 
	b. 

#4.  extract all tar.gz  tar.bz2, tbz2 ,  xz  file 

6. 	for_each_dir.pl  "/bin/judge_input_dev_lang.pl . "

7. 	mv /var/log/dev_lang_*.pl  , to cur dir 

	
#8. 
for each in $(dir *.log )
do
	echo mkdir ${each%%.log} 
	mv $(cat $each ) ${each%%.log}
done 

#9.  ruby 
cur_dir judge out what's the develop language it is, and then create the chm.


