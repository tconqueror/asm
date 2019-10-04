.386
.model flat, stdcall
option casemap:none

WinMain proto :dword, :dword, :dword, :dword

;include c:\masm32\include\masm32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\gdi32.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\windows.inc

includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\gdi32.lib
includelib c:\masm32\lib\windows.lib
includelib c:\masm32\lib\msvcrt\lib

.data
	ClassName byte "SimpleWinClass",0
	AppName byte "BlaBla",0
	MenuName byte "MnName",0
	x dword 250
	y dword 175
	huong dword 0
.data?
	hInstance HINSTANCE ?
	CommandLine LPSTR ?
	hdc HDC ?
	ps PAINTSTRUCT <>
.const
	ID_TIMER equ 1
	sz equ 500
.code
start:
	xor edi,edi
	push NULL
	call GetModuleHandle
	mov hInstance, eax
	
	call GetCommandLine
	mov CommandLine, eax
	push SW_SHOWDEFAULT
	push CommandLine
	push NULL
	push hInstance
	call WinMain
	ret
	
WinMain proc hInst: HINSTANCE, hPrevInst: HINSTANCE, CmdLine: LPSTR, CmdShow: dword
	Local wc:WNDCLASSEX
	Local msg:MSG
	local hwnd:HWND
	;start
	mov wc.cbSize, SIZEOF WNDCLASSEX
	mov wc.style, CS_HREDRAW or CS_VREDRAW
	mov wc.lpfnWndProc, offset WndProc
	mov wc.cbClsExtra, NULL
	mov wc.cbWndExtra, NULL
	push hInst
	pop wc.hInstance
	mov wc.hbrBackground, COLOR_BTNFACE +1
	mov wc.lpszMenuName, offset MenuName
	mov wc.lpszClassName, offset ClassName
	
	push IDI_APPLICATION
	push NULL
	call LoadIcon
	
	mov wc.hIcon, eax
	mov wc.hIconSm,eax
	push IDC_ARROW
	push NULL
	call LoadCursor

	mov wc.hCursor, eax

	lea ecx, wc
	push ecx
	call RegisterClassEx

	push NULL
	push hInst
	push NULL
	push NULL
	push sz
	push sz
	push CW_USEDEFAULT
	push CW_USEDEFAULT
	push WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX or WS_MAXIMIZEBOX
	push offset AppName
	push offset ClassName
	push WS_EX_CLIENTEDGE
	call CreateWindowEx

	mov hwnd, eax

	push SW_SHOWNORMAL
	push hwnd
	call ShowWindow

	push hwnd
	call UpdateWindow

	.WHILE TRUE

		push 0
		push 0
		push NULL
		lea ecx, msg
		push ecx
		call GetMessage

		.BREAK .IF (!eax)

		lea ecx, msg
		push ecx
		call TranslateMessage

		lea ecx, msg
		push ecx
		call DispatchMessage
	.ENDW

	mov eax, msg.wParam
	ret 

WinMain endp
createRound proc
	;x,y
	push ebp
	mov ebp,esp
	pushad
	
	push DC_PEN
	call GetStockObject
	push eax
	push hdc
	call SelectObject
	
	push 0
	push hdc
	call SetDCPenColor
	
	push DC_BRUSH
	call GetStockObject
	push eax
	push hdc
	call SelectObject
	
	push 0ff0000h
	push hdc
	call SetDCBrushColor
	
	mov eax, dword ptr [y] 		;y
	mov ebx, dword ptr [x]		;x
	add eax,30
	push eax 				;bottom
	sub eax,60
	add ebx,30
	push ebx
	sub ebx,60
	push eax
	push ebx
	push hdc
	call Ellipse
	popad
	pop ebp
	ret
createRound endp

WndProc proc 	hWnd: HWND,
				uMSG: UINT,
				wParam: WPARAM,
				lParam: LPARAM
	;start
	.if uMSG == WM_CREATE
		push NULL
		push 1
		push ID_TIMER
		push hWnd
		call SetTimer
	.elseif uMSG == WM_TIMER
		push FALSE
		push NULL
		push hWnd
		call InvalidateRect
	.elseif uMSG == WM_PAINT
		lea ecx,ps
		push ecx
		push hWnd
		call BeginPaint
		mov hdc,eax 
		
		.if y <= 30
			.if huong == 3
				mov huong, 0
			.elseif huong ==2
				mov huong, 1
			.endif
		.elseif y >= sz+30
			.if huong == 1
				mov huong, 2
			.elseif huong == 0
				mov huong,3 
			.endif
		.elseif x <= 30
			.if huong == 2
				mov huong,3
			.elseif huong ==1
				mov huong,0
			.endif
		.elseif x >= sz+30
			.if huong == 0
				mov huong,1
			.elseif huong == 3 
				mov huong,2
			.endif
		.endif
		
		.if huong == 0
			inc x
			inc y
		.elseif huong ==1
			dec x
			inc y
		.elseif huong ==2 
			dec x 
			dec y
		.elseif huong ==3
			inc x 
			dec y
		.endif 
		push 0ffffffh
		push hdc 
		call SetDCBrushColor
		push sz
		push sz
		push 0
		push 0
		push hdc
		call Rectangle
		
		call createRound
	.elseif uMSG == WM_DESTROY
		push ID_TIMER 
		push hWnd
		call KillTimer
		
		push 0
		call PostQuitMessage
	.else
		push lParam
		push wParam
		push uMSG
		push hWnd
		call DefWindowProc
	.endif 
	xor eax,eax
	ret
WndProc endp
end start 
