section .data
	msg1 db "Xau me: ",0
	len1 equ $-msg1
	msg2 db "Xau con: ",0
	len2 equ $-msg2
	msg3 db "Vi tri",0
	len3 equ $-msg3
	msg4 db "Can't find",0
	len4 equ $-msg4
	crlf db 0xd,0xa,0
	lencr equ $-crlf
section .bss
	str1 resb 101
	ls1 resb 4
	ls2 resb 4
	str2 resb 11
	temp resb 101
	tmp resb 4
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
;---------------------------------
sfind:
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	std
	xor edx,edx
	mov edi,str1
	add edi,[ls1]
	dec edi
	;
	mov esi,str2
	add esi,[ls2]
	dec esi
	;
	mov ebx,esi
	mov al, byte [esi]
	mov ecx,dword  [ls1]
	;
.l1:
	mov esi,ebx
	repne scasb
	jecxz .conti
	push edi
	inc edx
	jmp .l1
.conti:
	cld
	test edx,edx
	je .conti3
	dec ebx
.conti2:
	test edx,edx
	je .conti4
	pop edi
	dec edx
	mov ecx, dword [ls2]
	dec ecx
	mov esi,ebx
	repe cmpsb
	test ecx,ecx
	jnz .conti2
.tru:
	mov eax,edi
	sub eax,str1
	sub eax, dword [ls2]
	push eax
	call pInt
	call newl
	jmp .conti2
.conti4:
	mov eax,edi
	sub eax,str1
	inc eax
	cmp eax,eax
	je en
.conti3:
	cmp edi,0
	je .en
.en:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret
;---------------------------------

_start:
	push msg1
	push len1
	call print 
;
	push str1
	push 101
	push ls1
	call scan

	push msg2
	push len2
	call print
;
	push str2
	push 11
	push ls2
	call scan

	;push dword [ls1]
	;call pInt
	;call newl
	;push dword [ls2]
	;call pInt
	call sfind
;
en:
	mov eax,1
	mov ebx,0
	int 0x80
