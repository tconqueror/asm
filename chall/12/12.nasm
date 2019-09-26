sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4
sys_open		equ		5
sys_close		equ		6
sys_brk			equ		45
sys_newstat		equ		106

O_RDONLY		equ		0
O_WRONLY		equ		1
O_RDWR			equ		2

stdin           equ     0
stdout          equ     1
stderr          equ     2

struc STAT        
    .st_dev:        resd 1       
    .st_ino:        resd 1    
    .st_mode:       resw 1    
    .st_nlink:      resw 1    
    .st_uid:        resw 1    
    .st_gid:        resw 1    
    .st_rdev:       resd 1        
    .st_size:       resd 1    
    .st_blksize:    resd 1    
    .st_blocks:     resd 1    
    .st_atime:      resd 1    
    .st_atime_nsec: resd 1    
    .st_mtime:      resd 1    
    .st_mtime_nsec: resd 1
    .st_ctime:      resd 1    
    .st_ctime_nsec: resd 1    
    .unused4:       resd 1    
    .unused5:       resd 1    
endstruc

%define sizeof(x) x %+ _size

SECTION     .data
mgELF db "ELF header:",0
lenMgELF equ $-mgELF
szData    	db      "sys.data", 0
Data_Len    equ     $-szData
crlf db 0xd,0xa,0
lencr equ $-crlf
spc db " ",0
lenspc equ $-spc
unk db "Unknow format!",0
lenunk equ $-unk
msg1 db "File name: ",0
len1 equ $-msg1
hex db "0123456789ABCDEF",0
lenhex db $-hex
failMsg db "It's not ELF file",0
lenFail equ $-failMsg

msgMagic db "    Magic: ",0
lenMagic equ $-msgMagic

msgClass db "    Class: ",0
lenClass equ $-msgClass

msgData db "    Data: ",0
lenData equ $-msgData

msgVersion db "    Version: ",0
lenVersion equ $-msgVersion

msgOS db "    OS/ABI: ",0
lenOS equ $-msgOS

msgType db "    Type: ",0
lenType equ $-msgType

msgMachine db "    Machine: ",0
lenMAchine equ $-msgMachine

msgABIVersion db "    ABI Version: ",0
lenABIVersion equ $-msgABIVersion

msgEP db "    Entry point address: 0x",0
lenEP equ $-msgEP

msgProgramHeader db "    Start of program headers: ",0
lenProGramHeader equ $-msgProgramHeader

msgSectionHeader db "    Start of section headers: ",0
lenSectionHeader equ $-msgSectionHeader

msgFlags db "    Flags: ",0
lenFlags equ $-msgFlags

msgSizeOfThisHeader db "    Size of this header: ",0
lenSizeOfThisHeader equ $-msgSizeOfThisHeader

msgSizeOfProgramHeader db "    Size of program headers: ",0
lenSizeOfProgramHeader equ $-msgSizeOfProgramHeader

msgNumberOfProgramHeader db "    Number of program headers: ",0
lenNumberOfProgramHeader equ $-msgNumberOfProgramHeader

msgSizeOfSectionHeader db "    Size of section headers: ",0
lenSizeOfSectionHeader equ $-msgSizeOfSectionHeader

msgNumberOfSectionHeader db "    Number of section headers: ",0
lenNumberOfSectionHeader equ $-msgNumberOfSectionHeader

msgSectionHeaderStringTableIndex db "    Section header string table index: ",0
lenSectionHeaderStringTableIndex equ $-msgSectionHeaderStringTableIndex

msgELF db "ELF",0
lenELF equ $-msgELF

msgBig db "BigEndian",0
lenBig equ $-msgBig

msgLittle db "LittleEndian",0
lenLittle equ $-msgLittle

msgNA db "N/A",0
lenNA equ $-msgNA

msgCurrent db "1 (current)",0
lenCurrent equ $-msgCurrent

msgSysV db "System V",0
lenSysV equ $-msgSysV

msgHPUX db "HP-UX",0
lenHPUX equ $-msgHPUX

msgNetBSD db "NetBSD",0
lenNetBSD equ $-msgNetBSD

msgLinux db "Linux",0
lenLinux equ $-msgLinux

