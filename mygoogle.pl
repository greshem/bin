#!/usr/bin/perl
############################################################################
#			MyGoogle v. 0.5 by Mikispag			   #
############################################################################
############################################################################
#    Copyright (C) 2004-2005 by Michele Spagnuolo                          #
#    mikispag@gmail.com	                                                   #
#                                                                          #
#    This program is free software; you can redistribute it and/or modify  #
#    it under the terms of the GNU General Public License as published by  #
#    the Free Software Foundation; either version 2 of the License, or     #
#    (at your option) any later version.                                   #
#                                                                          #
#    This program is distributed in the hope that it will be useful,       #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#    GNU General Public License for more details.                          #
#                                                                          #
#    You should have received a copy of the GNU General Public License     #
#    along with this program; if not, write to the                         #
#    Free Software Foundation, Inc.,                                       #
#    59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #
############################################################################

use LWP::UserAgent;

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$mon++;
$year = $year + 1900;
$program = $0;
$program =~ s/(.+)\///g;

$version = '0.4';

if ($min < 10) {$min = '0' . $min;}

#####################################################################################################################
#						C	o	d	e					    #
#####################################################################################################################

if (@ARGV == 0) {
	print ("MyGoogle by Mikispag v. $version\n\n");
	print ("Usage:\n\n");
	print ("$program -n[n. results (1 - 99)] -l[language (it, en, de, fr, etc.)] query (max 4 words - separated by SPACE)\n\n");
	print ("-n, -l and -d are optionals and they can be in any order: by default the program uses -n5 and searches in all the web\n\nOptions:\n");
	print ("-n\tNumbers of results printed.\n");
	print ("-l\tLanguage: you can enter a particular language by typing its code (en for English, it for Italian, fr for French, etc.).\n");
	print ("-i\tTell the program that the input is from the Standard Input (STDIN). This option is useful in concatenating commands (for example: cat word.txt | $program -i).\n");
	print ("-d\tDefine mode: the program searches for a definition of the word passed by argument.\n\n");
	print ("Example:\n\n");
	print ("$program -n50 -lit linux\nprints the first 50 results in Italian language\n");
	print ("$program -d ostracismo\nprints the definition of the word 'ostracismo'\n");
	print ("$program -d -len penguin\nprints the definition of the word 'penguin' in English language\n");
	exit;
}

if (@ARGV == 1) {$query = $ARGV[0]; $count= '-n5 '; $lang= '-l ';}

if (@ARGV == 2) {$query = $ARGV[1];
		if ($ARGV[0] =~ /^-n/) {$count = $ARGV[0] . ' '; $lang = '-l ';}
		if ($ARGV[0] =~ /^-l/) {$lang = $ARGV[0] . ' '; $count = '-n5 ';}
			}

if (@ARGV == 3) {$query = $ARGV[2];
		if ($ARGV[0] =~ /^-n/) {$count = $ARGV[0] . ' '; $lang = '-l ';}
		if ($ARGV[0] =~ /^-l/) {$lang = $ARGV[0] . ' '; $count = '-n5 ';}
		if ($ARGV[1] =~ /^-n/) {$count = $ARGV[1] . ' ';}
		if ($ARGV[1] =~ /^-l/) {$lang = $ARGV[1] . ' ';}
			}

if (@ARGV == 4) {$query = $ARGV[2] . "+" . $ARGV[3];
		if ($ARGV[0] =~ /^-n/) {$count = $ARGV[0] . ' '; $lang = '-l ';}
		if ($ARGV[0] =~ /^-l/) {$lang = $ARGV[0] . ' '; $count = '-n5 ';}
		if ($ARGV[1] =~ /^-n/) {$count = $ARGV[1] . ' ';}
		if ($ARGV[1] =~ /^-l/) {$lang = $ARGV[1] . ' ';}
			}

if (@ARGV == 5) {$query = $ARGV[2] . "+" . $ARGV[3] . "+" . $ARGV[4];
		if ($ARGV[0] =~ /^-n/) {$count = $ARGV[0] . ' '; $lang = '-l ';}
		if ($ARGV[0] =~ /^-l/) {$lang = $ARGV[0] . ' '; $count = '-n5 ';}
		if ($ARGV[1] =~ /^-n/) {$count = $ARGV[1] . ' ';}
		if ($ARGV[1] =~ /^-l/) {$lang = $ARGV[1] . ' ';}
			}

