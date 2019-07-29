.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	base dword 256 dup (0)
	target byte "HOW DEEP IS YOUR LOVE?",0
.code
main proc 
	push offset target
	push offset base
	call bla
	mov esi,offset base
	mov ecx,256
	mov ebx,type base
	call DumpMem
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
.data
	bas equ dword ptr [ebp+8]
	tar equ dword ptr [ebp+12]
.code
	push ebp
	mov ebp,esp

	push tar
	call slength
	pop ecx
	mov ecx,eax
	mov esi,tar
l1:
	xor eax,eax
	mov al, byte ptr [esi]
	shl eax,2
	add eax,bas
	inc dword ptr [eax]
	inc esi
	loop l1

	pop ebp
	ret
bla endp 

slength proc
.data
	string equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	push esi

	mov esi,string
	mov eax,0
l1:
	cmp byte ptr [esi],0
	je en
	inc eax
	inc esi
	jmp l1

en:
	pop esi
	pop ebp
	ret
slength endp

end main
