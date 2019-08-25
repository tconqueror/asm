.386

include Irvine32.inc

.data
	msg byte "Nhap chuoi: ",0
	msg2 byte "Chuoi da bi dao nguoc: ",0
	buf byte 256 dup (0), 0
.code
main proc

main endp
bla proc
	mov edx,offset msg
	call WriteString
	mov edx,offset buf
	mov ecx,lengthof buf
	call ReadString
	mov ecx,eax
	mov esi,offset buf
l1:
	push [esi]
	inc esi
	loop l1
	mov ecx,eax
	mov edx,offset msg2
	call WriteString
l2:
	pop eax
	call WriteChar
	loop l2

	call Crlf
	call WaitMsg

	push 0
	call exitprocess
bla endp
end main
