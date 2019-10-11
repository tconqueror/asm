OPTION DOTNAME
option casemap:none
;include      windows.inc

includelib   kernel32.lib
includelib   user32.lib
includelib   gdi32.lib



ExitProcess proto :dword
GetModuleHandleW proto :Qword
GetCommandLineW proto 
RegisterClassW proto :qword
LoadIconW proto :dword, :dword
LoadCursorW proto :dword, :dword
GetStockObject proto :dword
CreateWindowExW proto :dword, :qword,:qword, :dword, :dword, :dword, :dword, :dword, :qword, :dword, :qword, :dword  
MessageBoxW proto :dword, :qword, :qword, :dword
ShowWindow proto :qword, :dword
UpdateWindow proto :qword
GetMessageW proto :qword, :dword, :dword, :dword
TranslateMessage proto :qword 
DispatchMessageW proto :qword
SetTimer proto :qword, :dword, :dword, :dword
PostQuitMessage proto :qword
KillTimer proto :qword, :dword
EnumWindows proto :qword, :dword
DefWindowProcW proto :qword, :dword, :qword, :qword
GetWindowThreadProcessId proto :qword, :qword
GetClassNameA proto :qword, :qword, :dword
IsWindowVisible proto :qword
OpenProcess proto :dword, :dword, :dword 
TerminateProcess proto :qword, :dword
CloseHandle proto :qword
WNDCLASSW struct ; (sizeof=0x48, align=0x8, copyof_5)
                                        ; XREF: WinMain/r
style 			dd ?                    ; XREF: WinMain+4A/w
                db ? ; undefined
                db ? ; undefined
				db ? ; undefined
                db ? ; undefined
lpfnWndProc     dq ?                    ; XREF: WinMain+5B/w ; offset
cbClsExtra      dd ?                    ; XREF: WinMain+62/w
cbWndExtra      dd ?                    ; XREF: WinMain+6C/w
hInstance       dq ?                    ; XREF: WinMain+7D/w ; offset
hIcon           dq ?                    ; XREF: WinMain+91/w ; offset
hCursor         dq ?                    ; XREF: WinMain+A5/w ; offset
hbrBackground   dq ?                    ; XREF: WinMain+B4/w ; offset
lpszMenuName    dq ?                    ; XREF: WinMain+BB/w ; offset
lpszClassName   dq ?                    ; XREF: WinMain+CD/w ; offset
WNDCLASSW       ends

POINT           struct ; (sizeof=0x8, align=0x4, copyof_28)
                                         ; XREF: tagMSG/r
x               dd ?
y               dd ?
POINT           ends
MSG          struct ; (sizeof=0x30, align=0x8, copyof_26)
                                         ; XREF: WinMain/r
hwnd            dq ?                    ; offset
message         dd ?
                db ? ; undefined
                db ? ; undefined
                db ? ; undefined
                db ? ; undefined
wParam          dq ?                    ; XREF: WinMain:loc_140001BC8/r
lParam          dq ?
time            dd ?
pt              POINT <>
                db ? ; undefined
                db ? ; undefined
                db ? ; undefined
                db ? ; undefined
MSG          ends

.data
	hInstance qword 0
	CommandLine qword 0
	ClassName db "A",0,"n",0,"t",0,"i",0,"C",0,"h",0,"r",0,"o",0,"m",0,"e",0,0,0,0
	WindowName db "A",0,"n",0,"t",0,"i",0,"C",0,"h",0,"r",0,"o",0,"m",0,"e",0,0,0,0
	Text db "W",0,"i",0,"n",0,"N",0,"T",0,0,0 
	Class_Name db 512 dup (0)
	filter db "Chrome_WidgetWin_1",0
.const
.code

main proc
	;sub rsp,4*8
	xor rcx,rcx 
	call GetModuleHandleW
	mov hInstance, rax
	;add rsp, 4*8 
	
	call GetCommandLineW
	mov CommandLine, rax
	
	mov r9,10
	mov r8, CommandLine
	xor rdx,rdx
	mov rcx, hInstance
	call WinMain	

	xor rcx,rcx
	call ExitProcess
main endp
strcmp proc
	;offset offset
	push rbp
	mov rbp,rsp
	push rsi
	push rdi
	mov rsi, qword ptr [rbp+16]
	mov rdi, qword ptr [rbp+24]
	mov ecx,10000
lstrcmp1:
	repe cmpsb
	dec rdi
	cmp byte ptr [rdi],0
	jne retfalse
	dec rsi
	cmp byte ptr [rsi],0
	jne retfalse
