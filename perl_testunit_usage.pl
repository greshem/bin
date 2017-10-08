#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#!/usr/bin/perl -w

use Test::More tests => 70;

($x, $y) = (60, 40);
ok(($x == 60 && $y == 40), 'test1');

$html = 'width="52"  height="54"';;
ok(($html =~ /width="52"\s+height="54"/oi), 'Test2');

@attrs = (0, 64, 33, 38);
ok(($attrs[1] == 64 && $attrs[3] == 38), 'Test 333');

($x, $y) = (50, 10);
ok(($x == 50 && $y == 10), 'test4 ');

($x, $y, $err) = (10, 10, "can not open");
ok(($err =~ /can\s+not\s+open/oi), 'Test 5 ');


($x, $y) = (333, 194);
ok(($x == 333 && $y == 194), 'Test 6');

($x, $y) = (90, 60);
ok(($x == 90 && $y == 60), 'test 7');

is("aaa", "aaa");
isnt("aaa", "bbb");

exit;

