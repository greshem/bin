#!/usr/bin/perl
my $keyword=shift or usage();

print <<EOF
	http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=$keyword 
EOF
;

sub usage()
{
	print <<EOF
Usage:  $0 input_keyword 
Example: 
	http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=ssh
	http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=openssh

	##(官方数据源) MITRE
	http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-0792

	#(官方数据源) NVD
	http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2013-0792

	#(官方数据源) CNNVD	
	http://www.cnnvd.org.cn/vulnerability/show/cv_cnnvdid/CNNVD-201304-04

EOF
;
	die("\n");
}

