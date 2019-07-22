.386
include c:\masm32\include\Irvine32.inc
includelib c:\masm32\lib\kernel32.lib

.data
	evenp BYTE 10 DUP(0ffh) 
	oddp BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fbh
	TRUE = 1
	FASLE = 0
.code
main proc
	mov esi, OFFSET oddp
	mov ecx, LENGTHOF evenp
	call checkParity

	mov esi, OFFSET evenp
	
	mov ecx, LEnGTHOF oddp
	call checkParity

	call Crlf
	call WaitMsg
	push 0
	call exitprocess
main endp
checkParity proc
.data
	evenMSG  BYTE "Parity is even! ",0 
	oddMSG  BYTE "Parity is odd! ",0 
	count BYTE ?
.code
	mov count, 0
l1: 
	mov bl, [esi]			

	pushfd
	inc esi
	cmp count, 9
	je checkp
	inc count
	popfd
	xor bl, [esi]
	
	
	loop l1
checkp:
	popfd
	jp evenParity
	jnp oddParity	
			
evenParity:
	mov eax, TRUE
	mov edx, OFFSET evenMSG
	call WriteString
	jmp final	

oddParity: 
	mov eax, FALSE
	mov edx, OFFSET oddMSG
	call WriteString
	jmp final

	
final:
ret 
checkParity ENDP 

end main
