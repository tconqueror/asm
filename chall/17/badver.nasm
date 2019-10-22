SECTION .data
    extern signal 
    extern timer_create
    extern timer_settime
;command db "pkill","-x","nc",0
;path db "/bin/pkill",0
aPkill db "/usr/bin/pkill",0
asc_200A db "-x",0
path db "/usr/bin/pkill",0
aNc db "nc" ,0
delay dq 5,0,0
command dq path,
        dq asc_200A,
        dq aNc ,0
msg db "wait 10s",0xd,0xa,0
 
it_interval_tv_sec dq 10
it_interval_tv_nsec dq 0
it_value_tv_sec dq 10
it_value_tv_nsec dq 0
timer_id dq 0
itimerspec  dq it_interval_tv_sec,
            dq it_interval_tv_nsec,
            dq it_value_tv_sec,
            dq it_value_tv_nsec,0
SECTION .text
    
global  main
 
main:
    ;call callbackfunc
    mov rdi,14
    mov rsi, callbackfunc
    call signal

    call start_timer
    
l1:
    nop
    jmp l1

l2:
    call callbackfunc

    mov rax, 60
    mov rsi,0
    syscall

callbackfunc:
    push rbp
    mov rbp,rsp

    mov rax,1
    mov rdi,1
    mov rsi,msg
    mov rdx,10
    syscall

    ;mov     rdx, 0          ; envp
    ;mov     rdi, path        ; argv
    ;mov     rsi, command       ; "/bin/pkill"
    ;mov     rax, 59
    ;syscall

    pop rbp
    ret 
;----------------------------------------
start_timer:
    push rbp
    mov rbp,rsp

    mov rdi, 0
    mov rsi, 0
    mov rdx, timer_id
    mov rax, 222
    syscall

    mov rdi,timer_id
    mov rsi,0
    mov rdx, itimerspec
    mov rcx,0
    mov rax, 223 
    syscall
    pop rbp
    ret
