; Reading a File                      (ReadFile.asm)

; Opens, reads, and displays a text file using
; procedures from Irvine32.lib. 
INCLUDE Irvine32.inc
INCLUDE macros.inc

BUFFER_SIZE = 5000

.data
buf BYTE 5000 DUP(0)
filename    BYTE 80 DUP (0)
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
dot byte 50 dup ('_'),0
NumberOfSections dword 0
ValNTHeader byte 0,"Signature",0 
KeyNTHeader dword 0 
SzNTHeader byte 4

ValFileHeader byte 0,"Machine",0,"NumberOfSections",0,"TimeDateStamp",0,"PointerToSymbolTable"
			  byte 0,"NumberOfSymbols",0,"SizeOfOptionalHeader",0,"Characteristics",0
KeyFileHeader dword 4,6,8,0ch,010h,014h,016h
SzFileHeader byte 2,2,4,4,4,2,2

KeyDataDirectory dword 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116
SzDataDirectory byte 30 dup (4)
ValDataDirectory 	byte 0,"Export Directory RVA"
					byte 0,"Export Directory Size"
					byte 0,"Import Directory RVA"
					byte 0,"Import Directory Size"
					byte 0,"Resource Directory RVA"
					byte 0,"Resource Directory Size"
					byte 0,"Exception Directory RVA"
					byte 0,"Exception Directory Size"
					byte 0,"Security Directory Offset"
					byte 0,"Security Directory Size"
					byte 0,"Relocation Directory RVA"
					byte 0,"Relocation Directory Size"
					byte 0,"Debug Directory RVA"
					byte 0,"Debug Directory Size"
					byte 0,"Architecture Directory RVA"
					byte 0,"Architecture Directory Size"
					byte 0,"Reserved"
					byte 0,"Reserved"
					byte 0,"TLS Directory RVA"
					byte 0,"TLS Directory Size"
					byte 0,"Load Config Directory RVA"
					byte 0,"Load Config Directory Size"
					byte 0,"Bound Import Directory RVA"
					byte 0,"Bound Import Directory Size"
					byte 0,"Import Address Table Directory RVA"
					byte 0,"Import Address Table Directory Size"
					byte 0,"Delay Import Directory RVA"
					byte 0,"Delay Import Directory Size"
					byte 0,".NET Directory RVA"
					byte 0,".NET Directory Size"
					byte 0

ValOptionalHeader  byte 0,"Magic"
				   byte 0,"MajorLinkerVersion"
				   byte 0,"MinorLinkerVersion"
				   byte 0,"SizeOfCode"
				   byte 0,"SizeOfInitializedData"
				   byte 0,"SizeOfUninitializedData"
				   byte 0,"AddressOfEntryPoint"
				   byte 0,"BaseOfCode"
				   byte 0,"BaseOfData"
				   byte 0,"ImageBase"
				   byte 0,"SectionAlignment"
				   byte 0,"FileAlignment"
				   byte 0,"MajorOperatingSystemVersion"
				   byte 0,"MinorOperatingSystemVersion"
				   byte 0,"MajorImageVersion"
				   byte 0,"MinorImageVersion"
				   byte 0,"MajorSubsystemVersion"
				   byte 0,"MinorSubsystemVersion"
				   byte 0,"Win32VersionValue"
				   byte 0,"SizeOfImage"
				   byte 0,"SizeOfHeaders"
				   byte 0,"CheckSum"
				   byte 0,"Subsystem"
				   byte 0,"DllCharacteristics"
				   byte 0,"SizeOfStackReserve"
				   byte 0,"SizeOfStackCommit"
				   byte 0,"SizeOfHeapReserve"
				   byte 0,"SizeOfHeapCommit"
				   byte 0,"LoaderFlags"
				   byte 0,"NumberOfRvaAndSizes"
				   byte 0
