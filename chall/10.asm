.386
include Irvine32.inc

.data
	array dword 1000 dup (0), 0
	sz dword 0
	msg1 byte "Nhap so phan tu: ",0
	msg2 byte "Nhap cac phan tu: ", 13, 10, 0
	odd dword 0
	eve dword 0
	msg3 byte "Tong chan = ",0
	msg4 byte "Tong le = ",0
.code
main proc
	mov edx,offset msg1
	mov ecx,lengthof msg1
	call WriteString
	call ReadInt
	mov sz, eax
	mov ecx,lengthof msg2
	mov edx,offset msg2 
	call WriteString
	mov ecx,sz
	mov edi,offset array
l1:
	call ReadInt
	stosd
	loop l1
	;
	mov esi,offset array
	mov ecx,sz
l2:
	lodsd
	test eax,1
	jz sochan
	add odd,eax
	loop l2
	jmp conti
sochan:
	add eve,eax
	loop l2
conti:
	mov edx, offset msg3
	mov ecx, lengthof msg3
	call WriteString
	mov eax,eve
	call WriteInt
	call Crlf
	mov edx,offset msg4
	mov ecx,lengthof msg4
	call WriteString
	mov eax,odd
	call WriteInt
	call Crlf
	call WaitMsg
	push 0 
	call exitprocess
main endp
end main
