.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	array dword 100 dup (?)
	msg1 byte "Nhap so phan tu cua mang: ",0
	msg2 byte "Nhap cac phan tu cua mang: ",0
	len dword ?
.code
main proc
	mov edx,offset msg1
	call WriteString
	call ReadInt
	mov len,eax
	;
	mov edx,offset msg2
	call WriteString
	mov ecx,len
	mov edi,offset array
l1:
	call ReadInt
	stosd
	loop l1	
	;

	push offset array
	push len

	call bla
	
	mov esi,offset array
	mov ecx,len
	mov ebx,type array
	call DumpMem
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
.data
	arr equ dword ptr [ebp+12]
	count equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	mov edx,1
	mov ecx,count
	dec ecx
l1:
	cmp edx,1
	jne en
	mov edx,0
	push ecx
	mov esi,arr
l2:
	mov eax,[esi]
	cmp [esi+4],eax
	jg l3
	xchg eax,[esi+4]
	mov	[esi],eax
	mov edx,1
l3:
	add esi,4
	loop l2

	pop ecx
	jmp l1
en:
	pop ebp
	ret 8

bla endp
end main
