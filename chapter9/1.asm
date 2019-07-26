.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	str1 byte "What the fuck are there in this",0
	str2 byte 100 dup (1)
.code
main proc
	push offset str1
	push offset str2
	push 12
	call bla

	mov edx,offset str2
	call WriteString

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc	
.data
	len equ dword ptr [ebp+8]
	s2 equ dword ptr [ebp+12]
	s1 equ dword ptr [ebp+16]
.code
	push ebp
	mov ebp,esp
	push esi
	push edi
	push ebx
	mov esi,s1
	mov edi,s2
	mov ecx,len
l1:
	movsb
	mov ebx,[esi]
	cmp ebx,0
	je en
	loop l1
	mov byte ptr [edi],0
	
en:
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
bla endp

end main
