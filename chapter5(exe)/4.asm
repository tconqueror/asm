.386
.model flat,stdcall
.stack 4096

include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	prompt BYTE "Enter a 32-bit signed integer:",0
	resultMsg BYTE "Sum of 2 integers is:",0
	int1 DWORD ?
	int2 DWORD ?
	sum DWORD ?

	
	;mov edx,002003Ch
	;call GetMaxXY
	;dec dl
	;dec dh
	comment ?
	;mov maxX, dh
	;mov maxY, dl

	;movzx ax,maxX
	;mov bl,4h
	;div bl
	;mov maxX,al

	;movzx ax,maxY
	;mov bl,2h
	;div bl
	;mov maxY,al

	;mov dh,maxX
	;mov dl,maxY
	?

	;call GoToXY
	;call Crlf
	;call WaitMsg

.code
main proc 
	mov ecx,3
l1:
	call bla
	loop l1
	
	push 0
	call exitprocess
main endp
bla PROC
	push ecx
    call Clrscr

    MOV DH, 10    
    MOV DL, 20   
    CALL GoToXY   

    MOV EDX, OFFSET prompt    
    CALL WriteString
    CALL ReadInt   
    MOV int1,EAX

	MOV DH, 11    
    MOV DL, 20   
    CALL GoToXY

	mov edx,offset prompt
    CALL WriteString
    CALL ReadInt    
    MOV int2,EAX

    
    MOV EAX, int1
    ADD EAX, int2
    MOV sum, EAX



	MOV DH, 12    
    MOV DL, 20   
    CALL GoToXY
    
    MOV EDX, OFFSET resultMsg
    call WriteString
    MOV EAX, sum
    call WriteInt

	mov dh,14
	mov dl,20
	call GoToXY
    call WaitMsg
	pop ecx
	ret
	bla endp

end main

