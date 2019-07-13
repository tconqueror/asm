;Write a sequence of MOV instructions that will exchange the upper and lower words in a
;doubleword variable named three.

.386
.model flat,stdcall
.stack 4096
include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	three dword "thre"
	len equ $ - three
.code
main proc

to_upper:
	mov ecx,sizeof three
	mov esi,offset three
loop1:
	movzx eax,byte ptr [esi]
	sub eax,32
	mov byte ptr [esi],al
	inc esi
	loop loop1

to_lower:
	mov ecx,sizeof three
	mov esi,offset three
loop2:
	movzx eax, byte ptr [esi]
	add eax,32
	mov byte ptr [esi],al
	inc esi
	loop loop2
	push 0
	call exitprocess
	
main endp
end main
