#!/usr/bin/perl
while(<DATA>)
{
	print $_;
}
__DATA__
#include <stdlib.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <string.h>
#include <unistd.h>

char *host_name = "61.135.150.113";
int port = 80;
int main(int argc ,char  *argv[])
{	
	int error = 1;
	char buf[81920];
	char message[256];
	int socket_desc;
	struct sockaddr_in pin;
	struct hostent *server_host_name;

if((server_host_name = gethostbyname(host_name)) == 0)
 {
	perror("error resolve the DNS\n");
  }

bzero(&pin ,sizeof(pin));

pin.sin_family = AF_INET;
pin.sin_addr.s_addr = htonl(INADDR_ANY);
pin.sin_addr.s_addr = ((struct in_addr *)(server_host_name-> h_addr)) ->s_addr;
pin.sin_addr.s_addr = inet_addr("192.168.3.234");
pin.sin_port = htons(port);

socket_desc = socket( AF_INET ,SOCK_STREAM, 0);

connect( socket_desc , (sockaddr *)&pin ,sizeof(pin));

//这里注意 需要有 HTT/1.1 还是有 \r\n 而且两个， 
send (socket_desc , "GET /  HTTP/1.1 \r\n\r\n", 100 ,0);
while((recv (socket_desc ,buf ,8192 ,0)) == -1 );
{
 printf("%s" , buf);
}
close(socket_desc);

return 1;
}
