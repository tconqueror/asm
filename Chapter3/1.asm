comment ?
1. Integer Expression Calculation
Using the AddTwo program from Section 3.2 as a reference, write a program that calculates the
following expression, using registers: A = (A + B) − (C + D). Assign integer values to the EAX,
EBX, ECX, and EDX registers.
?

.386
.model flat,stdcall
.stack 4096
include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib
.data

.code
main proc

	mov eax,1
	mov ebx,2
	sub eax,ebx
	mov ecx,3
	mov edx,4
	add ecx,edx
	sub eax,ecx
	
	push 0
	call exitprocess
main endp
end main
