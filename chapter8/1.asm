.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	array dword 100 dup (?)
.code

main proc
	;first need to generate the array
	mov ecx,lengthof array
	mov esi,offset array
	call Randomize

l1:
	call Random32
	mov [esi],eax
	add esi,4
	loop l1

	push offset array
	push lengthof array
	call bla

	call WriteDec

	call Crlf
	call WaitMsg
	push 0 
	call exitprocess
main endp

bla proc
	push ebp
	mov ebp,esp
	mov ecx, dword ptr [ebp + 8]
	mov esi, dword ptr [ebp + 12]
	xor eax,eax
l1:
	cmp eax,[esi]
	ja next
	mov eax,[esi]
next:
	add esi,4
	loop l1
	pop ebp
	ret
bla endp

end main
