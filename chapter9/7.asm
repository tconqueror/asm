.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	check byte 65000 dup (?)
	last dword 65000
.code
main proc

	mov edi,offset check
	mov al,0
	mov ecx,last
	rep stosb

	mov edx,offset check
	call bla
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp	
bla proc
	pushad
	mov eax,2
l1:
	cmp eax,last
	je en
	cmp byte ptr [edx+eax],1
	je conti
	call WriteDec
	call Crlf
	mov ebx,eax
	add ebx,eax
l2:
	cmp ebx,last
	jg conti
	mov byte ptr [edx+ebx],1
	add ebx,eax
	jmp l2
conti:
	inc eax
	jmp l1
en:
	popad
	ret
bla endp
end main

end main
