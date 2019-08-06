.386

include c:\Irvine\Irvine32.inc

.data
	msg byte "Press any key to clear the screen!",0
	stdout handle ?
	stdin handle ?
	consoleInfor CONSOLE_SCREEN_BUFFER_INFO <>
.code
main proc
	;call init
	mov edx,offset msg
	call WriteS
	call ReadChar
	;
	call cls

	call WaitMsg
	push 0
	call exitprocess
main endp
init proc
.code
	pushad
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov stdout, eax
	push STD_INPUT_HANDLE
	call GetStdHandle
	mov stdin, eax
	invoke GetConsoleScreenBufferInfo, stdout, addr consoleInfor
	popad
	ret
init endp
writeS proc
.data
	byteWritten dword ?
	len dword ?
.code
	pushad
	call init
	mov ecx,0
	mov edi,edx
l1:
	cmp byte ptr [edi], 0
	je conti
	inc edi
	jmp l1
conti:
	sub edi,edx
	invoke	WriteConsole,
			stdout,
			edx,
			edi,
			addr byteWritten,
			0
	popad
	ret
writeS endp

cls proc
maxcol = 512
.data
	cursorloc coord <0,0>
	lineLength dword 0
	atri word maxcol dup (0)
	blank byte maxcol dup (' ')
	count dword ?
.code
	pushad
	call init
	mov ax, consoleInfor.dwSize.X
	mov word ptr lineLength,ax
	cmp lineLength, maxcol
	jna conti
	mov lineLength,maxcol
conti:
	mov ax,consoleInfor.wAttributes
	mov ecx,lineLength
	mov edi,offset atri
	rep stosw
	movzx ecx, consoleInfor.dwSize.Y
	
l1:
	push ecx
	invoke WriteConsoleOutputCharacter,
	stdout,
	addr blank,
	lineLength,
	cursorloc,
	addr count
	
	invoke WriteConsoleOutputAttribute,
	stdout,
	addr atri,
	lineLength,
	cursorloc,
	addr count
	
	add cursorloc.Y, 1
	pop ecx
	loop l1
	mov cursorloc.Y,0
	invoke SetConsoleCursorPosition, stdout, cursorloc
	
	popad 
	ret
cls endp
end main
