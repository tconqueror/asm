.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	str1 byte "aaaaaaaaaaabaabb",0
	str2 byte "aab",0
	msg byte "Can't not find!!!",0
.code
main proc
	push offset str1
	push offset str2
	call sfind
	jnz x
	call WriteDec
	jmp en
x:
	mov edx,offset msg
	call WriteString
en:
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

sfind proc
.data
	s1 equ dword ptr [ebp+12]
	s2 equ dword ptr [ebp+8]
	len1 equ dword ptr [ebp-4]
	len2 equ dword ptr [ebp-8]
.code
	push ebp
	mov ebp,esp
	sub esp,8
	std
	push s1
	call slength		;lay do dai xau goc
	mov len1,eax
	pop s1
	push s2
	call slength		;lay do dai xau con
	mov len2,eax
	pop s2
	;bat dau compare
	mov edx,0
	mov edi,s1
	add edi,len1
	dec edi
	mov esi,s2
	add esi,len2
	dec esi
	mov ebx,esi
	mov al, byte ptr [esi]
	;lay dia chi cua ki tu cuoi cung
	mov ecx,len1
l1:
	mov esi,ebx
	repne scasb
	jecxz conti
	push edi
	inc edx
	jmp l1
conti:
	cmp edx,0
	je conti3
	dec ebx
conti2:
	pop edi
	dec edx
	mov ecx,len2
	dec ecx
	mov esi,ebx
	repe cmpsb
	cmp ecx,0
	jne conti2			; neu false thi tiep tuc
	;dung
tru:
	cmp edx,0
	je conti4
	pop esi
	dec edx
	jmp tru
conti4:
	mov eax,edi
	sub eax,s1
	inc eax
	add esp,8
	cmp eax,eax
	jmp en
conti3:
	add esp,8
	cmp edi,0
	je en
en:
	pop ebp
	ret
sfind endp

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