KeyOptionalHeader dword 0, 2, 3, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 42, 44, 46, 48, 50, 52, 56, 60, 64, 68, 70, 72, 76, 80, 84, 88, 92
SzOptionalHeader byte 2,1,1, 9 dup (4), 6 dup(2), 4,4,4,4,2,2,4,4,4,4,4,4
	
ValSectionTable 	byte 0,"VirtualSize"
					byte 0,"VirtualAddress"
					byte 0,"SizeOfRawData"
					byte 0,"PointerToRawData"
					byte 0,"PointerToRelocations"
					byte 0,"PointerToLinenumbers"
					byte 0,"NumberOfRelocations"
					byte 0,"NumberOfLinenumbers"
					byte 0,"Characteristics"
					byte 0
KeySectionTable		dword 8,12,16,20,24,28,32,34,36
SzSectionTable		byte 6 dup (4),2,2,4
iData byte 2Eh, 69h, 64h, 61h, 74h, 61h,0,0
iDataVA dword 00000000
idataRawData dword 00000000
iDataRVA dword 0 
PHeader dword 0
eDataRawOffset dword 0 
eData dword 0
ValExportDirectory 	byte 0, "Characteristics"
					byte 0, "TimeDateStamp"
					byte 0, "MajorVersion"
					byte 0, "MinorVersion"
					byte 0, "Name"
					byte 0, "Base"
					byte 0, "NumberOfFunctions"
					byte 0, "NumberOfNames"
					byte 0, "AddressOfFunctions"
					byte 0, "AddressOfNames"
					byte 0, "AddressOfNameOrdinals"
					byte 0
KeyExportDirectory 	dword 0,4,8,10,12,16,20,24,28,32,36
SzExportDirectory byte 4,4,2,2, 7 dup (4)
.code
main PROC
	;mov eax,15
	;call WriteALHex
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
	call Crlf
	call PEHeader
	call Crlf
	call SectionTable
	call Crlf 
	call ImportTable
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
	;offset start - offset name - offset offset - offset size
	push ebp
	mov ebp,esp
	pushad
	mWrite <09h>
	mov edx,dword ptr [ebp+16]
	call WriteString
	invoke Str_length,edx
	mov ebx,35
	sub ebx,eax
	push offset dot
	push ebx
	call writeBuf
	
	;name
	;mWrite <09h,09h,9h>
	mov eax,dword ptr [ebp+12]
	mov eax,dword ptr [eax]
	add eax,dword ptr [ebp+20]
	push eax
	call WriteHex
	;dia chi
	mWrite <09h>
	mov eax,dword ptr [ebp+8]
	movzx eax,byte ptr [eax]
	;add eax, dword ptr [ebp+20]
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
	ret 16
showOptionLine endp

showOptionW proc
	;start offset - offset name - offset offset - offset size - number 
	push ebp
	mov ebp,esp
	pushad
	xor ecx,ecx
	mov edi, dword ptr [ebp+20]		;name
loopShowOptionW:
	cmp ecx, dword ptr [ebp+8]
	je enShowOptionW
	push ecx
	mov ecx,0FFFFh
	push dword ptr [ebp+24]
	xor eax,eax
	repne scasb
	push edi
	;push edi
	lea eax,[esp+8]
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
	jmp loopShowOptionW
enShowOptionW:
	popad
	pop ebp
	ret 20
showOptionW endp
DosHeader proc
	pushad
	mWrite <"DosHeader:",0ah>
	;mWrite <9h,"e_magic_____________","00000000",9h,"2",9,"0x4D5A",0ah>
	push 0
	push offset ValDosHeader
	push offset KeyDosHeader
	push offset SzDosHeader
	push lengthof SzDosHeader
	call showOptionW
	popad
	ret
