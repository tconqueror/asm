include Irvine32.inc

.data
	filename byte "inp.inp",0
	msg byte " was last accessed on: ",0
	time SYSTEMTIME <>
.code

main proc
	mov edx,offset filename
	mov esi,offset time
	call LastAccessDate
	mov edx,offset filename
	call WriteString
	mov edx,offset msg
	call WriteString
	movzx eax,time.wHour
	call WriteDec
	mov eax,':' 
	call WriteChar
	movzx eax,time.wMinute
	call WriteDec
	mov eax,' ' 
	call WriteChar
	movzx eax,time.wDay
	call WriteDec
	mov eax,'/' 
	call WriteChar
	movzx eax,time.wMonth
	call WriteDec
	mov eax,'/' 
	call WriteChar
	movzx eax,time.wYear
	call WriteDec
	call Crlf
	call WaitMsg
	invoke exitprocess, 0
main endp

LastAccessDate proc
;	file name = edx
;	offset of systime = esi
.data
	hand handle ?
	cTime FILETIME <>
	lAccessTime FILETIME <>
	lWriteTime FILETIME <>
.code
	pushad
	;open file
	push esi
	invoke CreateFile, edx, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
	cmp eax,INVALID_HANDLE_VALUE
	je fail
	mov hand, eax
	;openfile success
	invoke GetFileTime, hand, addr cTime, addr lAccessTime, addr lWriteTime
	pop esi
	invoke FileTimeToSystemTime, addr lAccessTime, esi
	clc
	jmp en
fail:
	stc
en:
	popad
	ret
LastAccessDate endp

end main
