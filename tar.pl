#!/usr/local/bin/new/perl -w
use 5.004;
# use strict;
use Getopt::Std;
use IO::File;
use vars qw($opt);
             
BEGIN 
 {
  $opt = 'ctxvmf:';
  eval { require Compress::Zlib };
  if ($@)
   {
    warn "No decompression available:$@\n";
   }
  else
   {
    Compress::Zlib->import;
    $opt .= 'zZ';
   }
 }

my %opt;
getopts($opt,\%opt);

sub read_header
{
 my $read = shift;
 my $buf = '';
 my $err = &$read($buf,512);
 die "Cannot read:$err" if $err;
 if (length($buf) == 512)
  {
   return undef if $buf =~ /^\0{512}/;
   my %info;
   ($info{'archname'}, $info{'mode'}, $info{'uid'}, $info{'gid'}, $info{'size'}, 
       $info{'mtime'}, $info{'chksum'}, $info{'linkflag'}, $info{'arch_linkname'}, 
       $info{'magic'}, $info{'uname'}, $info{'gname'}, $info{'devmajor'}, $info{'devminor'})
    = unpack('A100A8A8A8A12A12A8A1A100A8A32A32A8A8',$buf);
   foreach my $key (qw(archname arch_linkname magic uname gname))
    {
     $info{$key} =~ s/\0(?:.|\n)*$//;
    }
   foreach my $key (qw(mode uid gid size mtime chksum))
    {
     my $val = $info{$key};
     if ($val =~ /^\s*([0-7]+)$/)
      {
       $info{$key} = oct($1); 
      }
     else
      {
       $val =~ s/([^\x20-\x7f])/sprintf('\%03o',unpack('C',$1))/eg;
       warn "$key is '$val'\n";
      }
    }
   return \%info;
  }
 else
  {
   die "size is ".length($buf)." not 512" if (length($buf));
  }
 return undef;
}

sub read_data
{
 my ($read,$hdr,$fh) = @_;
 my $size = $hdr->{'size'};
 my $blocks = int(($size+511)/512);
 # print "$size => $blocks\n";
 my $first = 1;
 while ($blocks--)
  {
   my $buf = '';
   my $err = &$read($buf,512);
   die "Cannot read:$err" if ($err);
   my $len = length($buf);
   if ($len != 512)
    {
     die "Size is $len not 512:$!";
    }
   if ($fh)
    {
     $buf = substr($buf,0,$size) if ($size < 512);
     if ($first)
      {
       if ($buf =~ /([^\r\n\s!-~])/)
        {
         warn "Binary due to $1 (".ord($1).")\n";
         binmode($fh) 
        }
       $first = 0;
      } 
     print $fh $buf;
     $size -= length($buf);
    }
  }
}

sub skip_entry
{
 my ($read,$hdr) = @_;
 read_data($read,$hdr,undef);
}

sub make_dir
{
 my $name = shift;
 make_dir($1) if ($name =~ m#^(.*)/[^/]+#);
 unless (-d $name)
  {
   mkdir($name,0777) || die "Cannot mkdir($name):$!";
   warn "mkdir $name\n" if ($opt{'v'});
  }
}

sub extract_entry
{
 my ($read,$hdr) = @_;
 my $name = $hdr->{'archname'};
 if ($opt{'m'})
  {
   $name =~ s/([A-Z])/_\l$1/g;
  }
 make_dir($1) if ($name =~ m#^(.*)/[^/]+#);
 my $typ = $hdr->{'mode'} >> 9;
 if ($typ != 0100)
  {
   if ($typ != 040)
    {
     printf "%o $name\n",$hdr->{'mode'};
    }
   read_data($read,$hdr,undef);
   return;
  }

 if (-f $name && !-w $name)
  {
   chmod(0666,$name);
   unlink($name) 
  }
 my $fh = IO::File->new(">$name") unless ($name =~ m#/$#);
 warn "Cannot open $name:$!" unless ($fh);
 read_data($read,$hdr,$fh);
 if ($fh)
  {
   my $t = $hdr->{'mtime'};
   $fh->close;
   utime($t,$t,$name);
   chmod($hdr->{'mode'} & 0777,$name);
  }
}

sub mode_str
{
 my $mode = shift;
 my $str = '';
 $str .= ($mode & 4) ? 'r' : '-';
 $str .= ($mode & 2) ? 'w' : '-';
 $str .= ($mode & 1) ? 'x' : '-';
}

sub list_entry
{
 my $hdr = shift;
 my $mode = $hdr->{'mode'};
 my $str  = '-';  # Needs to be 'd', 'l', 'c', 'b' etc.
 $str .= mode_str(($mode >> 6) & 7);
 $str .= mode_str(($mode >> 3) & 7);
 $str .= mode_str(($mode >> 0) & 7);
 $str .= sprintf(" %d/%d %12d ",$hdr->{'uid'},$hdr->{'gid'},$hdr->{'size'});
 my $t = localtime($hdr->{'mtime'});
 $t =~ s/^\w+\s//;
 $t =~ s/(\d+:\d+):\d+/$1/;
 $str .= $t;
 $str .= ' ';
 $str .= $hdr->{'archname'};
 return $str;
}

if ($opt{'c'})
 {
  die "-c not implemeted\n";
 }
else
 {
  my $hdr;
    
  $| = 1;
    
  if ($opt{'f'})
   {
    open(STDIN,"<$opt{'f'}") || die "Cannot open $opt{'f'}:$!";
   }
  binmode(STDIN); 
    
  my $read;

  if ($opt{'z'} || $opt{'Z'})
   {
    # quick and dirty till we sort out Compress::Zlib
    my $gz = gzopen(\*STDIN, "rb");
    die "Cannot gzopen:$gzerrno" unless ($gz);
    $read = sub { $gz->gzread($_[0],$_[1]) < 0 ? $gzerrno : 0 };
   }
  else
   {
    $read = sub { read(\*STDIN,$_[0], $_[1]) < 0 ? $! : 0 };
   }
  while ($hdr = read_header($read))
   {
    my $dh;
    if ($opt{'x'})
     {
      extract_entry($read,$hdr);
     }
    else
     {
      skip_entry($read,$hdr);
     }
    if ($opt{'v'})
     {
      print list_entry($hdr),"\n" 
     }
    elsif ($opt{'t'})
     {
      print $hdr->{'archname'},"\n";
     }
    #last;
   }
 }
__END__