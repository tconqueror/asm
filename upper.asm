;to upper
section .text
	global _start
	
_start:
	mov ecx ,len
	mov esi,s1
	mov edi ,s2
	
lap:
	lodsb
	cmp al, 0x20
	je restore
	mov bl,0x20
	not bl
	and al,bl
restore:
	stosb
	loop lap
	
	cld
	rep movsb
	
	mov eax,4
	mov ebx,1
	mov ecx,s2
	mov edx,len
	int 0x80
	
	mov eax,1
	int 0x80
	
section .data
s1 db 'upper me'
len equ $ -s1
section .bss
s2 resb 20
