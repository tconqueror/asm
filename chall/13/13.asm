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
hex byte "0123456789ABCDEF",0
ValDosHeader byte 0,"e_magic",0,"e_cblp",0,"e_cp",0,"e_crlc",0,"e_cparhdr",0,"e_minalloc",0
			 byte "e_maxalloc",0,"e_ss",0,"e_sp",0,"e_csum",0,"e_ip",0,"e_cs",0
			 byte "e_lfarlc",0,"e_ovno",0,"e_res",0,"e_oemid",0,"e_oeminfo",0
			 byte "e_res2",0,"e_lfanew",0 
KeyDosHeader dword 0h,00000002h,00000004h,00000006h,00000008h,0000000Ah,0000000Ch
			 dword 0000000Eh,00000010h,00000012h,00000014h,00000016h,00000018h,0000001Ah
			 dword 0000001Ch,00000024h,00000026h,00000028h,0000003Ch
SzDosHeader byte 18 dup (2),4
dot byte 20 dup ('_'),0
.code
main PROC
	;mov eax,15
	;call WriteALHex
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
	call DosHeader
	
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
writeALHex proc
	pushad 
	xor edx,edx
	and eax,255
	mov ebx,16
	div bl 
	;ah va al
	movzx ebx,ah
	push ebx
	and eax,0FFh
	add eax, offset hex
	mov al,byte ptr [eax]
	call WriteChar
	pop eax
	add eax,offset hex
	mov al, byte ptr [eax]
	call WriteChar
	;
	popad
	ret
writeALHex endp
writeBufHex proc
	;offset - so luong 
	push ebp
	mov ebp, esp
	pushad
	mWrite <"0x">
	mov ecx, dword ptr [ebp+8]
	mov esi,ecx
	;shl esi,2 
	add esi, dword ptr [ebp+12]
	dec esi
lWriteBufHex:
	std
	lodsb
	call writeALHex
	loop lWriteBufHex
	
	popad
	pop ebp
	ret 8 
writeBufHex endp
showOptionLine proc
	;offset name - offset offset - offset size
	push ebp
	mov ebp,esp
	pushad
	mWrite <09h>
	mov edx,dword ptr [ebp+16]
	call WriteString
	invoke Str_length,edx
	mov ebx,20
	sub ebx,eax
	push offset dot
	push ebx
	call writeBuf
	
	;name
	;mWrite <09h,09h,9h>
	mov eax,dword ptr [ebp+12]
	mov eax,dword ptr [eax]
	push eax
	call WriteHex
	;dia chi
	mWrite <09h>
	mov eax,dword ptr [ebp+8]
	movzx eax,byte ptr [eax]
	push eax
	call WriteDec
	;soluong
	mWrite <09h>
	;done, now will be value
	call getBuf
	push offset buf
	mov eax,dword ptr [ebp+8]
	movzx eax,byte ptr [eax]
	push eax
	call writeBufHex
	call Crlf
	popad
	pop ebp
	ret 12
showOptionLine endp
showOption proc
	;offset name - offset offset - offset size - number
	push ebp
	mov ebp,esp
	pushad
	xor ecx,ecx
	mov edi, dword ptr [ebp+20]		;name
loopShowOption:
	cmp ecx, dword ptr [ebp+8]
	je enShowOption
	push ecx
	mov ecx,0FFFFh
	xor eax,eax
	repne scasb
	push edi
	;push edi
	lea eax,[esp+4]
	mov eax,dword ptr [eax]
	mov ebx,eax
	shl ebx,2 
	add ebx, dword ptr [ebp+16]
	push ebx
	add eax,dword ptr [ebp+12]
	push eax
	call showOptionLine
	;pop edi
	pop ecx
	inc ecx
	jmp loopShowOption
enShowOption:
	popad
	pop ebp
	ret 16
showOption endp
DosHeader proc
	pushad
	mWrite <"DosHeader:",0ah>
	;mWrite <9h,"e_magic_____________","00000000",9h,"2",9,"0x4D5A",0ah>
	push offset ValDosHeader
	push offset KeyDosHeader
	push offset SzDosHeader
	push lengthof SzDosHeader
	call showOption
	popad
	ret
DosHeader endp
Initialize PROC 
	pushad
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov [stdout],eax
	popad
	ret
Initialize ENDP
END main
