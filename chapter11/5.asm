include Irvine32.inc

.data
	box byte 169, 10 dup (45), 170, 10, 13, 179,10 dup (32), 179, 10, 13, 179,10 dup (32), 179, 10, 13, 179,10 dup (32), 179, 10, 13, 217, 10 dup (45), 217, 0
	len equ ($- box)
	stdin handle ?
	stdout handle ?
	consoleinf CONSOLE_SCREEN_BUFFER_INFO <>
	byteWritten dword ?
	xypos coord <0,0>
.code
main proc
	call init
	mov eax,len
	invoke WriteConsole, stdout, addr box, eax, addr byteWritten,0
	call Crlf
	call WaitMsg
	invoke exitprocess,0
main endp
init proc
	pushad
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov stdin,eax
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov stdout,eax
	popad
	ret

init endp
end main
