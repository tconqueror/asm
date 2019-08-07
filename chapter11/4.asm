;comment #
INCLUDE Irvine32.inc

.data
	stdin handle ?
	stdout handle ?
	consoleinfor CONSOLE_SCREEN_BUFFER_INFO <>
	xypos coord <0,0>
	attri word 4
	byteWritten dword ?
	buf byte ?
.code
main PROC
	call init
	xor edx,edx
	movzx eax,consoleinfor.dwSize.X
	mul consoleinfor.dwSize.Y
	mov ecx,eax
	;push ecx
	shr ecx,1
	push ecx
l1:
	push ecx
	movzx eax,consoleinfor.dwSize.X
	call RandomRange
	mov xypos.X, ax
	movzx eax, consoleinfor.dwSize.Y
	call RandomRange
	mov xypos.Y,ax
	invoke WriteConsoleOutputAttribute, stdout, addr attri, 1, xypos, addr byteWritten
	pop ecx
	loop l1
	;end of setup red color
	pop ecx
l3:
	push ecx
	movzx eax,consoleinfor.dwSize.X
	call RandomRange
	mov xypos.X, ax
	movzx eax, consoleinfor.dwSize.Y
	call RandomRange
	mov xypos.Y,ax
	mov eax,16
	call RandomRange
	mov attri, ax
	invoke WriteConsoleOutputAttribute, stdout, addr attri, 1, xypos, addr byteWritten
	pop ecx
	loop l3

	;end of setup color
	mov xypos.X, 0
	mov xypos.Y,0
	movzx ecx,consoleinfor.dwSize.Y
l2:
	movzx eax,consoleinfor.dwSize.X
	cmp xypos.X, ax
	jne conti
	mov xypos.X,0
	inc xypos.Y
	loop l2
conti:
	mov eax,26
	call RandomRange
	add eax,65
	mov buf, al
	push ecx
	invoke WriteConsoleOutputCharacter, stdout, addr buf, 1, xypos, addr byteWritten
	inc xypos.X
	pop ecx
	jmp l2

	call ReadChar
	INVOKE ExitProcess,0
main ENDP
init proc
	pushad
	push STD_INPUT_HANDLE
	call GetStdHandle
	mov stdin, eax
	
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov stdout, eax
	invoke GetConsoleScreenBufferInfo, stdout, addr consoleinfor
	popad
	ret
init endp

END main
;#
