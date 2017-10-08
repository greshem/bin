#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

short_open_tag = On
; Allow ASP-style <% %> tags.
asp_tags = Off

display_errors = Off

upload_max_filesize = 2M
max_execution_time = 300  


