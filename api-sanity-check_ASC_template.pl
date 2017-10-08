#!/usr/bin/perl



use File::Basename;
$pwd= getpwd();
#print basename("/root/linux/bbb"); #½á¹ûÊÇ. bbb
$targetname=basename($pwd);
gen_xml($targetname);
gen_one_step($targetname);

########################################################################
#sub prog 
sub gen_xml($)
{
	(my $name)=@_;
	if( -f $name.".xml")
	{
		warn("$name.xml have exists , return \n");
		return ;
	}
	my $pwd= getpwd();
	open(FILE, "> $name.xml") or die("create $name.xml error , $!\n");
print FILE  <<EOF
<version>
	1.0.0
</version>

<headers>
/usr/include/$name/
</headers>

<libs>
/usr/lib/$name.so
</libs>

$pwd 

EOF
;

	close(FILE);
}
#==========================================================================
sub getpwd()
{
	use Cwd;
	$pwd=getcwd();
	print $pwd."\n";;
	return $pwd;
}
#==========================================================================
sub gen_one_step($)
{
	(my $name)=@_;	
	if ( -f "one_setp_$name.sh")
	{
		warn(" one_setp_$name.sh, have exists ,  return \n");
		return;
	}
	open(FILE, "> one_setp_$name.sh") or die("create one_setp.sh error, $!\n");
	print FILE <<EOF
api-sanity-checker -lib $name -d $name.xml  -gen 
api-sanity-checker -lib $name -d $name.xml  -build
api-sanity-checker -lib $name -d $name.xml  -run
EOF
;

}
