.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data

.code
main proc
	mov ecx,15
l1:
	push white
	push ecx
	call bla
	pop ecx
	mov eax,500
	call Delay
	loop l1
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
.data
	x equ dword ptr [ebp-4]
	y equ dword ptr [ebp-8]
.code
	call Clrscr
	push ebp
	mov ebp,esp
	sub esp,8
	mov x,0
	mov y,0
	pushad
	mov esi,dword ptr [ebp+8]		;get 2 color
	mov edi,dword ptr [ebp+12]
l1:
	cmp x,8
	jnb en
l2:
	cmp y,8
	jnb l4
	;in
	mov ebx,x
	add ebx,y
	test ebx,1
	jz l3
	mov eax,esi
	jmp l5
l3:
	mov eax,edi
l5:
	call SetTextColor
	mov eax,254
	call WriteChar
	inc y
	jmp l2
l4:
	mov y,0
	inc x
	call Crlf
	jmp l1

en:
	popad
	add esp,8
	pop ebp
	ret
bla endp
end main
