include Irvine32.inc

.data
	msg byte ". This is a fking message!",0dh,0ah,0
	windowRec SMALL_RECT <0,0,50,10>
	stdout handle ?
.code
main proc
	mov ecx,50
	mov eax,0
l1:
	call WriteDec
	mov edx,offset msg
	call WriteString
	inc eax
	loop l1
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov stdout, eax
	mov ecx,50
l2:
	push ecx
	invoke SetConsoleWindowInfo ,stdout, TRUE, addr windowRec
	inc windowRec.Top
	inc windowRec.Bottom
	mov eax,500
	call Delay
	pop ecx
	loop l2

	call WaitMsg
	exit
main endp
end main
