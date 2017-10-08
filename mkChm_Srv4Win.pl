#!/usr/bin/perl    
use IO::Select;
use IO::Socket;
use File::Copy::Recursive qw(pathmk);
use File::Basename;
use POSIX qw(strftime);
our $close=0;
	$tmp;
    $lsn = new IO::Socket::INET(Listen => 1, LocalPort => 8080) or die("bind error\n");
    $sel = new IO::Select( $lsn );

    while(@ready = $sel->can_read) {
        foreach $fh (@ready) {
            if($fh == $lsn) {
                # Create a new socket
                $new = $lsn->accept;
                $sel->add($new);
            }
            else {
                # Process socket
				#$/="";
				$name=<$fh>;
				
				chomp $name;
				$time=strftime("%Y_%m_%d_$close", localtime(time()));	
				print $name , "save as", $name,"\n";	
				pathmk(dirname($name));
				open(FILE, ">".$name);
				
				while($fh->sysread($tmp, 4096)>0 )
				{
					#print FILE $tmp;
					syswrite(FILE, $tmp,4096);
				}
				#print FILE <$fh>;	
				close(FILE);
                # Maybe we have finished with the socket
                $sel->remove($fh);
                $fh->close;
				$close++;
				print "close number ", $close,"\n";
            }
        }
    }
