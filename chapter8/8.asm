.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	a sdword -10,20,30,40,50,60,70,80,90,-100
	b sdword -10,1,2,3,4,5,6,7,8,-100
.code
main proc
	push offset a
	push offset b
	push lengthof a
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
	f1 equ sdword ptr [ebp+12]
	f2 equ sdword ptr [ebp+16]
.code
	push ebp
	mov ebp,esp

	mov esi,f1
	mov edi,f2
	mov ecx,len
	mov eax,0
l1:
	mov ebx,[edi]
	cmp ebx,[esi]
	jne conti
	inc eax
conti:
	add esi,4
	add edi,4
	loop l1
en:
	pop ebp
	ret
bla endp

end main
