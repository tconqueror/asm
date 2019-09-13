; Reading a File                      (ReadFile.asm)

; Opens, reads, and displays a text file using
; procedures from Irvine32.lib. 

INCLUDE Irvine32.inc
INCLUDE macros.inc

BUFFER_SIZE = 5000

.data
buf BYTE 5000 DUP(?)
filename    byte "Overlong.exe",0;BYTE 80 DUP(0)
fileHandle  HANDLE ?
stdout handle ?
byteWritten dword 0
byteRead dword 0
.code
main PROC
	call Initialize
; Let user input a filename.
	;mWrite "Enter an input filename: "
	;mov	edx,OFFSET filename
	;mov	ecx,SIZEOF filename
	;call	ReadString

; Open the file for input.
	mov	edx,OFFSET filename
	call	OpenInputFile
	mov	fileHandle,eax

; Check for errors.
	cmp	eax,INVALID_HANDLE_VALUE		; error opening file?
	jne	file_ok					; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	jmp	quit						; and quit
	
file_ok:
	mWrite <"Checking...",0dh,0ah>
	push 0
	push 2
	call getBuf
	movzx eax, word ptr [buf]
	;call WriteDec
	cmp eax, 23117
	jnz notpe
	mWrite <"Yes! It's PE file",0dh,0ah>
	push 5 
	push 10 
	call showBuf
	jmp close_file
notpe:
	mWrite <"It's not PE file",0dh,0ah>
close_file:
	mov	eax,fileHandle
	call	CloseFile
quit:
	call Crlf
	call WaitMsg
	exit
main ENDP
getBuf proc
	;offset to read
	;number of byte to read
	;return to buf
	push ebp
	mov ebp,esp
	pushad
	invoke setFilePointer, fileHandle, dword ptr [ebp+12], NULL, FILE_BEGIN
	invoke ReadFile, fileHandle, offset buf, dword ptr [ebp+8], offset byteRead, null
	popad
	pop ebp
	ret 8
getBuf endp
showBuf proc
	;offset + number of byte to show up
	push ebp
	mov ebp,esp
	pushad
	push dword ptr [ebp+12]
	push dword ptr [ebp+8]
	call getBuf
	push offset buf
	push dword ptr [ebp+8]
	call writeBuf
	popad
	pop ebp
	ret 8
showBuf endp
writeBuf proc
	;offset - so luong
	push ebp
	mov ebp,esp
	pushad
	invoke WriteConsole, stdout, dword ptr [ebp+12], dword ptr [ebp+8],offset byteWritten,0
	popad
	pop ebp
	ret 8
writeBuf endp
Initialize PROC 
	pushad
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov [stdout],eax
	popad
	ret
Initialize ENDP
END main
