include Irvine32.inc
bufs = 1024
.data
	filename byte "inp.inp",0
	hand handle ? 
	buf byte 1025 dup (0)
	byteWritten dword ?
.code

main proc
	call init
l1:
	invoke ReadFile, hand, addr buf, bufs, addr byteWritten, NULL
	;mov edx, offset buf
	;mov ecx, bufs
	;mov eax,hand
	;call ReadFromFile
	cmp byteWritten, bufs
	jne en
	mov edx,offset buf
	call WriteString
	jmp l1
en:
	mov esi,byteWritten
	add esi,offset buf
	mov byte ptr [esi], 0
	mov edx,offset buf
	call WriteString
	mov eax,hand
	call CloseFile
	call Crlf
	call WaitMsg
	invoke exitprocess, 0
main endp

init proc
	pushad
	invoke CreateFile, addr filename, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov hand, eax
	popad
	ret

init endp

end main
