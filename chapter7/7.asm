.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	a dword 36
	b dword 24
.code
main proc 
	mov eax,a
	mov ebx,b
	call bla
	call WriteDec
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp	
bla proc
.data 
	one dword 1
.code
	push esi
	push ecx
	push ebx
	mov esi,eax
	xor ecx,ecx
	xor eax,eax
l1:
	cmp ebx,0
	je en
	test ebx,one
	jz conti
	shl esi,cl
	add eax,esi
	mov ecx,0
conti:
	shr ebx,1
	inc ecx
	jmp l1
en:
	pop ebx
	pop ecx
	pop esi
	ret
bla endp
end main
