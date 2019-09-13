; Reading a File                      (ReadFile.asm)

; Opens, reads, and displays a text file using
; procedures from Irvine32.lib. 

INCLUDE Irvine32.inc
INCLUDE macros.inc

BUFFER_SIZE = 5000

.data
buffer BYTE BUFFER_SIZE DUP(?)
filename    BYTE 80 DUP(0)
fileHandle  HANDLE ?
stdout handle ?
byteWritten dword 0
.code
main PROC
	call Initialize
; Let user input a filename.
	mWrite "Enter an input filename: "
	mov	edx,OFFSET filename
	mov	ecx,SIZEOF filename
	call	ReadString

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

; Read the file into a buffer.
	mov	edx,OFFSET buffer
	mov	ecx,BUFFER_SIZE
	call	ReadFromFile
	jnc	check_buffer_size			; error reading?
	mWrite "Error reading file. "		; yes: show error message
	call	WriteWindowsMsg
	jmp	close_file
	
check_buffer_size:
	cmp	eax,BUFFER_SIZE			; buffer large enough?
	jb	buf_size_ok				; yes
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	jmp	quit						; and quit
	
buf_size_ok:	
	mov	buffer[eax],0		; insert null terminator
	mWrite "File size: "
	call	WriteDec			; display file size
	call	Crlf

; Display the buffer.
	mWrite <"Buffer:",0dh,0ah,0dh,0ah>
	mov	edx,OFFSET buffer	; display the buffer
	;call	WriteString
	;call	Crlf
	push offset buffer
	push 10
	call writeBuf

close_file:
	mov	eax,fileHandle
	call	CloseFile


quit:
	call Crlf
	call WaitMsg
	exit
main ENDP

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