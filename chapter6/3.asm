.386
.model stdcall,flat

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	space byte " ",0 
.code
main proc
	mov ecx,10
l1:
	mov eax,50
	call RandomRange
	add eax,50
	call WriteDec
	mov edx,offset space
	call WriteString
	call bla
	call WriteChar
	call Crlf
	loop l1
	
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
	push ebx
	push ecx
	push edx
	mov ebx,65
	cmp al,89
	ja ll
	inc ebx
	cmp al,79
	ja ll
	inc ebx
	cmp al,69
	ja ll
	inc ebx
	cmp al,59
	ja ll
	inc ebx
	inc ebx
ll:
	mov eax,ebx
	pop edx
	pop ecx
	pop ebx
	ret
bla endp

end main
