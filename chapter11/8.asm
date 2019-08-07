include Irvine32.inc

.data
	xypos coord <0,0>
	stdout handle ?
.code
main proc
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov stdout, eax
l1:
	call bla
	jmp l1
	invoke exitprocess,0 
main endp
bla proc
	pushad
	mov eax, 25
	call RandomRange
	mov xypos.X, ax

	mov eax, 80
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
