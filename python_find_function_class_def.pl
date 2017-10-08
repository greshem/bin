#!/usr/bin/perl
my $path=   shift; 
my $pattern=shift; 

#@array= `find /etc/ |grep py\$  `;
#@array= `find /etc/ |grep py\$  `;
@array=   `find $path |grep py\$`;
for $each (@array)
{
    @lines=find_class_method($each);
    if(defined($pattern))
    {
        @ret=grep{/$pattern/} @lines;
    }
    if(scalar(@ret)>0)
    {
    print "########################################################################\n";
    print $each;
    print join("", @ret);
    }
}

sub find_class_method($)
{
    (my $input_file)=@_;
    my @ret;
    open(FILE, "$input_file") or die("open file  $input_file error \n");
    for(<FILE>)
    {
        if($_=~/\s.*def |\s.*class /)
        {
           # print $_;
           push(@ret, $_);
        }
    }
    close(FILE);
    return  @ret;
}

__DATA__
for each in $(find $path |grep py$); 
do 
echo  "########################################################################"
echo  "#FILE:  $each"
egrep "^\s*def|^\s*class"  $each ; 
done 

#argc 
#if [ !  $# -eq 1 ];then
#	echo "Usage: ", $0 , " python_lib_path";
#	exit 
#fi
#path=$1;


