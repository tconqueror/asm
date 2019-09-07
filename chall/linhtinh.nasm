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
szData    	db      "sys.data", 0
Data_Len    equ     $-szData

msg1 db "File name: ",0
len1 equ $-msg1

SECTION     .bss
stat		resb	sizeof(STAT)
Org_Break   resd    1
TempBuf		resd	1
szFile resb 100
File_Len resd 1

SECTION     .text
global      _start
    
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

	mov ebx,stdout
	mov ecx,[TempBuf]
	mov edx,4
	mov eax,sys_write
	int 0x80
	;~ display to terminal
	;mov		ebx, stdout
	;mov		ecx, [TempBuf]
	;mov		edx, eax
	;mov		eax, sys_write
	;int		80H
	
	;~ close file
	mov		ebx, esi 
	mov		eax, sys_close
	int		80H

	;~ "free" memory
	mov     ebx, [Org_Break]
    mov     eax, sys_brk
    int     80H
   	
Exit:  
    mov     eax, sys_exit
    xor     ebx, ebx
    int     80H
