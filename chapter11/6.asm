
include Irvine32.inc

.data
	filename byte "record.dat",0
	msg1 byte "Enter the number of the students you want to add: ",0
	msg2 byte "ID: ",0
	msg3 byte "First name: ",0
	msg4 byte "Last name: ",0
	msg5 byte "DOB: ",0
	buf byte 100 dup (0)
	hand handle ?
	byteWritten dword ?
	len dword ?
	endl byte 0dh,0ah
.code
main proc
	mov edx,offset filename
	call CreateOutputFile
	mov hand, eax

	mov edx,offset msg1
	call WriteString
	call ReadInt
	mov ecx,eax
l1:
	push ecx
	mov edx,offset msg2
	call WriteString
	mov edx,offset buf
	mov ecx,lengthof buf
	call ReadString
	mov len, eax
	mov eax,hand
	mov edx,offset buf
	mov ecx,len
	call WriteToFile
	invoke WriteFile, hand, addr endl, 2, addr byteWritten, 0
	mov edx,offset msg3
	call WriteString
	mov edx,offset buf
	mov ecx,lengthof buf
	call ReadString
	mov len, eax
	mov eax,hand
	mov edx,offset buf
	mov ecx,len
	call WriteToFile
	invoke WriteFile, hand, addr endl, 2, addr byteWritten, 0

	mov edx,offset msg4
	call WriteString
	mov edx,offset buf
	mov ecx,lengthof buf
	call ReadString
	mov len, eax
	mov eax,hand
	mov edx,offset buf
	mov ecx,len
	call WriteToFile
	invoke WriteFile, hand, addr endl, 2, addr byteWritten, 0
	mov edx,offset msg5
	call WriteString
	mov edx,offset buf
	mov ecx,lengthof buf
	call ReadString
	mov len, eax
	mov eax,hand
	mov edx,offset buf
	mov ecx,len
	call WriteToFile
	invoke WriteFile, hand, addr endl, 2, addr byteWritten, 0
	pop ecx
	dec ecx
	jecxz en
	jmp l1
en:
	mov eax,hand
	call CloseFile

	call Crlf
	call WaitMsg
	invoke exitprocess,0
main endp

end main
