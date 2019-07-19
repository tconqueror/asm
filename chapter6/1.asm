.386
.model flat,stdcall 

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	arrayA dword 1000 dup (0)
	arrayB dword 1000 dup (1)
	n dword ?
	j dword ?
	k dword ?
	space byte ' ',0

.code
main proc
	mov j, 10000h
	mov k, 20000h
	mov n,300
	mov esi,offset arrayA
	call bla
	comment ?
	mov esi,offset arrayA
	mov ecx,n
	mov ebx,type arrayA
	call DumpMem
	?
	call Crlf
	
	mov j,64h
	mov k,3e8h
	mov n,100
	mov esi,offset arrayB
	call bla
	comment ?
	mov esi,offset arrayA
	mov ecx,n
	mov ebx,type arrayA
	call DumpMem
	?
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp
bla proc 
	pushad
	mov ecx,n
l1:
	mov eax,k
	sub eax,j
	call RandomRange
	add eax,j
	call WriteDec
	mov edx,offset space
	call WriteString
	mov [esi],eax
	add esi,4
	loop l1

	popad
	ret
bla endp
end main
