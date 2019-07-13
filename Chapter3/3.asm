?
3. Data Definitions
Write a program that contains a definition of each data type listed in Table 3-2 in Section 3.4.
Initialize each variable to a value that is consistent with its data type.
?

.386
.model flat,stdcall
.stack 4096
include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	b byte 12
	sb sbyte -12
	w word 12
	sw sword -13
	dwo dword 12
	sdw sdword -14
	fw fword 123456789h
	qw qword 123456789h
	tb tbyte 80000000123456789002h
	r4 real4 -3.14
	re8 real8 2.23E-256
	re10 real10 -4.5E+4000
.code
main proc

	push 0
	call exitprocess
main endp
end main
