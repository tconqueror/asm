section .data
	msg1 db "n: ",0
	len1 equ $-msg1
section .bss
	a resb 1000
	b resb 1000
	lena resb 4
	lenb resb 4
	res resb 1000
	temp resb 10
	n resb 4
	tmp resb 4
section .text
	GLOBAL _start
;------------------------------
scanInt:	;offset
	push ebp
	mov ebp,esp
	pushad
	mov eax,3
	mov ebx,2
	mov ecx,temp
	mov edx,10
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
;-------------------------------
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
copy:			;offset a - b - count
	push ebp
	mov ebp,esp
	pushad
	mov esi, dword [ebp+16]
	mov edi, dword [ebp+12]
	mov ecx, dword [ebp+8]
	rep movsb
	popad
	pop ebp
	ret 12
;---------------------------------	
ad:
	;res - a -b
	push ebp
	mov ebp,esp
	pushad
	mov edi, dword [ebp+16]
	xor bh,bh
	cld
	mov ecx,9999
	mov esi,dword [ebp+12]
	mov edx,dword [ebp+8]
.l1:
	xor ah,ah
	lodsb
	add al,bh
	mov bh,ah
	or bh,30h
	add al,byte [edx]
	aaa
	or bh,ah
	or bh,30h
	or al,30h
	stosb
	inc edx
	mov al,byte [esi]
	add al,byte [edx]
	jz .next
	loop .l1
.next:
	mov al,bh
	cmp al,30h
	jna en
	stosb
en:	
	popad
	pop ebp
	ret 12
;---------------------------------
dis:
	push ebp
	mov ebp,esp
	xor eax,eax
	mov esi,dword [ebp+8]
	mov ecx,0
.l1:
	lodsb
	cmp al,0
	je .en
	push eax
	inc ecx
	jmp .l1 
.en:
	pop eax
	mov byte [temp],al
	push temp
	push 1
	call print	;offse
	loop .en
	pop ebp
	ret 4 
;---------------------------------
read:
;ebp+12 = offset to read
;ebp+8 =len
	push ebp
	mov ebp,esp
	pushad
	push res
	push 1000
	push dword [ebp+8]
	call scan
	mov edx, res
	mov ecx, dword [ebp+8]
	mov ecx, dword [ecx]
	mov eax,ecx
	mov edi, dword [ebp+12]
	cld
l1:
	movzx esi, byte [edx]
	push esi
	inc edx
	loop l1
		
	mov ecx,eax
l2:
	pop eax
	stosb
	loop l2

	popad
	pop ebp
	ret 8
;---------------------------------
_start:
	push msg1
	push len1
	call print
	;
	push n
	call scanInt 
	;
	mov eax,dword [n]
	sub eax,2
	mov dword [n],eax
	mov byte [a],1
	mov byte [b],1
	mov ecx,dword [n]
	;
next:
	push res
	push a
	push b
	call ad

	push a
	push b
	push 1000
	call copy 

	push res
	push a
	push 1000
	call copy 
	
	loop next
	
	push a
	call dis

	mov eax,1
	mov ebx,0
	int 0x80