#!/usr/bin/perl
###########################################
# newsyslog-test
# Mike Schilli, 200t (m@perlmeister.com)
###########################################
use strict;
use Log::Log4perl qw(:easy);

# newsyslog configuration:
# /tmp/test.log 666  12  1  *  B /tmp/test.pid 30

#log4perl.appender.Logfile.mode = create
#log4perl.appender.Logfile.mode = append
sub logInit($)
{
	(my $logfile)=@_;
	if(! $logfile)
	{
		$logfile="logdefault.log";
	}
	my $conf = qq{
	log4perl.category                  = DEBUG, Logfile
	log4perl.appender.Logfile          = Log::Log4perl::Appender::File
	log4perl.appender.Logfile.recreate = 1
	log4perl.appender.Logfile.recreate_check_signal = USR1
	log4perl.appender.Logfile.recreate_pid_write = /tmp/test.pid
	log4perl.appender.Logfile.mode = append
	log4perl.appender.Logfile.filename = $logfile
	log4perl.appender.Logfile.layout = Log::Log4perl::Layout::PatternLayout
	log4perl.appender.Logfile.layout.ConversionPattern = %d %F{1} %L> %m%n
	};

	Log::Log4perl->init(\$conf);
}

1;

