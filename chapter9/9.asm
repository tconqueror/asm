.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	table byte 16 dup (1)
	rowsize equ 4
.code

main proc
	push offset table
	push rowsize
	push 1
	push 2
	call getval
	call WriteDec
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
	ret
bla endp

getval proc
.data
	tabl equ dword ptr [ebp+20]
	rows equ dword ptr [ebp+16]
	x equ dword ptr [ebp+12]
	y equ dword ptr [ebp+8]
.code	
	push ebp
	mov ebp,esp
	push ebx 
	push esi

	mov eax,rows
	mul y
	mov ebx,eax
	add ebx,tabl
	mov esi,x
	movzx eax, byte ptr [ebx+esi]

	pop esi
	pop ebx
	pop ebp
	ret
	
getval endp

end main
