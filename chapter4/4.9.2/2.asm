comment ?
Using the XCHG instruction no more than three times, reorder the values in four 8-bit registers
from the order A,B,C,D to B,C,D,A.
?

.386
.model stdcall,flat
include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.code
main proc

	mov eax,1
	mov ebx,2
	mov ecx,3
	mov edx,4

	xchg al,bl
	xchg bl,dl
	xchg bl,cl

	push 0
	call exitprocess
main endp
end main
