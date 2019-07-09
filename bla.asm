section .text
	global _start
_start:
	push eax
	push ebx
	push ecx
	push edx
	;push choi cho vui
	
	mov eax,3
	mov ebx,0
	mov ecx,string
	mov edx,max
	int 0x80	
	;doc du lieu
	
	mov edi, array	;chuyen edi bang dia chi cua array, dung cho stosd sau nay
	xor ecx,ecx
	xor ebx,ebx
	xor eax,eax
	;khoi tao bang 0
	mov esi,string	;chuyen dia chi string doc duoc vao esi
	;mov ecx,10		;ecx la 10 (cap so nhan)
reset_digit:		;voi moi so trong string nhan duoc
	xor ebx,ebx		;khoi tao ebx la noi luu so qua cac vong doc ki tu 
read_char:	
	cmp byte [esi],0xa 	;neu la ki tu ket thuc thi bat dau sort
	je sort
	cmp byte[esi], ' '
	je save
	movzx eax, byte [esi]	;luu 1 byte vao eax
	inc esi			;tang esi len de doc byte tiep theo
	sub eax,48		;tru di 48 de lay gia tri that
	imul ebx,10		; luu gia tri *10
	add ebx,eax		; +vao res
	jmp read_char	;doc ki tu tiep theo
	
save:
	inc esi			;bo qua dau cach
	mov eax,ebx		;chuyen du lieu vao eax de stosd
	stosd			;luu vao array
	add edi, 4 		;tang array len 4 (gia tri tiep theo dword)
	jmp reset_digit
	
sort:
	
	
	
	
	
outpro:
	pop edx
	pop ecx
	pop ebx
	pop eax
	
	mov eax,1
	int 0x80
section .data
	max equ 1000000
	len equ 10 
section .bss
	num resb 4
	array resd max
	string resb max
