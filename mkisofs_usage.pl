#!/usr/bin/perl
foreach (grep{-d } glob("*"))
{
	my $name=$_;
	print <<EOF
mkisofs -J -r -hide-rr-moved -hide-joliet-trans-tbl -V $name  -o  $name.iso $name/  
EOF
;
}

