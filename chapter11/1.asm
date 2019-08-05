
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
	call bla

	mov esi,OFFSET buffer
	mov ecx,eax
	inc ecx
	mov ebx,TYPE buffer
	call DumpMem
	call WaitMsg
	exit
main ENDP

bla proc
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
bla endp
END main
