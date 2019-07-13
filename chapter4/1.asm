comment ?
change bigEndian to littleEndian
?
.386
.model flat,stdcall

include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib

.data 
	bigEndian byte 12h,34h,56h,78h
	littleEndian dword ?
.code
main proc
	
	mov ah,bigEndian[3]
	mov al,bigEndian[2]
	mov word ptr littleEndian[2],ax
	
	mov ah,bigEndian[1]
	mov al,bigEndian
	mov word ptr littleEndian,ax

	push 0
	call exitprocess

main endp
end main
