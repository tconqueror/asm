.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	array dword 100 dup (?)
.code
main proc
	push 5
	push 20
	call bla
	call WriteDec
	call Crlf

	push 24
	push 18
	call bla
	call WriteDec
	call Crlf
	
	push 11
	push 7
	call bla
	call WriteDec
	call Crlf

	push 432
	push 226
	call bla
	call WriteDec
	call Crlf

	push 26
	push 13
	call bla
	call WriteDec
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
.data
	f1 equ dword ptr [ebp+8]
	f2 equ dword ptr [ebp+12]
.code
	push ebp
	mov ebp,esp
	
	mov eax,f1
	mov ebx,f2

l1:
	cmp ebx,0
	jz en
	xor edx,edx
	idiv ebx
	mov eax,ebx
	mov ebx,edx
	jmp l1
en:
	pop ebp
	ret
bla endp

end main
