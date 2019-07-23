;Extended Subtraction Procedure
.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	bcd dword 12345678h
	buf byte 18 dup (?)
	ten word 3130h
	
.code
main proc
	mov edx,bcd
	mov esi,offset buf
	call bla

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
.data
	x dword 1111b
.code
	pushad
	;mov al, 
	mov ecx,8
l1:
	mov eax,x
	and eax,edx
	add eax,48
	push eax
	shr edx,4
	loop l1
	
	mov ecx,8
	;clear all '0' first
l3:
	pop eax
	cmp eax,48
	jne l2
	mov byte ptr [esi], al
	inc esi
	dec ecx
	jmp l3
l2:
	mov byte ptr [esi], al
	inc esi
	call WriteChar
	cmp ecx,1
	je en
	pop eax
	loop l2
	;mov byte ptr [esi],al
en:
	popad
	ret
bla endp

end main