msgGNUHurd db "GNU Hurd",0
lenGNUHurd equ $-msgGNUHurd

msgSolaris db "Solaris",0
lenSolaris equ $-msgSolaris

msgAIX db "AIX",0
lenAIX equ $-msgAIX

msgIRIX db "IRIX",0
lenIRIX equ $-msgIRIX

msgFreeBSD db "FreeBSD",0
lenFreeBSD equ $-msgFreeBSD

msgTru64 db "Tru64",0
lenTru64 equ $-msgTru64

msgNovell db "Novell Modesto",0
lenNovell equ $-msgNovell

msgOpenBSD db "OpenBSD",0
lenOpenBSD equ $-msgOpenBSD

msgOpenVMS db "OpenVMS",0
lenOpenVMS equ $-msgOpenVMS

msgNonstop db "Nonstop Kernel",0
lenNonstop equ $-msgNonstop

msgAROS db "AROS",0
lenAROS equ $-msgAROS

msgFenix db "FenixOS",0
lenFenix equ $-msgFenix

msgCloud db "CloudABI",0
lenCloud equ msgCloud

KeyType dw 0,1,2,3,4,0xfe,0xfeff,0xff00,0xffff,0
ValType db "NONE",0,"REL",0,"EXEC",0,"DYN",0,"CORE",0,"LOOS",0,"HIOS",0,"LOPROC",0,"HIPROC",0

KeyMachine dw 0,2,3,8,0x14,0x16,0x28,0x2a,0x32,0x3e,0xb7,0xf3,0
ValMachine db "No Specific Instruction Set",0,"SPARC",0,"x86",0,"MIPS",0,"PowerPC",0,"S390",0,"ARM",0,"SuperH",0,"IA-64",0,"x86-64",0,"AArch64",0,"RISC-V",0

ox db "0x",0


SECTION     .bss
stat		resb	sizeof(STAT)
Org_Break   resd    1
TempBuf	resd 1
szFile resb 100
File_Len resd 1
temp resb 100000
tmp resb 100000
SECTION     .text
global      _start

newl:
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax,4
	mov ebx,1
	mov ecx,crlf
	mov edx,lencr
	int 0x80
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret
;------------------------------
nSpc:
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax,4
	mov ebx,1
	mov ecx,spc
	mov edx,lenspc
	int 0x80
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret
;---------------------------------
showHexP:
	;offset - soluong 
	push ebp
	mov ebp,esp
	pushad
	mov ecx, dword [ebp+8]; soluong
	mov esi, dword [ebp+12]; offset
	cld
l2:
	xor eax,eax
	xor edx,edx
	lodsb
	mov ebx,16
	div bl
	movzx ebx,al
	add ebx,hex
	mov bl,byte [ebx]
	mov byte [temp],bl
	
	movzx ebx,ah
	add ebx,hex
	mov bl,byte [ebx]
	mov byte [temp+1],bl
	push temp
	push 2 
	call print

	call nSpc

	loop l2
	popad
	pop ebp
	ret 8
;---------------------------------
showReverseHex:
	;offset - soluong 
	push ebp
	mov ebp,esp
	pushad
	mov ecx, dword [ebp+8]; soluong
	mov esi, dword [ebp+12]; offset
	std
lr2:
	xor eax,eax
	xor edx,edx
	lodsb
	mov ebx,16
	div bl
	movzx ebx,al
	add ebx,hex
	mov bl,byte [ebx]
	mov byte [temp],bl
	
	movzx ebx,ah
	add ebx,hex
	mov bl,byte [ebx]
	mov byte [temp+1],bl
	push temp
	push 2 
	call print

	;call nSpc

	loop lr2
	popad
	pop ebp
	ret 8
;---------------------------------
pDec:
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax, dword [ebp+8]
	xor ebx,ebx
	mov edi,temp
	cld
.push_char:
	xor edx,edx
	mov ecx,10
	div ecx
	add edx,30h
	push edx
	inc ebx
	test eax,eax
	jnz .push_char
	mov dword [tmp], ebx
.pop_char:
	pop eax
	stosb
	dec ebx
	test ebx,ebx
	jnz .pop_char
.print:
	mov eax,4
	mov ebx,1
	mov ecx,temp
	mov edx,dword [tmp]
	int 0x80
