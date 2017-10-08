#!/usr/bin/perl

if(! -f  "rabbitmqadmin")
{
	system(" rabbitmq-server ");
	system("rabbitmq-plugins enable rabbitmq_management");
	system(" setenforce 0  ");
	system(" 	rabbitmq-plugins enable rabbitmq_tracing ");


	#然后，重启rabbitmq：
	system("service rabbitmq-server stop");
	system("service rabbitmq-server start" );


	system("wget http://localhost:15672/cli/rabbitmqadmin");

}

$list_str=<<EOF
  list users [<column>...]
  list vhosts [<column>...]
  list connections [<column>...]
  list exchanges [<column>...]
  list bindings [<column>...]
  list permissions [<column>...]
  list channels [<column>...]
  list parameters [<column>...]
  list queues [<column>...]
  list policies [<column>...]
  list nodes [<column>...]
EOF
;
open(PIPE, "  python rabbitmqadmin  help subcommands |grep list |") or die("  rabbitmqadmin   list error \n");
for(<PIPE>)
{
	#print $_;
	my @array=split(/\s+/, $_);
	my $name=$array[2];
	print "perl  rabbitmqadmin  list   $name \n";
	system( "perl  rabbitmqadmin  list   $name \n");
}
__DATA__
	
rabbitmq-plugins enable rabbitmq_tracing
rabbitmq-plugins enable rabbitmq_management

service  rabbitmq-server restart 
