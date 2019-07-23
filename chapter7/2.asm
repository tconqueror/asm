;Extended Subtraction Procedure
.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

decimal_offset = 5
.data
	op1 qword 002B2A40674981234h, 0A2B2A40674981235h
	op2 qword 08010870000234502h, 08010870000234500h
	res qword ?
	doubleword = sizeof op1 / type dword

.code
main proc
	mov esi,offset op1
	mov edi,offset op2
	mov ebx,offset res
	mov ecx,doubleword

	call bla

	mov esi,offset res
	add esi,doubleword*4
	mov ecx,doubleword
l1:
	sub esi,type dword
	mov eax,[esi]
	call WriteHex
	loop l1

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
.data
	first byte "0.",0
.code
	pushad
	clc
l1:
	mov eax,[esi]
	sbb eax,[edi]
	pushfd
	mov [ebx],eax
	add esi,4
	add edi,4
	add ebx,4
	popfd
	loop l1
	sbb word ptr [ebx],0
en:
	popad
	ret
bla endp


end main
