.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	buf byte 1000 dup (?)
	trim byte  1000 dup (?)
	msg1 byte "Enter the string: ",0
	msg2 byte "Enter the set of character you want to remove from the end of the string: ",0
	msg3 byte "String after trim: ",0
.code
main proc
	mov edx,offset msg1
	call WriteString
	;display 
	mov edx,offset buf
	mov ecx,lengthof buf
	call ReadString
	;read target
	push offset buf
	;push to call
	push eax
	;display
	mov edx,offset msg2
	call WriteString
	mov edx,offset trim
	mov ecx,lengthof trim
	call ReadString
	push offset trim
	push eax
	comment ?
	push offset buf
	push lengthof buf
	push offset trim
	push lengthof trim
	?
	call strim
	call Crlf

	mov edx,offset msg3
	call WriteString
	mov edx,offset buf
	call WriteString
	;end of displaying
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

strim proc
.data
	lent equ dword ptr [ebp+8]
	tri equ dword ptr [ebp+12]
	lens equ dword ptr [ebp+16]
	string equ dword ptr [ebp+20]
.code
	push ebp
	mov ebp,esp
	cld
	
	mov esi,string
	add esi,lens
	mov ecx,lens
	;esi chua dia chi cua byte dang xet
	;edi chua trimstring to load
l1:
	dec esi
	push ecx
	mov al,byte ptr [esi]
	mov edi,tri

	mov ecx,lent
	inc ecx
	repne scasb
	jecxz en
	mov byte ptr [esi],0
	pop ecx
	loop l1
en:
	pop ecx
	pop ebp
	ret 16
strim endp
end main
