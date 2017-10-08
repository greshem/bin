#!/usr/bin/perl
for (glob("*.flac"))
{
	system("flac -d \"$_\" ");
	my $wav=$_;
	$wav=~s/flac$/wav/g;
	system("lame \"$wav\" ");
	unlink($wav);
}
