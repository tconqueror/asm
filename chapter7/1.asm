.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

decimal_offset = 5
.data
	decimal_one byte "1235467890987565"
	len1 equ $ - decimal_one
	decimal_two byte "9871234561239"
	len2 equ $ - decimal_two
	decimal_three byte "31"
	len3 equ $ - decimal_three

.code
main proc
	mov edx,offset decimal_one
	mov ecx,len1
	call bla
	call Crlf

	mov edx,offset decimal_two
	mov ecx,len2
	call bla
	call Crlf

	mov edx,offset decimal_three
	mov ecx,len3
	call bla
	call Crlf


	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
.data
	first byte "0.",0
.code
	pushad
	cmp ecx,5
	jg l1
	push edx
	push ecx
	mov edx,offset first
	call WriteString
	mov eax,"0"
ll:
	cmp ecx,5
	jnb lll
	mov eax,"0"
	call WriteChar
	inc ecx
	jmp ll
lll:
	pop ecx
	pop edx
llll:
	movzx eax,byte ptr [edx]
	call WriteChar
	inc edx
	loop llll
	jmp en
l1:
	sub ecx,5
l2:
	movzx eax,byte ptr [edx]
	call WriteChar
	inc edx
	loop l2
	mov eax,"."
	call WriteChar
	mov ecx,5
l3:
	movzx eax,byte ptr[edx]
	call WriteChar
	inc edx
	loop l3
en:
	popad
	ret
bla endp

end main
