;to string
section .text
	global _start
_start:
	
	mov eax, [a]			;nem vao eax
	mov edi, res
int_to_string:
	push eax
	push ebx
	push ecx
	push edx
	xor ebx,ebx
.push_char:
	xor edx,edx
	mov ecx,10
	div ecx
	add edx,48
	push edx
	inc ebx
	test eax,eax
	jnz .push_char
.pop_char:
	pop eax
	stosb
	inc edi
	dec ebx
	cmp ebx,0
	jg .pop_char
.print:
	mov eax,4
	mov ebx,1
	mov ecx,res
	mov edx,100
	int 0x80
	
	pop edx
	pop ecx
	pop ebx
	pop eax
outpro:
	mov eax,1
	int 0x80

section .data
	a db 123
section .bss
	res resb 100
	
