comment ?
5. Listing File for AddTwoSum
Generate a listing file for the AddTwoSum program and write a description of the machine code
bytes generated for each instruction. You might have to guess at some of the meanings of the
byte values.
?

.386
.model flat,stdcall
.stack 4096

include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\kernel32.lib

ExitProcess proto,dwExitCode:dword
.data
	sum dword 0
.code
main proc
	mov eax,6			;B8 06 00 00 00
	sub eax,5			;83 E8 05
	mov sum,eax			;A3 00 40 40 00
	push 0				;6A 00
	call ExitProcess	;E8 05 00 00 00
main endp
end main
