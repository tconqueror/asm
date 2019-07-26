.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	str1 byte "What the fuck are there in ",0, 10 dup (1)
	str2 byte "this!",0
.code
main proc
	push offset str1
	push offset str2
	call bla

	mov edx,offset str1
	call WriteString

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc	
.data
	s1 equ dword ptr [ebp+12]
	s2 equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp

	push esi
	push edi
	push ebx

	mov esi,s2
	push s1
	call slength
	mov edi,s1
	add edi,eax
	push s2
	call slength
	mov ecx,eax
	inc ecx
	cld
	rep movsb
	pop ebx
	pop ebx
en:
	pop ebx
	pop edi
	pop esi
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

	mov eax,0
	mov esi,string
l1:
	cmp byte ptr [esi],0
	je en
	inc esi
	inc eax
	jmp l1
en:
	pop esi
	pop ebp
	ret
slength endp

end main
