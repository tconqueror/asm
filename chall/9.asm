.386
include Irvine32.inc

.data
	array dword 1000 dup (0), 0
	sz dword 0
	msg1 byte "Nhap so phan tu: ",0
	msg2 byte "Nhap cac phan tu: ", 13, 10, 0
	max dword 0
	min dword 0
	msg3 byte "Max = ",0
	msg4 byte "Min = ",0
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
	mov eax,offset array
	mov eax,dword ptr [eax]
	mov max, eax
	mov min, eax
	mov esi,offset array
	add edi,4
	mov ecx,sz
l2:
	lodsd
	cmp eax,max
	jg chgmax
	cmp eax,min
	jl chgmin
	loop l2
	jmp conti
chgmax:
	mov max,eax
	loop l2
chgmin:
	mov min,eax
	loop l2
conti:
	mov edx, offset msg3
	mov ecx, lengthof msg3
	call WriteString
	mov eax,max
	call WriteInt
	call Crlf
	mov edx,offset msg4
	mov ecx,lengthof msg4
	call WriteString
	mov eax,min
	call WriteInt
	call Crlf
	call WaitMsg
	push 0 
	call exitprocess
main endp
end main
