section .data
	msg1 db "Nhap vao so phan tu: ",0
	len1 equ $-msg1
	msg2 db "Nhap vao cac phan tu: ",0
	len2 equ $-msg2
	msg3 db "Phan tu lon nhat: ",0
	len3 equ $-msg3
	msg4 db "Phan tu nho nhat: ",0
	len4 equ $-msg4
	crlf db 0xd,0xa,0
	lencr equ $-crlf
section .bss
	n resd 1
	array resd 200
	min resd 1
	max resd 1
	tmp resd 1
	temp resb 100
section .text
	global _start
;------------------------------
scanInt:	
	;offset
	push ebp
	mov ebp,esp
	pushad
	mov eax,3
	mov ebx,2
	mov ecx,temp
	mov edx,100
	int 0x80
	mov ecx,eax
	dec ecx
	mov esi,temp
	mov ebx,0
	cld
.l1:
	xor eax,eax
	lodsb
	sub al,'0'
	xchg eax,ebx
	mov edx,10
	mul edx
	add eax,ebx
	xchg eax,ebx
	loop .l1
	mov eax,dword [ebp+8]
	mov dword [eax],ebx
	popad
	pop ebp
	ret 4	
;---------------------------------
print:	
	;offset - soluong
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
;------------------------------
pInt:
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax, dword [ebp+8]
	xor ebx,ebx
	mov edi,temp
	cld
.push_char:
	xor edx,edx
	mov ecx,10
	div ecx
	add edx,30h
	push edx
	inc ebx
	test eax,eax
	jnz .push_char
	mov dword [tmp], ebx
.pop_char:
	pop eax
	stosb
	dec ebx
	test ebx,ebx
	jnz .pop_char
.print:
	mov eax,4
	mov ebx,1
	mov ecx,temp
	mov edx,dword [tmp]
	int 0x80
.end:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 4
;---------------------------------
newl:
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
	mov ecx,crlf
	mov edx,lencr
	int 0x80
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret
;------------------------------
_start:
	push msg1
	push len1
	call print

	push n
	call scanInt
	
	push msg2 
	push len2
	call print

	call newl

	mov ecx,dword [n]
	mov edi, array
l1:
	push edi
	call scanInt
	add edi,4
	loop l1
	
	call newl

	mov ecx, dword [n]
	dec ecx
	mov edi, array
	mov edi, dword [edi]
	mov dword [max], edi
	mov dword [min], edi
	mov edi, array
	add edi,4
l2:
	mov eax, dword [edi]
	cmp eax, dword [max]
	ja chgmax
	cmp eax, dword [min]
	jb chgmin
conti:
	add edi,4
	loop l2
	jmp en
chgmax:	
	mov dword [max],eax
	jmp conti
chgmin:
	mov dword [min],eax
	jmp conti
en:
	push msg3
	push len3
	call print

	push dword [max]
	call pInt

	call newl

	push msg4
	push len4
	call print

	push dword [min]
	call pInt
	
	call newl
	
	mov eax,1
	mov ebx,0
	int 0x80