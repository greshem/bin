#!/usr/bin/perl -w
#20100104 添加LmyUnitcode的支持。 默认的路径是 /tmp2
#

use strict;

my %OBJS;
my $EXEC;
my %COMP;
my %SUFFIX;
my $LIBS = "";
my $LINES = 0;
my $CFFLAGS = "";
sub DeSuffix
{
my ($file,$suffix) = @_;
#print "$file->$suffix\n";

$file =~ s/.$suffix$//i
   or die "Can not desuffix $suffix from $file";
#print "$file->$suffix\n";

return $file;
}

sub GetObjName
{
my ($obj,$suffix) = @_;
$obj =DeSuffix($obj,$suffix) . ".o";
return $obj;
}

sub GetCppName
{
my ($cpp,$suffix) = @_;
$cpp =DeSuffix($cpp,$suffix) . ".cpp";
return $cpp;
}

sub GetCName
{
my ($cpp,$suffix) = @_;
$cpp =DeSuffix($cpp,$suffix) . ".c";
return $cpp;
}

sub AddToCOMP
{
my($obj, $file) = @_;
unless( defined($COMP{$obj}) and $COMP{$obj} =~ /$file/)
{
   $COMP{$obj} .= " " . $file if -e $file;
}

}
sub AddBoostLIB
{
my($boostlib) = @_;
unless( defined($LIBS) and $LIBS =~ /$boostlib/)
{
   my $boostlibpath = "/usr/lib/libboost_$boostlib.so";
   #$LIBS .= " " . $boostlib if -e $boostlibpath;

   $LIBS .= " -lboost_" . $boostlib if -e $boostlibpath;
}

#print $boostlib . "\n";

}
sub ParseFile
{
my ($filename, $suffix) = @_;

open CODE, "< $_" or die "Can not open $_($!)";

my $obj = &GetObjName($filename, $suffix);
$OBJS{$obj} = 1 if($suffix ne "h");
&AddToCOMP($obj, $filename) if ($suffix ne "h");
$SUFFIX{$obj} = $suffix if($suffix ne "h");
#print "$obj:";


while(<CODE>)
{
   ++$LINES;
   #Parsing main

   if(/(main|ACE_TMAIN)\s*\(.*/)
   {
		my $main = &DeSuffix($filename,$suffix);
		if(defined($EXEC))
		{	
			warn "一个目录下有两个MAIN文件了\n";
			die "Duplicate main():$EXEC $main";
			print "main files ", $main,"\n";
		}
		$EXEC = $main;
   }
   #Parsing #include "*.h"

   if(/#\s*include\s*"(\w+.h)"/)

   {
    #print $1;

    &AddToCOMP($obj,$1);
    &AddToCOMP($obj, GetCppName($1,"h"));
   }
   #Parsing boost

   #if(/#\s*inlcude\s*<boost/(\w+).h>/)

   if(/#\s*include\s*<boost.*\/(.+).hpp/)

   {
    &AddBoostLIB($1);
   }
   if(/#\s*include\s*<boost\/(.+)\/.+.hpp/)

   {
    &AddBoostLIB($1);
   }
   if(/#\s*include\s*<ace\/(.+).h/)

   {
    #print "ace\n";

    unless( defined($LIBS) and $LIBS =~ /lACE/)
    {

     $LIBS .= " -lACE";
    }
    unless ( $CFFLAGS =~ /-I\$\(ACE_ROOT\)/)
    {
     $CFFLAGS .= " -I\$(ACE_ROOT)";
    }
   }
   if(/#\s*include\s*<(tinyxml|FMConfig).h/)
   {
    #print "ace\n";

    unless( defined($LIBS) and $LIBS =~ /ltinyxml/)
    {

     $LIBS .= " -ltinyxml";
    }
   }
	
   if(/#\s*include\s*<MLmyUnit.hpp/)
   {
	$LIBS.=" -lUnitLib -L/tmp2/LmyUnit/UnitLib -lpthread";
	$CFFLAGS.="-I /tmp2/LmyUnit/UnitLib/UnitCode  ";
   }
   if(/#\s*include\s*<(descramble).h/)

   {
    #print "scramble\n";

    unless( defined($LIBS) and $LIBS =~ /ldescramble/)
    {

     $LIBS .= " -ldescramble";
    }
   }
}
close CODE;
}

#generate makefile

sub WriteMakefile
{
unlink "makefile" or die "Can not rm makefile ($!)" if -e "makefile";
open MAKEFILE, ">Makefile" or die "Can not open makefile";
select MAKEFILE;
print "CC = g++\n";
if(defined($EXEC))
{
   print "EXEC = $EXEC\n";
}
else
{
   print "EXEC = \n";
   warn "No main\n";
}

print "OBJS = ";
foreach( keys %OBJS)
{
   print $_ . " ";
}
print "\n";
print "CFLAGS +=$CFFLAGS\n";
print "LDFLAGS += \n";
print "LIBS +=$LIBS\n";
print "\n";

print 'all: $(EXEC)' . "\n";
print '$(EXEC): $(OBJS)' . "\n";
print "\t" . '$(CC) $(LDFLAGS) -o $(EXEC) $(OBJS) $(LIBS)' . "\n";
print "\n";

while(my($key,$value) = each %COMP)
{
   print "$key:$value\n";
   my $name;
   if($SUFFIX{$key} eq "cpp")
   {
    $name = GetCppName($key,"o");
   }
   else
   {
    $name = GetCName($key,"o");
   }
   print "\t" . '$(CC) $(CFLAGS) -c ' . "$name\n";
   print "\t" . '$(CC) -S  ' . "$name\n";
   print "\n";
}

print "\n";
print "clean:\n";
print "\t" . '-rm -f $(EXEC) *.o' . "\n";
close MAKEFILE;
select STDIN;
}
foreach(glob "*.cpp")
{
&ParseFile($_,"cpp");
}

foreach(glob "*.h")
{
&ParseFile($_,"h");
}
foreach(glob "*.c")
{
&ParseFile($_,"c");
}
print "Total lines:" . $LINES . "\n";
&WriteMakefile;
