include C:\install64\include64\masm64rt.inc 

.data
	ClassName db "WinClass", 0
	AppName db "Reverse", 0
	MenuName db "Menu", 0
	EditClassName db "Edit", 0
	EditClassName2 db "Edit", 0
	TestText db "BlaBlaBla", 0
	process_id dword 0
	class_name db 512 dup (0)
	hInstance HINSTANCE ?
	CommandLine LPSTR ?
	hwndEdit1 HWND ?
	hwndEdit2 HWND ?
	buffer db 512 dup(?)
	base db "Chrome_WidgetWin_1",0
	dwDesiredAccess dword 0
	bInheritHandle dword ?
	ID_TIMER equ 1
	hProcess HANDLE ?

.code

main proc
	sub rsp, 8
	xor rcx, rcx
	call GetModuleHandle 
	sub rsp, 8
	mov  hInstance, rax

	call GetCommandLine
	mov CommandLine, rax
	sub rsp, 32
	xor rcx, rcx
	mov r9, SW_SHOWDEFAULT
	mov r8, CommandLine
	xor rdx, rdx 
	mov rcx, hInstance
	call WinMain
	add rsp,32
	
	xor rcx,rcx
	call ExitProcess
main endp

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
	Local wc:WNDCLASSEX
	Local msg:MSG
	Local hwnd:HWND

	mov wc.cbSize, SIZEOF WNDCLASSEX
	mov wc.style, 3
	lea rcx, WndProc
	mov wc.lpfnWndProc, rcx
	mov wc.cbClsExtra, NULL
	mov wc.cbWndExtra, NULL
	push hInst
	pop wc.hInstance

	sub rsp, 16
	mov rdx, 7f00h
	xor rcx,rcx 
	call LoadIcon
	add rsp, 16
	mov wc.hIcon, rax
	mov wc.hIconSm, rax

	sub rsp, 16
	mov rdx, 7f00h
	xor rcx,rcx
	call LoadCursor
	add rsp, 16
	mov wc.hCursor, rax

	sub rsp, 32
	xor rcx, rcx
	call GetStockObject
	add rsp, 32
	mov wc.hbrBackground, rax
	
	mov wc.lpszMenuName, 0
	lea rcx,ClassName 
	mov wc.lpszClassName, rcx
		
	sub rsp, 32
	lea rcx, wc
	call RegisterClassEx
	add rsp,32
	push NULL
	push hInst
	push NULL
	push NULL
	push 50
	push 200
	push CW_USEDEFAULT
	push CW_USEDEFAULT
	sub rsp, 32
	mov r9, WS_OVERLAPPEDWINDOW
	lea r8, AppName
	lea rdx, ClassName
	mov rcx, WS_EX_CLIENTEDGE
	call CreateWindowEx
	add rsp,32
	mov hwnd, rax

	sub rsp, 32
	mov rdx, SW_SHOWNORMAL
	mov rcx, hwnd
	call ShowWindow
	add rsp, 32
	
	sub rsp, 32
	mov rcx, hwnd
	call UpdateWindow
	add rsp, 32

l1:
		sub rsp, 32
		xor r8, r8
		xor r9, r9
		xor rcx,rcx
		lea rcx, msg
		call GetMessage
		add rsp, 32

		or eax,eax
		jz conti

		sub rsp, 32
		lea rcx, msg
		call TranslateMessage
		add rsp, 32

		sub rsp, 32
		lea rcx, msg
		call DispatchMessage
		add rsp, 32
		jmp l1
conti:
	mov rax, msg.wParam
	ret 

WinMain endp

enumWindowCallback proc hWNd:HWND, lParam: LPARAM
	sub rsp, 32
	lea rdx, process_id
	mov rcx, hWNd
	call GetWindowThreadProcessId
	add rsp, 32

	sub rsp, 32
	mov r8d, 512
	lea rdx, class_name
	mov rcx, hWNd
	call GetClassNameA
	add rsp, 32

	sub rsp, 32
	mov rcx, hWNd
	call IsWindowVisible
	add rsp, 32
	
	push rsi
	push rdi
	lea rsi, base
	lea rdi, class_name
	mov rcx, 512
l1:
	movzx rax, byte ptr [rsi]
	cmp al, byte ptr [rdi]
	jnz endT
	cmp rax, 0
	je ok
	inc rdi
	inc rsi
	loop l1
ok:
	mov dwDesiredAccess, PROCESS_TERMINATE
	mov bInheritHandle, FALSE
	sub rsp, 32
	mov r8d, process_id
	mov edx, bInheritHandle
	mov ecx, dwDesiredAccess
	call OpenProcess
	add rsp, 32 
	mov hProcess,rax
	or rax,rax
	jz endF

	sub rsp, 32
	mov rdx,1
	mov rcx, hProcess
	call TerminateProcess
	add rsp, 32

	sub rsp, 32
	mov rcx, hProcess
	call CloseHandle
	add rsp, 32
	
	jmp endT
endF:
	pop rdi
	pop rsi
	mov rax,FALSE
	ret 
endT:
	pop rdi
	pop rsi
	mov rax,TRUE
	ret 
enumWindowCallback endp
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	cmp uMsg, WM_DESTROY
	jnz cmp_create
	sub rsp, 32
	xor rcx, rcx
	call PostQuitMessage
	add rsp, 32
	jmp en
cmp_create:
	cmp uMsg, WM_CREATE
	jnz cmp_TIMER
	sub rsp, 32
	xor r9, r9
	mov r8, 5000
	mov rdx, ID_TIMER
	mov rcx, hWnd
	call SetTimer
	add rsp,32
	jmp en
cmp_TIMER:
	cmp uMsg, WM_TIMER
	jnz Def
	comment ?
	sub rsp, 32
    xor rdx,rdx
	lea rcx, enumWindowCallback
	call EnumWindows
	add rsp, 32 
	?
	jmp en
Def:
    sub rsp, 32
    mov r9, lParam
    mov r8, wParam
    mov edx, uMsg
    mov rcx, hWnd
    call DefWindowProc
    add rsp, 32
en:
    xor rax, rax
    ret
WndProc endp

end 
