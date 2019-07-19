.386
.model flat,stdcall
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	msg byte "Generate 100 random location:"
	maxX word ?
	maxY word ?
	curY byte ?
	curX byte ?
.code
main proc
	;mov edx, offset msg
	;call WriteString
	;call Crlf
	call GetMaxXY
	mov maxX, ax
	mov maxY, dx
	mov ecx,100
l1:
	call bla
	mov eax,100
	call Delay
	loop l1

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp


bla proc  uses ecx
	movzx eax,maxX
	call RandomRange
	;call WriteInt
	;call Crlf
	mov curX,al
	movzx eax,maxY
	call RandomRange
	;call WriteInt
	;call Crlf
	mov curY,al

	;call Crlf
	mov dh, curX
	mov dl, curY

	call GoToXY

	mov eax,26
	call RandomRange
	add eax,65
	call WriteChar
	ret
bla endp
end main
