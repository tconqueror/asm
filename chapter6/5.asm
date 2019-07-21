.386

include  c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	msg byte "Enter 32-bits integer: ",0
	casetable byte '1'
		dword processa
	entrysize = ($ - casetable)
		byte '2'
		dword processb
		byte '3'
		dword processc
		byte '4'
		dword processd
		byte '5'
		dword processe
	numberofentry = ($ - casetable)/entrysize
	promt byte "Nhap lua chon: ",0
	one byte "1. X and Y: ",0
	two byte "2. X or Y: ",0
	three byte "3. not X: ",0
	four byte "4. X xor Y: ",0
	five byte "5. Exit!",0
.code
main proc
	call bla

	call WaitMsg
	push 0
	call exitprocess
main endp
read proc
	 mov edx,offset promt
	 call WriteString
	 call Crlf
	 mov edx,offset one
	 call WriteString
	 call Crlf
	 mov edx,offset two
	 call WriteString
	 call Crlf
	 mov edx,offset three
	 call WriteString
	 call Crlf
	 mov edx,offset four
	 call WriteString
	 call Crlf
	 mov edx,offset five
	 call WriteString
	 call Crlf
l1:
	mov eax,10
	call Delay
	call ReadKey
	jz l1
	ret
read endp
bla proc
	pushad
	call Clrscr
	mov edx,offset msg
	call WriteString
	call ReadInt
	;call Crlf
	push eax
	call WriteString
	call ReadInt
	push eax
	call read
	;doc xong du lieu trong al
	mov esi, offset casetable
	mov ecx,numberofentry
l1:
	cmp al,[esi]
	jne l2
	pop ebx
	pop eax
	call near ptr [esi+1]
	jmp l3
l2:
	add esi,entrysize
	loop l1

l3:	
	popad
	ret
bla endp
processa proc
	pushad
	mov edx,offset one
	call WriteString
	and eax,ebx
	call WriteInt
	call Crlf
	call WaitMsg
	popad
	call bla
	ret
processa endp

processb proc
	pushad
	mov edx,offset one
	call WriteString
	or eax,ebx
	call WriteInt
	call Crlf
	call WaitMsg
	popad
	call bla
	ret
processb endp

processc proc
	pushad
	mov edx,offset one
	call WriteString
	not eax
	call WriteInt
	call Crlf
	call WaitMsg
	popad
	call bla
	ret
processc endp

processd proc
	pushad
	mov edx,offset one
	call WriteString
	xor eax,ebx
	call WriteInt
	call Crlf
	call WaitMsg
	popad
	call bla
	ret
processd endp

processe proc
	push 0
	call exitprocess
processe endp
end main
