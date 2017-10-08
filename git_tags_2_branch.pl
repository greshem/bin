#!/usr/bin/perl
open(PIPE, "git tag|") or die("git  tags error \n");;
for (<PIPE>)
{
	chomp;
	print "\n#".$_."\n";;
	print " git checkout --no-track -b branch_$_ $_ -- \n";

	print "virtualenv --no-site-packages /root/venv/$_      \n";
	print " source /root/venv/$_/bin/activate \n";
	print <<EOF
	pip install   --trusted-host  pypi.douban.com  -i http://pypi.douban.com/simple/     -r  requirements.txt 
EOF
;

}
