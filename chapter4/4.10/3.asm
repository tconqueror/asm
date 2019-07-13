comment ?
3. Summing the Gaps between Array Values
Write a program with a loop and indexed addressing that calculates the sum of all the gaps
between successive array elements. The array elements are doublewords, sequenced in nondecreasing
order. So, for example, the array {0, 2, 5, 9, 10} has gaps of 2, 3, 4, and 1, whose sum
equals 10.
?

.386
.model flat,stdcall

include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	array dword 100h,200h,300h,400h,500h,600h
	sum dword 0
.code
main proc
	mov ecx,lengthof array - 1
loop1:
	mov eax,dword ptr [array+ecx*4]
	dec ecx
	sub eax,dword ptr [array+ecx*4]
	add eax,sum
	mov sum,eax
	cmp ecx,0
	jne loop1

	push 0
	call exitprocess

main endp
end main
