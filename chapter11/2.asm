
include \Irvine\Irvine32.inc

BufSize = 256
.data
	msg1 byte "First name: ",0
	firstName byte 30 dup (0)
	msg2 byte "Last name: ",0
	lastName byte 30 dup (0)
	msg3 byte "Age: ",0
	age byte 3 dup (0)
	msg4 byte "Phone number: ",0
	pNumber byte 11 dup (0)
	msg5 byte "Your information: ",0
.code
main PROC
	push offset msg1
	call writeS
	push offset firstName
	push lengthof firstName
	call ReadS

	push offset msg2
	call writeS
	push offset lastName
	push lengthof lastName
	call ReadS

	push offset msg3
	call writeS
	push offset age
	push lengthof age
	call ReadS

	push offset msg4
	call writeS
	push offset pNumber
	push lengthof pNumber
	call ReadS

	;

	push offset msg5
	call WriteS

	call Crlf
	push offset firstName
	call WriteS
	call Crlf
	push offset lastName
	call WriteS
	call Crlf
	push offset age
	call WriteS
	call Crlf
	push offset pNumber
	call WriteS

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
