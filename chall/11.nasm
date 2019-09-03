section .data
	msg1 db "Nhap vao a: ",0
	len1 equ $-msg1
	msg2 db "Nhap vao b: ",0
	len2 equ $-msg2
	msg3 db "Res: ",0
	len3 equ $-msg3
	msg4 db "Wrong option!",0
	len4 equ $-msg4
	msg5 db "Chon: + - * /",0xd,0xa,0
	len5 equ $-msg5
	crlf db 0xd,0xa,0
	lencr equ $-crlf
	negative db "-",0
	lenne equ $-negative
section .bss
	sign resb 4
	lsign resb 4
	a resd 1
	b resd 1
	res resd 1
	tmp resd 1
	temp resb 100
section .text
	global _start
;------------------------------
sDec:	
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
sInt:
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
	cmp byte [temp],'-'
	jne posi
	mov esi,temp
	inc esi
	mov ebx,0
	dec ecx
	cld
	jmp l1
posi:
	mov esi,temp
	mov ebx,0
	cld
l1:
	xor eax,eax
	lodsb
	sub al,'0'
	xchg eax,ebx
	mov edx,10
	mul edx
	add eax,ebx
	xchg eax,ebx
	loop l1
	mov eax,dword [ebp+8]
	mov dword [eax],ebx
	cmp byte [temp],'-'
	jne en
	neg dword [eax]
en:	
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
scan:		
	;offset - soluong - len
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
	add eax,dword [ebp+16]
	mov byte [eax],0
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 12
;---------------------------------
pDec:
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
pInt:
	;val
	push ebp
	mov ebp,esp
	pushad
	mov eax,dword [ebp+8]
	or eax,eax
	jns conti
	push negative
	push lenne
	call print
	neg eax
conti:
	push eax
	call pDec
	popad
	pop ebp
	ret 4
;---------------------------------

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

	push a
	call sInt

	;push dword [a]
	;call pInt

	push msg2
	push len2
	call print

	push b
	call sInt

	;push dword [b]
	;call pInt

	;call newl
	push msg5
	push len5
	call print

	mov dword [sign],0
	push sign
	push 4
	push lsign
	call scan

	push msg3
	push len3
	call print

	mov al,byte [sign]
	cmp al,'+'
	je ad
	cmp al,'-'
	je su
	cmp al,'*'
	je im
	cmp al,'/'
	je id
	push msg4
	push len4
	call print
	jmp enn
ad:
	mov eax, dword [a]
	add eax, dword [b]
	push eax
	call pInt
	jmp enn
su:
	mov eax, dword [a]
	sub eax, dword [b]
	push eax
	call pInt
	jmp enn
im:	
	mov eax, dword [a]
	mov ebx, dword [b]
	imul ebx
	push eax
	call pInt
	jmp enn
id:	
	xor edx,edx
	mov eax, dword [a]
	mov ebx, dword [b]
	idiv ebx
	push eax
	call pInt
enn:
	call newl
	mov eax,1
	mov ebx,0
	int 0x80