.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	buf byte 1000 dup (?)
	msg1 byte "Enter the string: ",0
	msg2 byte "What is the character you want to remove from the leading of the string? ",0
	msg3 byte "String after trim: ",0
.code
main proc
	mov edx,offset msg1
	call WriteString
	mov edx,offset buf
	mov ecx,lengthof buf
	call ReadString
	push offset buf
	push eax
	xor eax,eax
	mov edx,offset msg2
	call WriteString
	call ReadChar
	push eax
	call strim
	call Crlf
	mov edx,offset msg3
	call WriteString
	mov edx,offset buf
	call WriteString
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

strim proc
.data
	char equ dword ptr [ebp+8]
	len equ dword ptr [ebp+12]
	string equ dword ptr [ebp+16]
.code
	push ebp
	mov ebp,esp

	mov eax,char
	mov edi,string
	mov ecx,len
	repe scasb 
	mov esi,edi
	add ecx,2
	dec esi
	mov edi,string
	rep movsb
	pop ebp
	ret 12
strim endp
end main
