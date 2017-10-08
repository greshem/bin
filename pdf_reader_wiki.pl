#!/usr/bin/perl

for (glob("*.pdf"))
{
	print <<EOF
apvlv $_  #vim liked pdf reader
EOF
;
}
