.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib
.data
	s byte "Surprise Mother Fucker",0
	msg byte "Can't find!!!",0
.code
main proc
	push offset s
	push ' '
	call nextWord
	jz tru
	mov edx,offset msg
	call WriteString
	jmp en
tru:
	mov edx,eax
	call WriteString
en:
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

nextWord proc
.data
	string equ dword ptr [ebp+12] 
	char equ dword ptr [ebp+8]
.code	
	push ebp
	mov ebp,esp
	push ecx
	push edi
	push string
	call slength
	pop edi
	mov ecx,eax
	mov eax,char
	repne scasb 
	jecxz en0
	mov eax,edi
	cmp eax,eax
	jmp en
en0:
	cmp ecx,1
	jmp en
en:
	pop edi
	pop ecx
	pop ebp
	ret
nextWord endp

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
