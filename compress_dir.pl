
#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#-r ตÝน้
zip -r  output.zip dir1 dir2 dir3 
#a append
rar a output.rar dir1 dir2  dir3 
#back_dir.pl 

tar -czf input_dir.tar.gz    input_dir

