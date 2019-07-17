.386
.model flat,stdcall
.stack 4096

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	start dword 1
	char byte 'H','A','C','E','B','D','F','G'
	link dword 0,4,5,6,2,3,7,0
	new byte lengthof char + 1 dup (?)
	d byte type dword
.code
main proc
	mov ecx,lengthof char
	mov edi,offset new
	;
l1:
	mov esi,offset char
	add esi,start
	mov al,[esi]
	mov [edi],al
	mov edx,offset link 
	mov eax,start
	mul d
	mov start,eax
	add edx,start

	mov eax,[edx]
	mov start,eax
	
	inc edi

	loop l1

	mov al,0
	mov [edi],al
	mov edx,offset new
	call WriteString

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
	
main endp

end main

