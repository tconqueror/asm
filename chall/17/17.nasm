extern signal
extern timer_create 
extern timer_settime
extern popen
section .data
	gtimerid dq 0
	mod db 'r',0
	command db 'pkill -x nc',0

section .text
global main
main:
	push rbp
	mov rbp, rsp
	mov rsi, timer_callback 		
	mov rdi, 0Eh					
	call signal
	call start_timer
l1:
	jmp l1

timer_callback:
	push rbp
	mov rbp, rsp
	mov rsi, mod 					
	mov rdi, command 				
	call popen
	
done:
	pop rbp
	ret

start_timer:
	push rbp
	mov rbp, rsp
	sub rsp, 20h 					
	mov qword [rbp-10h], 5 			
	mov qword [rbp-8h], 0 			
	mov qword [rbp-20h], 5 			
	mov qword [rbp-18h], 0 			
	mov rdx, gtimerid 				
	mov rsi, 0  					
	mov rdi, 0  					
	call timer_create 
	lea rdx, [rbp-20h] 				
	mov rsi, 0 					
	mov rdi, [gtimerid] 				
	call timer_settime 	

	add rsp, 20h
	pop rbp
	ret
