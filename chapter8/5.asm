.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data

.code
main proc
	push 1
	push 1
	push 1
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
	f3 equ dword ptr [ebp+16]
.code
	push ebp
	mov ebp,esp
	mov eax,f2
	cmp eax,f1
	jne sai
	cmp eax,f3
	jne sai
	mov eax, 0
	jmp en
sai:	
	mov eax,1
en:
	pop ebp
	ret
bla endp

end main