.end:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 4
;---------------------------------
pHex:
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax, dword [ebp+8]
	xor ebx,ebx
	mov edi,temp
	cld
.hpush_char:
	xor edx,edx
	mov ecx,16
	div ecx
	add edx,hex
	movzx edx,byte [edx] 
	push edx
	inc ebx
	test eax,eax
	jnz .hpush_char
	mov dword [tmp], ebx
.hpop_char:
	pop eax
	stosb
	dec ebx
	test ebx,ebx
	jnz .hpop_char
.hprint:
	mov eax,4
	mov ebx,1
	mov ecx,temp
	mov edx,dword [tmp]
	int 0x80
.hend:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 4
;---------------------------------
print:	
	;offset - soluong
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax,4
	mov ebx,1
	mov ecx,dword [ebp+12]
	mov edx,dword [ebp+8]
	int 0x80
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 8
;-------------------------------
writeString:
	push ebp
	mov ebp,esp
	pushad
	push dword [ebp+8]
	call strlen
	push dword [ebp+8]
	push dword [temp]
	call print
	popad
	pop ebp
	ret 4
;-------------------------------
writeTH:
	;offset
	;number
	push ebp
	mov ebp,esp
	pushad
	cld
	mov edi, dword [ebp+12]
	mov edx, dword [ebp+8]
	dec edx
	mov ecx,100000
	mov al,0
lTH:
	or edx,edx
	jz enTH
	repne scasb
	dec edx
	jmp lTH
enTH:
	push edi 
	call writeString

	popad
	pop ebp
	ret 8
;-------------------------------
scanKey:
	;key - offset key 
	;return number to tmp
	push ebp
	mov ebp,esp
	pushad
	mov eax,dword [ebp+12]
	mov edi,dword [ebp+8]
	mov ecx,100
	xor edx,edx
lScanKey:
	repne scasw
	mov eax,100
	sub eax,ecx
	mov dword [tmp],eax
	popad
	pop ebp
	ret 8
;-------------------------------

;-------------------------------
scan:		
	;offset - soluong - len
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov eax,3
	mov ebx,2
	mov ecx,dword [ebp+16]
	mov edx,dword [ebp+12]
	int 0x80
	dec eax
	mov ebx, dword [ebp+8]
	mov dword [ebx],eax
	add eax,dword [ebp+16]
	mov byte [eax],0
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 12
;---------------------------------
strlen:
;	;offset
	;return to temp
	push ebp
	mov ebp,esp
	pushad
	mov ecx,100000
	mov al,0
	mov edi,dword [ebp+8]
	cld
lstrlen:
	repne scasb
	je en
en:
	mov eax,100000
	sub eax,ecx
	mov dword [temp],eax
	popad
	pop ebp
	ret 4
;---------------------------------
_start:
	push msg1
	push len1
	call print

	push szFile
	push 100
	push File_Len
	call scan
	;~ Get file size
	mov		ebx, szFile
	mov		ecx, stat
	mov		eax, sys_newstat
	int		80H

	;~ Get end of bss section
	xor		ebx, ebx
	mov		eax, sys_brk
	int		80H
	mov		[Org_Break], eax
	mov		[TempBuf], eax
	push	eax
	
	; extend it by file size
	pop		ebx
	add		ebx, dword [stat + STAT.st_size]
	mov		eax, sys_brk
	int		80H
	
	;~ open file
	mov		ebx, szFile
	mov		ecx, O_RDONLY
	xor		edx, edx
	mov		eax, sys_open
	int		80H
    xchg    eax, esi
	
	;~ read in file to buffer
	mov     ebx, esi
	mov		ecx, [TempBuf]
	mov		edx, dword [stat + STAT.st_size]
	mov		eax, sys_read
	int		80H
	;
;show elf header
	mov eax, dword [TempBuf]
	mov eax, dword [eax]
	cmp eax, 1179403647
	jnz notELF
	push mgELF
	push lenMgELF
	call print
	call newl
	;--------------------------------
	push msgMagic
	push lenMagic
	call print

	push dword [TempBuf]
	push 16
	call showHexP
	call newl
	;---------------------------------
	;Class
	push msgClass
	push lenClass
	call print
	;
	push msgELF
	push lenELF
	call print
	mov ebx,dword  [TempBuf]
	add ebx,4
	movzx eax,byte [ebx]
	cmp eax,1
	je class32
