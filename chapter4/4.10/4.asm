comment ?
4. Copying a Word Array to a DoubleWord array
Write a program that uses a loop to copy all the elements from an unsigned Word (16-bit) array
into an unsigned doubleword (32-bit) array.
?

.386
.model flat,stdcall

include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	array word 100h,200h,300h,400h,500h,600h
	arrayd dword lengthof array dup(?)
.code
main proc
	mov ecx,lengthof array
	mov esi,0
loop1:
	movzx eax, word ptr [array+esi*2]
	mov [arrayd+esi*4],eax
	inc esi
	loop loop1

	push 0
	call exitprocess

main endp
end main
