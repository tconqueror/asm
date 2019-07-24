.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	a byte 12h, 34h, 56h, 78h, 90h, 12h, 34h, 56h, 78h, 90h, 12h, 34h, 56h, 78h, 90h, 12h
	b byte 12h, 34h, 56h, 78h, 90h, 12h, 34h, 56h, 78h, 90h, 12h, 34h, 56h, 78h, 90h, 12h
	res byte 17 dup (?)
	num = sizeof a / type byte
.code
main proc 
	mov esi,offset a
	mov edi,offset b
	mov edx,offset res
	mov ecx,num
	call bla
l1:
	movzx eax,byte ptr [edx]
	mov ebx,type byte
	call WriteHexB
	inc edx
	loop l1

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp	
bla proc
.data 
	one byte 1111b
.code
	pushad
	add esi,num
	add edi,num
	add edx,num
	clc
l1:
	;push ecx
	dec esi
	dec edi
	dec edx
	mov al, byte ptr [esi]
	adc al, byte ptr [esi]
	pushfd
	daa
	mov byte ptr [edx],al
	popfd
	loop l1
	popad
	ret
bla endp
end main
