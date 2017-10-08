#!/usr/bin/perl
do("c:\\bin\\iso_get_mobile_disk_label.pl");
my $disk=change_mobile_path_to_win_path('sdb1');
print "eden sdb1:\\  ->  $disk \n";

