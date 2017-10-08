#!/usr/bin/perl
use CPAN;
#use List::MoreUtils qw(shuffle);
use List::Util qw(shuffle);
$CPAN::DEBUG=1;
# @a=CPAN::Shell->expand("Module","/Math::Random/");                      
# @a=CPAN::Shell->expand("Module","/Math::/");                      
 #@a=CPAN::Shell->expand("Module","/Digest::/");                      
# @a=CPAN::Shell->expand("Module","/Template::/");                      
 @a=CPAN::Shell->expand("Module","/./");                      
@b=shuffle @a;
@c=@b[1..100];
for ( @b[1..100] )
{
#	$_->force();
 CPAN::Module::force($_);
   CPAN::Shell->expand('Module',  $_->{ID})->install(); 
#	print $_->{ID},"\n";
}
