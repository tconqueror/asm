include Irvine32.inc

.data
	xypos coord <0,0>
	stdout handle ?
	consoleinfo CONSOLE_SCREEN_BUFFER_INFO <>
.code
main proc
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov stdout, eax
	invoke GetConsoleScreenBufferInfo, stdout, addr consoleinfo
l1:
	call bla
	jmp l1
	invoke exitprocess,0 
main endp
bla proc
	pushad
	movzx eax, consoleinfo.srWindow.Right
	inc eax
	call RandomRange
	mov xypos.X, ax

	movzx eax, consoleinfo.srWindow.Bottom
	inc eax
	call RandomRange
	mov xypos.Y, ax
	invoke SetConsoleCursorPosition, stdout, xypos

	mov eax, 16
	call RandomRange
	call SetTextColor
	
	mov eax, 219
	call WriteChar

	mov eax,50
	call Delay
	invoke SetConsoleCursorPosition, stdout, xypos
	mov eax, ' '
	call WriteChar

	popad
	ret
bla endp
end main
