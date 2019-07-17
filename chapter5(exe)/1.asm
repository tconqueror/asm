.386
.model flat,stdcall
.stack 4096

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	msg byte "Surprise mother fucker",0
.code
main proc
	mov ecx,4 
	mov eax,red + (yellow * 16)
	mov edx,offset msg
l1:
	call SetTextColor
	call WriteString
	call Crlf
	inc eax
	loop l1
	
	call WaitMsg
	push 0
	call exitprocess
	
main endp

end main

