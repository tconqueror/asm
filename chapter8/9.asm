.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	a sdword 10,20,30,4,50,60,70,80,90,-100
	b sdword 12,1,-10,3,-10,5,6,7,8,-100
.code
main proc
	push 3 
	push offset b
	push offset a
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
	dif equ sdword ptr [ebp+20]
.code
	push ebp
	mov ebp,esp

	mov eax,0
	mov ecx,len
	mov esi,f1
	mov edi,f2
l1:
	mov ebx,sdword ptr [esi]
	mov edx,sdword ptr [edi]
	sub ebx,edx
	jns conti
	not ebx
	inc ebx
conti:
	cmp ebx,dif
	ja next
	inc eax
next:
	add esi,4
	add edi,4
	loop l1

en:
	pop ebp
	ret
bla endp

end main