DosHeader endp
PEHeader proc
	pushad
	push 03Ch
	push 4
	call getBuf
	mov eax, dword ptr [buf]
	mov dword ptr [PHeader],eax
	mWrite <"NT Header:",0ah>
	push dword ptr [PHeader]
	push offset ValNTHeader
	push offset KeyNTHeader
	push offset SzNTHeader
	push lengthof SzNTHeader
	call showOptionW
	
	mWrite <"File Header:",0ah>
	push dword ptr [PHeader]
	push offset ValFileHeader
	push offset KeyFileHeader
	push offset SzFileHeader
	push lengthof SzFileHeader
	call showOptionW
	
	mWrite <"Optional Header",0ah>
	mov eax,dword ptr [PHeader]
	add eax,24
	push eax
	push offset ValOptionalHeader
	push offset KeyOptionalHeader
	push offset SzOptionalHeader
	push lengthof SzOptionalHeader
	call showOptionW
	
	mWrite <"Data Directories:",0ah>
	mov eax,dword ptr [PHeader]
	add eax,78h
	;call WriteHex
	push eax 
	push offset ValDataDirectory
	push offset KeyDataDirectory
	push offset SzDataDirectory
	push lengthof SzDataDirectory
	call showOptionW
	
	popad
	ret
PEHeader endp

SectionTable proc
	push ebp
	mov ebp,esp
	pushad	
	;pe +6 
	mWrite <"Section Table:",0ah>
	mov esi,dword ptr [PHeader]
	mov edx,esi
	add edx,248
	add esi,6
	push esi
	push 2
	call getBuf
	movzx eax, word ptr [buf]
	mov word ptr [NumberOfSections],ax
	xor ecx,ecx
	
loopSectionTable:
	cmp cx,word ptr [NumberOfSections]
	jz enSectionTable
	push ecx
	push edx
	mWrite <"No.">
	mov eax,ecx
	call WriteDec
	mWrite <":",0ah>
	;edx will be the offset of each section
	mWrite <09h,"Name: ">
	push edx
	push 8
	call showBuf
	call Crlf
	push edx	
	push offset ValSectionTable
	push offset KeySectionTable
	push offset SzSectionTable
	push lengthof SzSectionTable
	call showOptionW
	pop edx
	pop ecx
	inc ecx
	add edx,40
	jmp loopSectionTable

enSectionTable:
	popad
	pop ebp
	ret
SectionTable endp
ImportTable proc
	pushad
	mWrite <"Import Table: ",0ah>
	
	mov eax,dword ptr [PHeader]
	add eax,80h
	push eax
	push 4
	call getBuf
	mov eax, dword ptr [buf]
	;call WriteHex
	mov dword ptr [iDataRVA],eax
	
	mov esi,dword ptr [PHeader]
	mov edx,esi
	add edx,248
	add esi,6
	push esi
	push 2
	call getBuf
	movzx eax, word ptr [buf]
	mov word ptr [NumberOfSections],ax
	xor ecx,ecx
	
loopImportTable:
	cmp cx,word ptr [NumberOfSections]
	jz enImportTable
	push ecx
	push edx
	push 8
	call getBuf
	mov eax,dword ptr [buf]
	cmp eax,dword ptr [iData]
	jnz conti
	mov eax, dword ptr [buf+4]
	cmp eax, dword ptr [iData+4]
	jnz conti
	mov eax,edx
	add eax,12
	push eax
	push 4
	call getBuf
	mov esi, dword ptr [buf]
	mov dword ptr [iDataVA],esi
	add eax,8 
	push eax
	push 4
	call getBuf
	mov esi,dword ptr [buf]
	mov dword ptr [idataRawData],esi
	push dword ptr [iDataRVA]
	call calRVAImportTable
	;add eax,20
loop1:
	push eax
	add eax,20
	call readModulImport
	jnz loop1
conti:
	pop ecx
	inc ecx
	add edx,40
	jmp loopImportTable

enImportTable:
	popad
	ret
