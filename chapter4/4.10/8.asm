comment ?
8. Shifting the Elements in an Array
Using a loop and indexed addressing, write code that rotates the members of a 32-bit integer
array forward one position. The value at the end of the array must wrap around to the first position.
For example, the array [10,20,30,40] would be transformed into [40,10,20,30].
?

.386
.model flat,stdcall

include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	array dword 1,2,3,4,5,6,7,8,9
	temp dword ?
.code 
main proc
	mov ecx, lengthof array - 1
	mov esi, offset array
	add esi, sizeof array -type array
	mov eax,[esi]
	mov temp,eax
	loop1:
	mov eax,[esi-type array]
	mov [esi],eax
	sub esi,type array
	loop loop1
	
	mov eax,temp
	mov [esi],eax
	push 0
	call exitprocess

main endp
end main
