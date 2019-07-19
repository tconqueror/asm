.386
.model flat,stdcall 

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	array dword 48 dup (1)

.code
main proc
	
	mov ecx,45
	mov esi,offset array
l1:
	call bla
	loop l1


	call WaitMsg
	push 0
	call exitprocess
main endp
bla proc 
	mov eax,[esi]
	mov ebx,[esi+4]
	add eax,ebx
	mov [esi+8],eax
	call WriteDec
	call Crlf
	add esi,4
	ret
bla endp

end main
