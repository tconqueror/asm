.386
.model flat,stdcall

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	array dword 0,1,2,3,4,5,6,7,8,9,10,11,12
.code
main proc
	mov esi,offset array
	mov edx,type array
	mov ebx,2
	mov ecx,5
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
	push esi
	sub ecx,ebx
	mov eax,ecx
	push edx
	mul edx
	pop edx
	add esi,eax
	xor eax,eax
	inc ecx
l1:

	add eax,[esi]
	add esi,edx
	loop l1


	pop esi
	pop edx
	pop ecx
	pop ebx


	ret
bla endp

end main
