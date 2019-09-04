.386
include Irvine32.inc

.data
	msg1 byte "Nhap so a: ",0
	msg2 byte "Nhap so b: ",0
	msg3 byte "Option +-*/ ", 0
	msg4 byte "Res = ",0
	msg5 byte "Wrong option", 0
	a dword 0
	b dword 0
.code
main proc
	mov edx, offset msg1
	mov ecx, lengthof msg1
	call WriteString
	call ReadInt
	mov a,eax
	;
	mov edx,offset msg2
	mov ecx,lengthof msg2
	call WriteString
	call ReadInt
	mov b,eax
	;
	mov edx,offset msg3
	mov ecx,offset msg4
	call WriteString
	;
	call ReadChar
	cmp al,'+'
	je ad
	cmp al,'-'
	je su
	cmp al,'*'
	je im
	cmp al,'/'
	je id
	mov edx,offset msg5
	mov ecx,lengthof msg5
	call WriteString
	jmp en
ad:
	mov eax,a
	add eax,b
	call WriteInt
	jmp en
su:
	mov eax,a
	sub eax,b
	call WriteInt
	jmp en
im:
	mov eax,a
	mov ebx,b
	imul ebx
	call WriteInt
	jmp en
id:
	mov eax,a
	mov ebx,b
	xor edx,edx
	idiv ebx
	call WriteInt
en:
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp
end main
