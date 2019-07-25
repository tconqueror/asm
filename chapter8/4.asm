.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	array dword 1,3,5,7,9,11,13,15,16,17
.code
main proc
	push offset array
	push lengthof array
	call bla
	call WriteDec
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp
	
bla proc
.data
	len equ dword ptr [ebp+8]
	arr equ dword ptr [ebp+12]
.code
	push ebp
	mov ebp,esp
	push arr
	mov ecx,len
	sub ecx,2
	;bo di 2 phan tu cuoi cung

l1:
	mov eax,[arr]
	mov ebx,[eax]
	mov eax,[eax+4]
	sub eax,ebx
	cmp eax,1			;neu 1 va 2 khong cach nhau 1 don vi thi next
	jne next1
	mov eax,[arr]
	mov ebx,[eax+4]
	mov eax,[eax+8]
	sub eax,ebx
	cmp eax,1			;neu 2 va 3 khong cach nhau 1 don vi thi next
	jne next1
	jmp en
next1:
	add [arr],4
	loop l1
	mov eax,0
en:
	pop arr
	pop ebp
	ret
bla endp
end main
