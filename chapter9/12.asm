.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	table byte 16 dup (0)
	rowsize equ 4
	
.code

main proc


	call settable
	call settable
	call settable
	call settable
	call settable
	push offset table
	push 4
	push 4
	call dis

	push offset table
	call tabfindrow

	call Crlf

	push offset table
	call tabfindcol

	push offset table
	call tabfindpridia

	push offset table
	call tabfinddia

en:
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

settable proc
.data
	x equ dword ptr [ebp-4]
	y equ dword ptr [ebp-8]
.code
	push ebp
	mov ebp,esp
	sub esp,8

	push offset table
	push 4
	push 4
	call resettable

	pop ebx
	pop ebx
	pop ebx
	mov ecx,8
l1:
	mov eax,4
	call RandomRange
	mov x,eax

	mov eax,4
	call RandomRange
	mov y,eax
	;random 2 gia tri
	push offset table
	push rowsize
	push x
	push y
	call getval
	pop ebx
	pop ebx
	pop ebx
	pop ebx
	cmp eax,0
	jne conti
	call ranv
	push eax
	push offset table
	push rowsize
	push x
	push y
	call setval
	pop ebx
	pop ebx
	pop ebx
	pop ebx
	pop ebx
	loop l1
	jmp conti2
conti:
	jmp l1
conti2:				;complete generate the vowel
	mov ecx,16
	mov esi,offset table
l2:
	cmp byte ptr [esi],0
	jne conti3
	call rann
	mov byte ptr [esi],al
conti3:
	inc esi
	loop l2

	add esp,8
	pop ebp
	ret
settable endp

getval proc
.data
	tabl equ dword ptr [ebp+20]
	rows equ dword ptr [ebp+16]
	x equ dword ptr [ebp+12]
	y equ dword ptr [ebp+8]
.code	
	push ebp
	mov ebp,esp
	push ebx 
	push esi

	mov eax,rows
	mul y
	mov ebx,eax
	add ebx,tabl
	mov esi,x
	movzx eax, byte ptr [ebx+esi]

	pop esi
	pop ebx
	pop ebp
	ret
	
getval endp

setval proc
.data
	val equ dword ptr [ebp+24]
	tabl equ dword ptr [ebp+20]
	rows equ dword ptr [ebp+16]
	x equ dword ptr [ebp+12]
	y equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	push ebx
	push esi
	push eax
	mov eax,rows
	mul y
	mov ebx,eax
	add ebx,tabl
	mov esi,x
	mov eax,val
	mov byte ptr [ebx+esi],al
	pop eax
	pop esi
	pop ebx
	pop ebp
	ret
setval endp

ranv proc
.data
	vowel byte "UEOAI"
.code
	push ebp
	mov ebp,esp
	push ebx
	mov eax,5
	call RandomRange
	mov ebx,offset vowel
	add ebx,eax
	mov al,byte ptr [ebx]
	pop ebx
	pop ebp
	ret
ranv endp

rann proc
.data
	non byte "BCDFGHJKLMNPRSTVWXYZ"
.code
	push ebp
	mov ebp,esp
	push ebx
	mov eax,20
	call RandomRange
	mov ebx,offset non
	add ebx,eax
	mov al,byte ptr [ebx]
	pop ebx
	pop ebp
	ret
rann endp

dis proc
.data
	tabl equ dword  ptr [ebp+16]
	rows equ dword ptr [ebp+12]
	cols equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push esi

	mov eax,rows
	mov ebx,cols
	mul bl
	movzx ecx, al
	mov esi, tabl
	mov ebx,0
l1:
	mov al, byte ptr [esi]
	call WriteChar
	mov al,32
	call WriteChar
	inc ebx
	inc esi
	cmp ebx,cols
	je conti
	loop l1
conti:
	mov ebx,0
	call Crlf
	loop l1
	call Crlf

	pop esi
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret
dis endp

resettable proc
.data
	tabl equ dword  ptr [ebp+16]
	rows equ dword ptr [ebp+12]
	cols equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push esi
	mov eax,rows
	mov ebx,cols
	mul bl
	movzx ecx, al
	mov esi, tabl
l1:
	mov byte ptr [esi],0
	inc esi
	loop l1

	pop esi
	pop ebx
	pop eax
	pop ebp

	ret
resettable endp

check proc
.data
	char equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	push eax
	push ecx
	push edi

	mov eax,char
	mov ecx,6
l1:
	mov edi, offset vowel
	repne scasb
	jecxz fal
	cmp eax,eax
	jmp en
fal:
	cmp edi,0
en:
	pop edi
	pop ecx
	pop eax
	pop ebp
	ret 4
check endp

tabfindrow proc
.data
	tabl equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	mov edi,0
	mov esi,tabl
	mov ebx,0				;0-4
	mov ecx,17
	mov edx,0
l1:
	inc ebx
	cmp ebx,4
	jna next
	mov ebx,1
	cmp edx,2
	jne next0
	inc edi
	push ecx
	push esi
	push eax
	mov ecx,4
	sub esi,4
l2:
	mov al, byte ptr [esi]
	inc esi
	call WriteChar
	mov eax,32
	call WriteChar
	loop l2
	call Crlf
	pop eax
	pop esi
	pop ecx
next0:
	xor edx,edx
next:
	movzx eax,byte ptr [esi]
	push eax
	call check
	jnz conti
	inc edx
conti:
	inc esi
	loop l1

	pop ebp
	ret 4
tabfindrow endp

tabfindcol proc
.data
	tabl equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp

	mov esi,tabl
	mov ebx,1
	mov ecx,0
	mov edx,0
l1:
	cmp ecx,4
	je en
	cmp ebx,4
	jna l2
	mov ebx,1
	sub esi,15
	cmp edx,2
	jne ll
	inc edi
	push ecx
	push eax
	push esi
	dec esi
	mov ecx,4
lp:
	movzx eax, byte ptr [esi]
	call WriteChar
	mov eax,32
	call WriteChar
	add esi,4
	loop lp
	call Crlf
	pop esi
	pop eax
	pop ecx


ll:
	xor edx,edx
	inc ecx
l2:
	movzx eax, byte ptr [esi]
	push eax
	call check
	jnz conti
	inc edx
conti:
	add esi,4
	inc ebx
	jmp l1
en:
	pop ebp
	ret 4
tabfindcol endp

tabfindpridia proc
.data
	tabl equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	mov ebx,0
	mov esi,tabl
l1:
	cmp ebx,4
	je next
	movzx eax, byte ptr [esi]
	push eax
	call check
	jnz conti
	inc ebx
conti:
	add esi,5
	jmp l1
next:
	cmp ecx,2
	jne en
	mov esi,tabl
	mov ecx,4
l2:
	movzx eax,byte ptr [esi]
	call WriteChar
	mov al,32
	call WriteChar
	add esi,5
	loop l2
	call Crlf
	; end find in the main diag	
en:
	pop ebp
	ret 4
tabfindpridia endp

tabfinddia proc
.data
	tabl equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	mov ebx,0
	mov esi,tabl
	add esi,3
l1:
	cmp ebx,4
	je next
	movzx eax, byte ptr [esi]
	push eax
	call check
	jnz conti
	inc ebx
conti:
	add esi,3
	jmp l1
next:
	cmp ecx,2
	jne en
	mov esi,tabl
	add esi,3
	mov ecx,4
l2:
	movzx eax,byte ptr [esi]
	call WriteChar
	mov al,32
	call WriteChar
	add esi,3
	loop l2
	call Crlf
	; end find in the main diag	
en:
	pop ebp
	ret 4
tabfinddia endp

end main