class64:
	push 64
	call pDec
	jmp contiClass
class32:
	push 32
	call pDec
contiClass:
	call newl
	;-------------------------------
	;data
	push msgData
	push lenData
	call print
	;
	inc ebx
	movzx eax,byte [ebx]
	cmp eax,1
	je datalittle
databig:
	push msgBig
	push lenBig
	call print
	jmp contiData
datalittle:
	push msgLittle
	push lenLittle
	call print
contiData:
	call newl 
	;----------------------------------
	;version
	push msgVersion
	push lenVersion
	call print
	;
	inc ebx
	movzx eax,byte [ebx]
	cmp eax,1
	je current
na:	
	push msgNA
	push lenNA
	call print
	jmp contiVersion
current:
	push msgCurrent
	push lenCurrent
	call print
contiVersion:
	call newl
	;-----------------------------------
	;os/abi
	push msgOS
	push lenOS
	call print
	;
	inc ebx
	movzx eax,byte [ebx]
	cmp eax,0
	je SysV
	cmp eax,1
	je HPUX
	cmp eax,2
	je NetBSD
	cmp eax,3
	je Linux
	cmp eax,4
	je GNUHurd
	cmp eax,6
	je Solaris
	cmp eax,7
	je AIX
	cmp eax,8
	je IRIX
	cmp eax,9
	je FreeBSD
	cmp eax,10
	je Tru64
	cmp eax,11
	je Novell
	cmp eax,12
	je OpenBSD
	cmp eax,13
	je OpenVMS
	cmp eax,14
	je Nonstop
	cmp eax,15
	je AROS
	cmp eax,16
	je Fenix
CloudABI:
	push msgCloud
	push lenCloud
	call print
	jmp contiOS
Fenix:
	push msgFenix
	push lenFenix
	call print
	jmp contiOS
AROS:
	push msgAROS 
	push lenAROS 
	call print
	jmp contiOS
Nonstop:
	push msgNonstop
	push lenNonstop
	call print
	jmp contiOS
OpenVMS:
	push msgOpenVMS
	push lenOpenVMS
	call print
	jmp contiOS
OpenBSD:
	push msgOpenBSD
	push lenOpenBSD
	call print
	jmp contiOS
Novell:
	push msgNovell
	push lenNovell
	call print
	jmp contiOS
Tru64:
	push msgTru64
	push lenTru64
	call print
	jmp contiOS
FreeBSD:
	push msgFreeBSD
	push lenFreeBSD
	call print
	jmp contiOS
IRIX:
	push msgIRIX
	push lenIRIX
	call print
	jmp contiOS
AIX:
	push msgAIX
	push lenAIX
	call print
	jmp contiOS
Solaris:
	push msgSolaris
	push lenSolaris
	call print
	jmp contiOS
GNUHurd:
	push msgGNUHurd
	push lenGNUHurd
	call print
	jmp contiOS
Linux:
	push msgLinux
	push lenLinux
	call print
	jmp contiOS
NetBSD:
	push msgNetBSD
	push lenNetBSD
	call print
	jmp contiOS
HPUX:
	push msgHPUX
	push lenHPUX
	call print
	jmp contiOS
SysV:
	push msgSysV
	push lenSysV
	call print
	jmp contiOS
contiOS:
	call newl
	;------------------------------
	;abiversion
	push msgABIVersion
	push lenABIVersion
	call print
	;
	inc ebx
	movzx eax,byte [ebx]
	push eax
	call pDec
	call newl
	;------------------------------------
	;type 
	push msgType
	push lenType
	call print
	;

	mov ebx,dword [TempBuf]
	add ebx,0x10
	movzx eax,word [ebx]
	push eax
	push KeyType
	call scanKey

	;push dword [tmp]
	;call pDec

	push ValType
	push dword [tmp]
	call writeTH

	call newl 
	;-----------------------------------
	;machine
	push msgMachine
	push lenMAchine
	call print
	;
	mov ebx,dword [TempBuf]
	add ebx,0x12
	movzx eax,word [ebx]
	push eax
	push KeyMachine
	call scanKey
	;push dword [tmp]
	;call pDec

	push ValMachine
	push dword [tmp]
	call writeTH

	call newl
	;-------------------------
	;version
	push msgVersion
	push lenVersion
	call print
	;
	mov ebx,dword [TempBuf]
	add ebx,0x14
	mov eax,dword [ebx]
	push eax
	call pDec

	call newl
	;--------------------------
	;entrypoint adress ->end
	mov ebx,dword  [TempBuf]
	add ebx,4
	movzx eax,byte [ebx]
	cmp eax,1
	je solve32
