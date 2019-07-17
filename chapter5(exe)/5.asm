.386
.model flat,stdcall
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	lower dword ?
	upper dword ?
	msglw byte "Nhap gioi han duoi: ",0
	msgup byte "Nhap gioi han tren: ",0
	msgres byte "Gia tri: ",0

.code
main proc
	mov ecx,32h
	mov edx,offset msglw
	call WriteString
	call ReadInt
	mov lower,eax

	mov edx,offset msgup
	call WriteString
	call ReadInt
	mov upper,eax

	mov eax,lower
	mov ebx,upper

l1:
	call bla
	loop l1
	
	call WaitMsg
	push 0
	call exitprocess

main endp


bla proc 
	push ecx
	mov eax,upper
	sub eax,lower
	call RandomRange
	add eax,lower

	mov edx,offset msgres
	call WriteString

	call WriteInt
	call Crlf
	
	pop ecx
	ret
bla endp
end main
