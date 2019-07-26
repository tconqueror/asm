.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
.code
main proc
	push 2
	push 3 
	push 4
	push 3
	call bla
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc	
.data
	msg byte "Stack parameter:",0ah,"--------------------------------",0ah,0 
	x byte "Address ",0
	y byte " = ",0
	count equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp

	mov edx,offset msg
	call WriteString
	;display msg
	mov ecx, count
	mov ebx,ebp
	add ebx,12
l1:
	mov edx,offset x
	call WriteString

	mov eax,ebx
	call WriteHex

	mov edx,offset y
	call WriteString

	mov eax,[ebx]
	call WriteHex
	
	call Crlf
	add ebx,4
	loop l1

en:
	pop ebp
	ret
bla endp

end main
