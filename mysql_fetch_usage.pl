#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#php  connect 
resource mysql_connect ( [string server [, string username [, string password [, bool new_link [, int client_flags]]]]])

#get data
array 	mysql_fetch_array 	( resource result [, int result_type])
array 	mysql_fetch_assoc 	( resource result)
array 	mysql_fetch_row 	( resource result)
object 	mysql_fetch_field 	( resource result [, int field_offset])
object 	mysql_fetch_object 	( resource result)

