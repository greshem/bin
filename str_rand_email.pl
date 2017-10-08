#!/usr/bin/perl
  use String::Random;
  $foo = new String::Random;
  $addr= $foo->randregex("[a-z]{3,7}@[a-z]{3,7}"); # Prints 3 random digits
	print $addr=$addr.".com";

  #print $foo->randpattern("..."),"\n";  # Prints 3 random printable characters


