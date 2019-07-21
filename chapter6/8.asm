.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	msg byte "Enter the message: ",0
	key byte "blablabla",0
	buf byte 255 dup (0)
	lenbuf byte ?
	len = ($ - key) - 1
.code
main proc
	mov edx,offset msg
	call WriteString
	mov edx, offset buf
	mov ecx, sizeof	buf
	call ReadString
	mov lenbuf,al
	;read

	movzx ecx,al
	mov esi,offset buf
	pushad
	mov edi,offset key
	push edi
l1:
	mov al, byte ptr [esi]
	mov bl, byte ptr [edi]
	xor al,bl
	call WriteChar
	mov byte ptr [esi],al
	inc esi
	inc edi
	mov al,byte ptr [edi]
	cmp al,0
	je l2 
	loop l1
	jmp rtrn
l2:
	pop edi
	push edi
	loop l1
rtrn:
	popad
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
	
	ret
bla endp

end main
