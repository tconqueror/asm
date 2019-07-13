comment ?
7. Copy a String in Reverse Order
Write a program with a loop and indirect addressing that copies a string from source to target,
reversing the character order in the process. Use the following variables:
source BYTE "This is the source string",0
target BYTE SIZEOF source DUP('#')
?

.386
.model flat,stdcall

include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	source BYTE "This is the source string",0
	target BYTE SIZEOF source DUP('#')
.code
main proc
	mov ecx,sizeof source - 1
	mov edi,offset source
	mov esi,offset target
	
loop1:
	mov al,0
	mov [esi+sizeof source-1],al		;copy ki tu /00
	mov al,byte ptr [edi]
	mov [esi+ecx-1],al
	inc edi
	loop loop1
	push 0
	call exitprocess

main endp
end main
