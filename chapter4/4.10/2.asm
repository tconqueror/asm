comment ?
2. Exchanging Pairs of Array Values
Write a program with a loop and indexed addressing that exchanges every pair of values in an
array with an even number of elements. Therefore, item i will exchange with item i+1, and item
i+2 will exchange with item i+3, and so on.
?

.386
.model flat,stdcall

include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	array dword 100h,200h,300h,400h,500h,600h
.code
main proc
	mov ecx,lengthof array - 1
	mov esi,0
loop1:
	mov eax,[array+esi*4]
	inc esi
	xchg eax,[array+esi*4]
	dec esi
	mov [array+esi*4],eax
	inc esi
	loop loop1
	
	push 0
	call exitprocess

main endp
end main