solve64:
	push msgEP
	push lenEP
	call print
	mov ebx, dword [TempBuf]
	add ebx, 0x1f
	;push dword [ebx]
	;call pHex
	push ebx
	push 8
	call showReverseHex
	call newl
SOPH64:
	push msgProgramHeader
	push lenProGramHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x27
	push ox
	call writeString
	push ebx
	push 8
	call showReverseHex
	call newl
SOSH64:
	push msgSectionHeader
	push lenSectionHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x2f
	push ox
	call writeString
	push ebx
	push 8
	call showReverseHex
	call newl
F64:
	push msgFlags
	push lenFlags
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x30
	push dword [ebx]
	call pDec
	call newl
SzOTH64:
	push msgSizeOfThisHeader
	push lenSizeOfThisHeader
	call print
	;
	mov ebx,dword [TempBuf]
	add ebx, 0x34
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
SzOPH64:
	push msgSizeOfProgramHeader
	push lenSizeOfProgramHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x36
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
NOPH64:
	push msgNumberOfProgramHeader
	push lenNumberOfProgramHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x38
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
SzOSH64:
	push msgSizeOfSectionHeader
	push lenSizeOfSectionHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x3a
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
NOSH64:
	push msgNumberOfSectionHeader
	push lenNumberOfSectionHeader
	call print
	mov ebx, dword [TempBuf]
	add ebx, 0x3c
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
SHSTI64:
	push msgSectionHeaderStringTableIndex
	push lenSectionHeaderStringTableIndex
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x3e
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
	jmp buzz
solve32:
	push msgEP
	push lenEP
	call print
	mov ebx, dword [TempBuf]
	add ebx, 0x18
	;push dword [ebx]
	;call pHex
	add ebx,3
	push ebx
	push 4
	call showReverseHex
	call newl
	;-------------------------
SOPH32:
	push msgProgramHeader
	push lenProGramHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x1C
	push dword [ebx]
	call pDec
	call newl
SOSH32:
	push msgSectionHeader
	push lenSectionHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x20
	push dword [ebx]
	call pDec
	call newl
F32:
	push msgFlags
	push lenFlags
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x24
	push dword [ebx]
	call pDec
	call newl
SzOTH32:
	push msgSizeOfThisHeader
	push lenSizeOfThisHeader
	call print
	;
	mov ebx,dword [TempBuf]
	add ebx, 0x28
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
SzOPH32:
	push msgSizeOfProgramHeader
	push lenSizeOfProgramHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x2A
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
	jmp NOPH32
NOPH32:
	push msgNumberOfProgramHeader
	push lenNumberOfProgramHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x2C
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
SzOSH32:
	push msgSizeOfSectionHeader
	push lenSizeOfSectionHeader
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x2e
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
NOSH32:
	push msgNumberOfSectionHeader
	push lenNumberOfSectionHeader
	call print
	mov ebx, dword [TempBuf]
	add ebx, 0x30
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
SHSTI32:
	push msgSectionHeaderStringTableIndex
	push lenSectionHeaderStringTableIndex
	call print
	;
	mov ebx, dword [TempBuf]
	add ebx, 0x32
	movzx ebx, word [ebx]
	push ebx
	call pDec
	call newl
	;~ close file
buzz:
	mov		ebx, esi 
	mov		eax, sys_close
	int		80H

	;~ "free" memory
	mov     ebx, [Org_Break]
    mov     eax, sys_brk
    int     80H
    jmp Exit
notELF:
	push failMsg
 	push lenFail
 	call print

Exit:  
	call newl
    mov     eax, sys_exit
    xor     ebx, ebx
    int     80H