rettrue:
	mov rax,1
	pop rdi
	pop rsi
	pop rbp
	ret 16
retfalse:
	xor rax,rax
	pop rdi
	pop rsi
	pop rbp
	ret 16
strcmp endp
enumWindowCallback proc hWnd: qword, lparam: qword
	local process_id: qword
	local dwDesiredAccess: dword 
	local bInheritHandle :dword
	local hProcess: qword 
	;push rdi
	lea rdx,process_id
	mov rcx,hWnd
	call GetWindowThreadProcessId
	mov r8d,50h
	lea rdx,Class_Name
	mov rcx, hWnd
	call GetClassNameA
	mov rcx, hWnd
	call IsWindowVisible
	test eax,eax 
	jnz ret1 
	lea rdx, filter
	lea rcx, Class_Name 
	call strcmp
	test eax,eax 
	jnz ret1 
	mov dwDesiredAccess,1
	mov bInheritHandle, 0
	mov rdx, process_id 
	mov r8d, edx
	mov edx,bInheritHandle
	mov ecx,dwDesiredAccess
	call OpenProcess
	mov hProcess, rax 
	cmp rax,0 
	jnz ret0 
	mov edx,1 
	mov rcx,hProcess
	call TerminateProcess
	mov rcx, hProcess
	call CloseHandle
	jmp ret1
ret0:
	xor eax,eax 
	jmp enden 
ret1:
	mov eax,1
	jmp enden
enden:
	;pop rdi 
	ret
enumWindowCallback endp
WndProc proc hwnd: qword, message: dword, wParam: qword, lParam: qword
	cmp message, 1 
	jz WMCreate
	cmp message, 2
	jz WMDestroy
	cmp message, 113h
	jz WMTimer
	mov r9,lParam
	mov r8,wParam
	mov edx, message
	mov rcx, hwnd 
	call DefWindowProcW
	jmp endWndProc
WMTimer:
	;xor edx,edx 
	;lea rcx,enumWindowCallback
	;call EnumWindows
	;xor eax,eax 
	jmp endWndProc
WMDestroy:
	mov edx,1 
	mov rcx,hwnd 
	call KillTimer 
	xor ecx,ecx 
	call PostQuitMessage
	xor eax,eax 
	jmp endWndProc
WMCreate:
	xor r9d,r9d 
	mov r8d,1388h
	mov edx,1 
	mov rcx, hwnd 
	call SetTimer
	xor eax,eax 
	jmp endWndProc
endWndProc:
	ret
WndProc endp 
WinMain proc hInst:qword, hPrevInst: qword, CmdLine: qword, CmdShow: dword 
	local wc:WNDCLASSW
	local hWnd: qword
	local msg: MSG

	mov wc.style, 3
	;lea rax, WndProc
	mov wc.lpfnWndProc, rax 
	mov wc.cbClsExtra, 0 
	mov wc.cbWndExtra, 0 
	push hInst
	pop wc.hInstance
	
	mov edx,7f00h
	xor ecx,ecx 
	call LoadIconW
	mov wc.hIcon, rax 
	
	mov edx, 7f00h
	xor ecx,ecx
	call LoadCursorW
	mov wc.hCursor, rax 
	
	xor ecx,ecx
	call GetStockObject 
	mov wc.hbrBackground, rax 
	mov wc.lpszMenuName, 0 
	lea rax,ClassName
	mov wc.lpszClassName,rax 
	lea rcx, wc
	call RegisterClassW
	or eax,eax
	jnz conti
	;fail
	mov r9d, 10h
	lea r8,ClassName
	lea rdx,Text
	xor ecx,ecx
	call MessageBoxW
	xor eax,eax 
	jmp endgame
conti:
	push 0 
	push hInst
	push 0 
	push 0 
	push 32h 
	push 0C8h 
	push 80000000h
	push 80000000h
	mov r9d, 0CF0000h
	lea r8, WindowName
	lea rdx, ClassName 
	xor ecx,ecx 
	call CreateWindowExW
	;add rsp, 8*8
	mov hWnd, rax
	mov edx,CmdShow
	mov rcx, hWnd
	call ShowWindow

	mov rcx, hWnd
	call UpdateWindow

whilee:
	xor r9d,r9d 
	xor r8d,r8d
	xor edx,edx 
	lea rcx,msg 
	call GetMessageW
	test eax,eax 
	jz conti1 
	
	lea rcx,msg
	call TranslateMessage
	lea rcx,msg
	call DispatchMessageW
	jmp whilee
conti1:
	mov eax, dword  ptr msg.wParam
endgame:
	ret
WinMain endp

end
