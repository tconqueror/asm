.386
.model flat,stdcall
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	msg byte "Enter the length of the string you want to create: ",0
	len dword ?
	string byte ?

.code
main proc
	mov edx,offset msg
	call WriteString
	call ReadInt
	mov ecx,eax
l1:
	call bla
	loop l1

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp


bla proc uses ecx
	mov eax,26
	call RandomRange
	add eax,65
	call WriteChar
	ret
bla endp
end main