ImportTable endp
calRVAImportTable proc
	;receive rva -> raw offset 
	push ebp
	mov ebp,esp
	push ebx
	mov eax, dword ptr [iDataVA]
	sub eax, dword ptr [idataRawData]
	mov ebx, dword ptr [ebp+8]
	sub ebx, eax
	xchg eax, ebx
	pop ebx
	pop ebp
	ret 4 
calRVAImportTable endp

readModulImport proc
.data
	importNameRVA dword 0 
	OFTs dword 0 
.code
	;offset 
	push ebp
	mov ebp,esp
	pushad
	
	mov edx, dword ptr [ebp+8]
	push edx
	push 20
	call getBuf
	mov eax, dword ptr [buf]
	or eax,eax
	jz enOfEndReadModulImport
	mov dword ptr [OFTs], eax
	mov eax, dword ptr [buf+12]
	mov dword ptr [importNameRVA],eax
	push dword ptr [importNameRVA]
	call calRVAImportTable
	push eax
	push 20
	call getBuf
	mov edx,offset buf
	call WriteString
	;	ten cua dll
	call Crlf
	;xuong dong
	push dword ptr [OFTs]
	call calRVAImportTable
	; <<-- this
readProc:
	push eax
	push 4
	call getBuf
	cmp dword ptr [buf],0 
	jz contiReadModulImport
	push eax
	mov eax, dword ptr[buf]		;eax chua 
	push eax
	call calRVAImportTable
	add eax,2 
	push eax
	push 50 
	call getBuf
	mWrite <9h>
	mov edx,offset buf
	call WriteString
	call Crlf
	pop eax
	add eax,4 
	jmp readProc
enOfEndReadModulImport:
	xor eax,eax
	jmp enReadModulImport
contiReadModulImport:
	xor eax,ebp
enReadModulImport:
	popad
	pop ebp
	ret 4
readModulImport endp
Findedata proc
	push ebp
	mov ebp,esp
	pushad	
	;pe +6 
	;mWrite <"Section Table:",0ah>
	mov esi,dword ptr [PHeader]
	mov edx,esi
	add edx,248
	add esi,6
	push esi
	push 2
	call getBuf
	movzx eax, word ptr [buf]
	mov word ptr [NumberOfSections],ax
	xor ecx,ecx
	
loopFindedata:
	cmp cx,word ptr [NumberOfSections]
	jz enFindedata
	push ecx
	push edx
	;mWrite <"No.">
	;mov eax,ecx
	;call WriteDec
	;mWrite <":",0ah>
	;edx will be the offset of each section
	;mWrite <09h,"Name: ">
	push edx
	push 8
	call getBuf
	mov eax, dword ptr [eData]
	cmp eax, dword ptr [buf]
	jnz conti
	mov eax, dword ptr [eData+4]
	cmp eax, dword ptr [buf+4]
	jnz conti
	;found
	mov eax,edx
	add eax,20
	push eax
	push 4
	call getBuf
	mov eax,dword ptr [buf]
	;call WriteHex
	mov dword ptr[eDataRawOffset],eax
	push eax
	push offset ValExportDirectory
	push offset KeyExportDirectory
	push offset SzExportDirectory
	push lengthof SzExportDirectory
	call showOptionW
conti:
	pop edx
	pop ecx
	inc ecx
	add edx,40
	jmp loopFindedata

enFindedata:
	popad
	pop ebp
	ret
Findedata endp
ExportDirectories proc
	pushad
	mWrite <"Export Directory ...",0ah>
	mov eax,dword ptr [PHeader]
	add eax,078h
	push eax
	push 4
	call getBuf
	cmp dword ptr [buf],0
	je NullExport
	call Findedata
	
	jmp enExportDirectories
NullExport:
	mWrite <"There is no Export Directory",0ah>
enExportDirectories:
	popad
	ret
ExportDirectories endp

ImportDirectories proc
	pushad
	
	popad
	ret
importDirectories endp
Initialize PROC 
	pushad
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov [stdout],eax
	popad
	ret
Initialize ENDP
END main
