.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	str1 byte 100 dup (0), 0
	str2 byte 10 dup (0), 0
	msg byte "Can't not find!!!", 0
	msg1 byte "Xau me: ", 0
	msg2 byte "Xau con: ", 0
	msg3 byte "Vi tri cac xau con: ", 0
.code
main proc
	mov edx, offset msg1
	call WriteString
	mov edx,offset str1
	mov ecx,lengthof str1
	call ReadString

	mov edx, offset msg2
	call WriteString
	mov edx, offset str2
	mov ecx, lengthof str2
	call ReadString

	push offset str1
	push offset str2
	call sfind
	jnz x
	;call WriteDec
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
	;edi chua dia chi cuoi cung cua xau me
	;esi chua dia chi cuoi cung cua xau con
	mov ecx,len1	;lay dieu kien loop de xac dinh neu xau con k xuat hien
l1:
	mov esi,ebx
	repne scasb
	jecxz conti
	push edi
	inc edx
	jmp l1
conti:
	cld
	cmp edx,0
	je conti3
	dec ebx
conti2:
	cmp edx,0
	je conti4
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
	mov eax,edi
	;inc eax
	sub eax,s1
	sub eax,len2
	call WriteDec
	call Crlf
	jmp conti2
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
