#!/usr/bin/perl
$file=$ARGV[0];
if($file!~/tar.gz$/ || ! -f $file)
{
	die "Error , should be tar.gz file\n";

}
our ($name)=($file=~/(.*).tar.gz$/);

$root_dir=`tar -tzf $file |awk -F\/  '{print \$1}'|sort|uniq`;
@root_dirs=split(/\n/, $root_dir);
if( (scalar(@root_dirs) eq 1 ) && $root_dirs[0] eq ".")
{
	print " serious problem \n";
	print " all file in first depth\n";
	mkdir($name);
	`tar -xzf $file -C $name`;
	`tar -czf $file $name`;
	if ($name!~/^\./)
	{
		print "rm $name\n";
		`rm -rf $name`
	} 
	exit(1);	

}
elsif ( scalar(@root_dirs) gt 1)
{
	print "serious problem 222 \n";
	print " first depth have > two dirs , should be one\n";
	mkdir($name);
	`tar -xzvf $file -C $name`;
	`tar -czf $file $name`;
	if ($name!~/^\./)
	{
		print "rm $name\n";
		`rm -rf $name`
	} 
	exit(2);
}
else
{
	print $file ,"\t OK  DIR = $root_dirs[0]\n";
}
print "success\n";
exit(0);
