.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	str1 byte "What the fuck are there in ",0
.code
main proc
	push offset str1+4
	push 4
	call sremove

	mov edx,offset str1
	call WriteString

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

sremove proc	
.data
	num equ dword ptr [ebp+8]
	s equ dword ptr [ebp+12]
.code
	push ebp
	mov ebp,esp
	push esi
	push edi

	mov esi,s
	add esi,num
	mov edi,s
l1:
	movsb	
	cmp byte ptr [edi-1],0
	jne l1
en:
	pop edi
	pop esi
	pop ebp
	ret 
sremove endp

end main
