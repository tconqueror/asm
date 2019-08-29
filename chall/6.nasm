;6.asm
section .data
	msg1 db "Nhap vao chuoi: ",0
	len1 equ $-msg1
	msg2 db "Chuoi dao nguoc: ",0
	len2 equ $-msg2
section .bss
	buf resb 257
	ls resb 4
section .text
	global _start
;---------------------------------
print:	;offset - soluong
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax,4
	mov ebx,1
	mov ecx,dword [ebp+12]
	mov edx,dword [ebp+8]
	int 0x80
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 8
;---------------------------------
scan:		;offset - soluong - len
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax,3
	mov ebx,2
	mov ecx,dword [ebp+16]
	mov edx,dword [ebp+12]
	int 0x80
	dec eax
	mov ebx, dword [ebp+8]
	mov dword [ebx],eax
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 8
;---------------------------------
_start:
	push msg1
	push len1
	call print
;
	push buf
	push 257
	push ls
	call scan

	push msg2
	push len2
	call print
;
	mov ecx, dword [ls]
	std
	mov esi,buf
	add esi,ecx
	dec esi
l1:
	push esi
	push 1
	call print
	dec esi
	loop l1
en:
	mov eax,1
	mov ebx,0
	int 0x80