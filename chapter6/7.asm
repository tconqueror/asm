.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	msg byte "This is an fking message!",0
.code
main proc
	mov ecx,10
l1:
	call bla
	call Crlf
	loop l1
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
	pushad
	mov eax,9
	call RandomRange
	;mov eax,1
	cmp eax,3
	jb w
	cmp eax,4
	jb b
	jmp g
w: 
	mov eax,15
	call SetTextColor
	jmp write
b:
	mov eax,1
	call SetTextColor
	jmp write
g:
	mov eax,2
	call SetTextColor
write:
	mov edx,offset msg
	call WriteString
	popad
	ret
bla endp

end main
