;sacs template
section .text
	global _start
_start:
	mov ecx,len
	mov edi,string 
	mov al, 's'
	cld
	repne scasb
	je found
	mov eax,4
	mov ebx,1
	mov ecx,msgfalse
	mov edx,len1
	int 0x80
	jmp outpro
	
found:
	mov eax,4
	mov ebx,1
	mov ecx,msgtrue
	mov edx,len2
	int 0x80
	
outpro:
	mov eax,1
	mov ebx,0
	int 0x80
section .data
string db 'hello motherfuckers',0
len equ $-string
msgfalse db 'xit',0xa
len1 equ $-msgfalse
msgtrue db 'trung',0xa
len2 equ $-msgtrue
