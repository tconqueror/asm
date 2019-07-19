.386
.model flat,stdcall 

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data


.code
main proc
	mov ecx,256
	
l1:
	xor edx,edx
	mov eax,ecx
	mov ebx,16
	div ebx
	cmp edx,0
	jne conti
	call Crlf

conti:
	mov eax,ecx
	dec eax
	call SetTextColor
	mov eax,'A'
	call WriteChar
	loop l1
	call WaitMsg
	push 0
	call exitprocess
main endp

end main
