.386
include Irvine32.inc

.data
	a byte 10000 dup (0)
	b byte 10000 dup (0)
	res byte 10000 dup (0)
	n dword 0
.code
main proc 
	push offset a
	call read

	push offset b
	call read

	push offset res
	push offset a
	push offset b
	call ad
	
	push offset res
	call dis
	jmp en
en:
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp	

read proc
;ebp+8 = offset to read
.code
	push ebp
	mov ebp,esp
	mov edx, offset res
	mov ecx, sizeof res
	call ReadString
	mov ecx,eax
	mov edi, dword ptr [ebp+8]
	cld
l1:
	movzx esi, byte ptr [edx]
	push esi
	inc edx
	loop l1
		
	mov ecx,eax
l2:
	pop eax
	stosb
	loop l2

	pop ebp
	ret 4
read endp

ad proc
;ebp+16 =res
;ebp+12 =a
;ebp+8  =b
.code
	push ebp
	mov ebp,esp						;luu nguoc va duyet nguoc
	pushad
	mov edi,dword ptr [ebp+16]		;edi chua dia chi cuoi
	xor bh,bh						;bh =carry flag (in my mind)
	cld								;clear direction flag (duyet tu dau den cuoi)
	mov ecx,9999
	mov esi, dword ptr [ebp+12]
	mov edx, dword ptr [ebp+8]
l1:
	xor ah,ah
	lodsb							;load ki tu tu nhat vao al
	add al, bh						;cong voi so du
	;aaa								;unpacked decimal
	mov bh,ah						;luu carry
	or bh,30h
	add al, byte ptr [edx]
	aaa								;unpacked decimal
	or bh,ah						;save the carry
	or bh,30h						;store in ascii
	or al,30h						;store in ascii
	stosb							;save to res pos
	inc edx							;tang bien dem len cho vong tiep theo
	mov al, byte ptr [esi]
	add al, byte ptr [edx]
	jz next
	loop l1
next:
	mov al,bh
	cmp al,30h
	jna en
	stosb
en:
	popad
	pop ebp
	ret 12
ad endp

copy proc			
;copy 100 byte from offset a to b
.data
	aa equ dword ptr [ebp+12]
	bb equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp
	pushad
	mov esi,aa
	mov edi,bb
	mov ecx,9999
	rep movsb
	popad
	pop ebp
	ret 8
copy endp

dis proc
; ebp+8 = offset to dis
.code
	push ebp
	mov ebp,esp
	xor eax,eax
	mov esi,dword ptr [ebp+8]
	mov ecx,0
l1:
	lodsb
	cmp al,0
	je en
	push eax
	inc ecx
	jmp l1
en:
	pop eax
	call WriteChar
	loop en

	pop ebp
	ret 4
dis endp
end main
