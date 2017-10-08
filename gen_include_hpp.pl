#!/usr/bin/perl
foreach (glob("*.hpp"))
{
	print "#include \"".$_."\"\n";
}

foreach (glob("*.h"))
{
	print "#include \"".$_."\"\n";
}

foreach (glob("*.hh"))
{
	print "#include \"".$_."\"\n";
}
