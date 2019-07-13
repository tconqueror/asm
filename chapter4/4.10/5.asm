comment ?
5. Fibonacci Numbers
Write a program that uses a loop to calculate the first seven values of the Fibonacci number sequence,
described by the following formula: Fib(1) = 1, Fib(2) = 1, Fib(n) = Fib(n – 1) + Fib(n – 2).
?

.386
.model flat,stdcall

include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	arrayd dword 1h,2h,3h,4h,5h,6h,7h
.code
main proc
	mov ecx,5
	mov edi,offset arrayd
	mov arrayd,1
	mov [arrayd+4],1
loop1:
	mov eax,[edi]
	add edi,type arrayd
	add eax,[edi]
	mov [edi+type arrayd],eax
	loop loop1
	push 0
	call exitprocess

main endp
end main
