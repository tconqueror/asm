.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	lower byte 5,2,4,1,3
	upper byte 9,5,8,4,6
	buf byte 1,3,7,2,5
.code
main proc
	mov esi,offset buf
	call bla
	call WriteDec
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
	push ebx
	push ecx
	push edx
	mov ecx,5
l1:
	dec ecx
	movzx eax, byte ptr [esi+ecx]
	cmp al,lower[ecx]
	jb invalid
	cmp al,upper[ecx]
	ja invalid
	inc ecx
	loop l1
	xor eax,eax
	jmp back
invalid:
	mov eax,ecx
	inc eax
back:
	pop edx
	pop ecx
	pop ebx
	ret
bla endp

end main
