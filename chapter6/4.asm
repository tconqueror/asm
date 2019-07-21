.386
;.model flat,stdcall
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	gradeAverage sword 251
	credit sword 17
	ok byte ?
	inva byte "Invalid value!",0
	msg1 byte "Average value: ",0
	msg2 byte "Credit: ",0
	space byte " ",0
	can byte "Student can register!",0
	cant byte "Studen can't register",0
.code
main proc
	call bla
	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp

bla proc
	pushad
	mov edx,offset msg1
	call WriteString
	movzx eax,gradeAverage
	call WriteInt
	call Crlf
	mov edx,offset msg2
	call WriteString
	movzx eax,credit
	call WriteInt
	call Crlf

	mov ok,0
	cmp credit,30
	jg invalid
	cmp credit,1
	jb invalid
	; neu khong co loi
	cmp gradeAverage,350
	jg one
	cmp credit,12
	jle one
	cmp gradeAverage,250
	jle compare
	cmp credit,16
	jg compare
one:
	mov ok,1
compare:
	cmp ok,0
	jz Cnt
Cn:
	mov edx,offset can
	call WriteString
	jmp en
Cnt:
	mov edx,offset cant
	call WriteString
	jmp en

invalid:
	mov edx,offset inva
	call WriteString
en:	
	popad
	ret
bla endp
end main
