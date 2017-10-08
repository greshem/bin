#!/usr/bin/perl
#2012_05_23   星期三   add by greshem
#生成perl的脚本, 根据 cygwin 的一个 注册表的路径.
$path= "/proc/registry/HKEY_CURRENT_USER/Environment";
@path=`find   $path  -type d     `;

for (@path)
{
	chomp;
	$reg_path=$_;
	$reg_path=~s/\/proc\/registry//;
	@sub_value= `find  $path  -type f  `;
	@values=map{chomp;s/$path\///;$_;} @sub_value;

	($root_path,$sub_path)=($reg_path=~/(HKEY_CURRENT_USER)\/(.*)/);
	print <<EOF
use Win32::Registry;
my \$Register = "$sub_path";
my \$hkey;
\$$root_path->Open(\$Register,\$hkey)|| die $^E;
undef \$garbage;
EOF
;

	for(@values)
	{
		print <<EOF
\$hkey->SetValueEx("$_",\$garbage,REG_SZ,"string");
EOF
;
	}	
}
print <<EOF
\$hkey->Close();
EOF
;
#; do echo regtool get $each; done
#for each in $(find $(pwd) -type f   |sed 's|/proc/registry||'   ); do echo regtool get $each; done

########################################################################



#$HKEY_LOCAL_MACHINE->Open($Register,$hkey)|| die $^E;
#$HKEY_LOCAL_MACHINE->Create($Register,$hkey)|| die($!);
