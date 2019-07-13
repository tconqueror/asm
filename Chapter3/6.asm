;Khi dùng biến 64 bit cho asm 32, IDE báo lỗi constant value too large (quá lớn)
;Fix bằng cách chuyển qua code 64bit =))

ExitProcess proto

.data
sum qword 0

.code
main proc
	mov	  rax,100000000000h
	add	  rax,6
	mov   sum,rax

	mov   ecx,0
	call  ExitProcess

main endp
end
