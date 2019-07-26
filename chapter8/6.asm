.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	array dword 100 dup (?)
.code
main proc
	call Randomize
	mov ecx,lengthof array
	mov esi,offset array
l1:
	call Random32
	mov dword ptr [esi],eax
	call WriteDec
	mov eax,20h
	call WriteChar
	add esi, type dword
	loop l1
	mov ecx,lengthof array - 1
	mov esi,offset array
l2:
	push esi
	add esi,4
	push esi
	call bla
	call Crlf
	
	loop l2

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
	push esi
	push edi
	
	mov esi,f1
	push [esi]
	mov edi,f2
	push [edi]
	pop [esi]
	pop [edi]

	pop edi
	pop esi
	pop ebp
	ret
bla endp

end main
