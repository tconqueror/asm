.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	a dword 24
	b dword 36
.code
main proc 
	mov esi,a
	mov edi,b
	call bla
	call WriteDec
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp	
bla proc
	push esi
	push edi
	push edx
	cmp esi,0
	jns checkedi
	not esi
	inc esi
checkedi:
	cmp edi,0
	jns conti
	not edi
	inc edi
conti:
	cmp edi,0
	je en
	mov eax,esi
	xor edx,edx
	div edi
	mov esi,edi
	mov edi,edx
	jmp conti
en:
	mov eax,esi
	pop edx
	pop edi
	pop esi
	ret
bla endp
end main
