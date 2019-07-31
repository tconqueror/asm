.386

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	msg byte "Enter the number of the row you want to get the sum: ",0
	table	dword 100,200,300,400,500
	rowsize equ ($-table)
			dword 200,300,400,500,600
			dword 300,400,500,600,700
			dword 400,500,600,700,800
			dword 500,600,700,800,900
.code
main proc
	push offset table
	push 5
	push 4
	mov edx,offset msg
	call WriteString
	call ReadInt
	push eax
	call calcRowSum
	call WriteDec
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

calcRowSum proc
.data
	tabl equ dword ptr [ebp+20]
	rows equ dword ptr [ebp+16]
	arrtype equ dword ptr [ebp+12]
	index equ dword ptr [ebp+8]
.code
	push ebp
	mov ebp,esp

	mov ebx,arrtype
	mov eax,rows
	mul ebx
	mul index
	add eax,tabl
	;esi chua start index
	mov esi,eax				
	mov eax,0
	mov edx,0
	not edx
	mov ecx,4
	sub ecx,arrtype
l1:
	jecxz conti
	shr edx,8
	loop l1
conti:
	mov eax,0
	mov ecx,rows
l2:
	mov ebx, dword ptr [esi]
	add esi,arrtype
	and ebx,edx
	add eax,ebx
	loop l2

	pop ebp
	ret
calcRowSum endp
end main
