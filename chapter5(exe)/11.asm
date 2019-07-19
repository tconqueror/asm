.386
.model flat,stdcall 

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	array byte 51 dup (0)
	n byte 50
	k byte 2
	space byte ' ',0
.code
main proc
	mov esi,offset array
	call bla
	call Crlf

	movzx eax,k
	inc eax
	mov k,al
	call bla

	mov esi,offset array
	mov ecx,lengthof array
	mov ebx, type array
	call DumpMem

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp
bla proc 
	movzx eax,k
printmul:
	cmp al, n
	jg conti
	mov ebx,esi
	add ebx,eax
	mov edx,1
	mov [ebx],dl
	call WriteDec
	mov edx,offset space
	call WriteString
	add al,k
	jmp printmul
conti:
	ret
bla endp
end main
