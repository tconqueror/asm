comment ?
4. Symbolic Text Constants
Write a program that defines symbolic names for several string literals (characters between
quotes). Use each symbolic name in a variable definition.
?

.386
.model flat,stdcall
.stack 4096
include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	t2 equ <"Monday",0>
	t3 equ <"Tuesday",0>
	t4 equ <"Wednesday",0>
	t5 equ <"Thursday",0>
	t6 equ <"Friday",0>
	t7 equ <"Saturday",0>
	cn equ <"Sunday",0>
	week byte t2,t3,t4,t5,t6,t7,cn 
.code
main proc
	push 0
	call exitprocess
main endp
end main
