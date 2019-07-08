;find a character on some letters
section .text
	global _start
_start:
	mov eax,3
	mov ebx,0
	mov ecx,string
	mov edx,256
	int 0x80
	
	mov eax,3
	mov ebx,0
	mov ecx,char
	mov edx,1
	int 0x80
	
	mov ecx, 256 
	mov edi,string
	mov al, char
	cld
	repne scasb
	je found
	mov eax,4
	mov ebx,1
	mov ecx,msgFalse
	mov edx,len2
	int 0x80
	jmp outpro
	
found:
	mov eax,4
	mov ebx,1
	mov ecx,msgTrue
	mov edx,len1
	int 0x80
outpro: 
	mov eax,1
	mov ebx,0
	int 0x80
	
section .data
msgTrue db "Found",0xa
len1 equ $ - msgTrue
msgFalse db "Not Found" ,0xa
len2 equ $ - msgFalse
segment .bss
char resb 1
string resb 256
