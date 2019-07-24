.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	plaintext byte "hellohellohellohello",0
	key byte -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
.code
main proc 
	mov esi,offset plaintext
	mov edi,offset key
	mov ecx,lengthof key
	call bla
	mov edx,offset plaintext
	call WriteString
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp
bla proc
;process to encrypt the plaintext
;esi receive the offset of plaintext
;edi receive the offset of the key
;ecx receive the length of the key
;return nothing

	pushad
	push ecx
	push edi

; khoi tao lai key
l1:
	movzx eax,byte ptr [edi]
	cmp al,0
	jns x
	add al,8
	mov byte ptr [edi],al
x:	
	inc edi
	loop l1
	pop edi
	pop ecx
	xor edx,edx
pro:
	movzx eax,byte ptr [esi]
	push ecx
	mov cl,byte ptr [edi]
	ror al,cl
	pop ecx
	;call WriteChar
	mov byte ptr [esi],al
	inc esi
	inc edi
	inc edx
	cmp byte ptr [esi],0
	je en
	cmp edx,ecx
	jne conti
	pop edi
	push edi
	xor edx,edx
conti:
	jmp pro
en:
	cmp edx,0
	jne p
	pop edi
p:
	popad
	ret
bla endp
end main