if (@ARGV == 6) {$query = $ARGV[2] . "+" . $ARGV[3] . "+" . $ARGV[4] . "+" . $ARGV[5];
		if ($ARGV[0] =~ /^-n/) {$count = $ARGV[0] . ' '; $lang = '-l ';}
		if ($ARGV[0] =~ /^-l/) {$lang = $ARGV[0] . ' '; $count = '-n5 ';}
		if ($ARGV[1] =~ /^-n/) {$count = $ARGV[1] . ' ';}
		if ($ARGV[1] =~ /^-l/) {$lang = $ARGV[1] . ' ';}
			}


if ($ARGV[0] eq '-i') {$query = <STDIN>;
		if ($ARGV[1] =~ /^-n/) {$count = $ARGV[1] . ' '; $lang = '-l ';}
		if ($ARGV[1] =~ /^-l/) {$lang = $ARGV[1] . ' '; $count = '-n5 ';}
		if ($ARGV[2] =~ /^-n/) {$count = $ARGV[2] . ' ';}
		if ($ARGV[2] =~ /^-l/) {$lang = $ARGV[2] . ' ';}
			}

if ($ARGV[0] eq '-d') {
		if ($ARGV[1] =~ /^-n/) {$count = $ARGV[1] . ' '; $lang = '-len '; $query = $ARGV[2] . "+" . $ARGV[3] . "+" . $ARGV[4] . "+" . $ARGV[5];}
		if ($ARGV[1] =~ /^-l/) {$lang = $ARGV[1] . ' '; $count = '-n5 '; $query = $ARGV[2] . "+" . $ARGV[3] . "+" . $ARGV[4] . "+" . $ARGV[5];}
		if ($ARGV[2] =~ /^-n/) {$count = $ARGV[2] . ' '; $query = $ARGV[3] . "+" . $ARGV[4] . "+" . $ARGV[5] . "+" . $ARGV[6];}
		if ($ARGV[2] =~ /^-l/) {$lang = $ARGV[2] . ' '; $query = $ARGV[3] . "+" . $ARGV[4] . "+" . $ARGV[5] . "+" . $ARGV[6];}
			}


$query =~ tr/ /+/;

$tmp = $count . $lang . $query;

($count, $lang, $query) = split(/ /, $tmp, 3);

if ($count =~ /.*?\-n(\d{1,2}).*?/) {
	$c = $1;
}
else {$c = 5;}

if ($lang =~ /.*?\-l(\w{1,2}).*?/) {
	$l = $1;
}
else {$l = '';}

$url = "http://www.google.com/search?lr=lang_$l&ie=iso-8859-1&oe=iso-8859-1&num=100&q=";

if ($ARGV[0] eq '-d') {$url = "http://www.google.com/search?defl=$l&ie=iso-8859-1&oe=iso-8859-1&q=define:";
if ($query eq '') {$query = $ARGV[1] . "+". $ARGV[2] . "+" . $ARGV[3] . "+" . $ARGV[4];}}

$i = 0;

	$agent = new LWP::UserAgent;
	$request = new HTTP::Request ("GET", $url . $query);
	$agent -> agent ("Netscape 4.78/U.S., 25-Jun-01; (c) 1995-2000");
	$buf = $agent -> request ($request);
	$buf = $buf -> content;

# Definition mode: only one word allowed. If you have some problems with accented letters like à è etc. please switch to an ISO (european) encode.

if ($ARGV[0] eq '-d') {
	print ("Searching definitions on Google ($mday/$mon/$year $hour:$min:$sec)\n\n"); 

	while (($buf =~ m/<li>(.*)/gi) && ($i < $c)) {
		$temp = $1;
		$temp =~ s/<li>|<br>/\n/g;
		$temp =~ s/&quot;/'/g;
		$temp =~ s/&#39;/'/g;
		$temp =~ s/<(.*)>|&nbsp;//g;
	#	$temp =~ s/\n//g;
		
		print ("$temp\n");
		$i++;
	}
	if ($i == 0) {print ("No matches.");}
	print ("\nSearch made with MyGoogle $version (http://mygoogle.sourceforge.net)\n");
}

else {
	print ("Searching on Google (parameters: language |$l|, number of results |$c|, $mday/$mon/$year $hour:$min:$sec)\n\n"); 

	#print $buf;
	print "1111111111111111111\n";

	while (($buf =~ m/<span class=a>(.+?)\s\-\s/gi) && ($i < $c)) {
		$temp = $1;
		$temp =~ s/<.+>//g;
		$temp =~ s/<span dir=litr>|<\/span>//g;
		$temp =~ s/&amp;/&/g;
		$temp =~ s/https:\/\/| //g;
		print ("http:\/\/$temp\n");
		$i++;
		print "#############################\n";
	}
	if ($i == 0) {print ("No matches.");}
	print ("\nSearch made with MyGoogle $version (http://mygoogle.sourceforge.net)\n");
}
