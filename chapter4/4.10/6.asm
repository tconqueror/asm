comment ?
6. Reverse an Array
Use a loop with indirect or indexed addressing to reverse the elements of an integer array in
place. Do not copy the elements to any other array. Use the SIZEOF, TYPE, and LENGTHOF
operators to make the program as flexible as possible if the array size and type should be
changed in the future.
?
.386
.model flat,stdcall

include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	arrayd dword 1h,2h,3h,4h,5h,6h,7h,8h,9h
.code
main proc
	mov ecx, lengthof arrayd-1
	mov edi,offset arrayd
	
loop1:
	mov eax,[type arrayd*ecx + edi]
	xchg eax,[edi]
	mov [type arrayd*ecx + edi],eax
	add edi,type arrayd
	dec ecx
	loop loop1
	push 0
	call exitprocess

main endp
end main
