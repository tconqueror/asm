
include \Irvine\Irvine32.inc

BufSize = 256
.data
buffer BYTE BufSize DUP(?),0,0
stdInHandle HANDLE ?
bytesRead DWORD ?
.code
main PROC
	push offset buffer
	push BufSize
	call readS

	push offset buffer
	call writeS
	call Crlf
	call WaitMsg
	exit
main ENDP

readS proc
.data
	string equ dword ptr [ebp+12]
	len equ dword ptr [ebp+8]
	stdin equ dword ptr [ebp-4]
	byteRead equ dword ptr [ebp-8]
.code
	push ebp
	mov ebp,esp
	sub esp,8

	push STD_INPUT_HANDLE
	call GetStdHandle
	mov stdin, eax
	mov eax,ebp
	sub eax,8
	invoke ReadConsole, stdin, string, len, eax, 0
	mov eax,byteRead
	sub eax,2
	mov esi,string
	add esi,eax
	mov byte ptr [esi],0
	add esp,8
	pop ebp
	ret 8
readS endp

writeS proc
.data
	string equ dword ptr [ebp+8]
	len equ dword ptr [ebp-4]
	stdout equ dword ptr [ebp-8]
.code
	push ebp
	mov ebp,esp
	sub esp,8
	mov al,0
	mov edi,string
	cld
l1:
	scasb
	jz write
	jmp l1
write:
	sub edi,string
	dec edi
	mov len,edi
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov stdout, eax
	mov eax,ebp
	sub eax,4
	invoke WriteConsole, stdout, string, len, eax, 0   
	add esp,8
	pop ebp
	ret 4
writeS endp

END main
