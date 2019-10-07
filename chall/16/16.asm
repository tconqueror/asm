.386
.model flat, stdcall
option casemap:none

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\masm32.inc
         
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\masm32.lib


.data 
ClassName db "WinClass", 0
AppName db "Reverse", 0
MenuName db "Menu", 0
EditClassName db "Edit", 0
EditClassName2 db "Edit", 0
TestText db "BlaBlaBla", 0

.data?
hInstance HINSTANCE ?
CommandLine LPSTR ?
hwndEdit1 HWND ?
hwndEdit2 HWND ?
buffer db 512 dup(?)


.const

EditID equ 1
EditID2 equ 2
IDM_HELLO equ 0
IDM_GETTEXT equ 1
IDM_SETTEXT equ 2
ID_TIMER equ 1
.code

start:
	xor edi, edi

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

Exit:
	ret
;The Main fuction for the app
WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
	Local wc:WNDCLASSEX
	Local msg:MSG
	Local hwnd:HWND

	mov wc.cbSize, SIZEOF WNDCLASSEX
	mov wc.style, CS_HREDRAW or CS_VREDRAW
	mov wc.lpfnWndProc, Offset WndProc
	mov wc.cbClsExtra, NULL
	mov wc.cbWndExtra, NULL
	push hInst
	pop wc.hInstance
	mov wc.hbrBackground, COLOR_BTNFACE + 1
	mov wc.lpszMenuName, offset MenuName
	mov wc.lpszClassName, offset ClassName

	push IDI_APPLICATION
	push NULL
	call LoadIcon

	mov wc.hIcon, eax
	mov wc.hIconSm, eax

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
	push 50
	push 200
	push CW_USEDEFAULT
	push CW_USEDEFAULT
	push WS_OVERLAPPEDWINDOW
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


WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.IF uMsg == WM_DESTROY
		push NULL
		call PostQuitMessage

	.ELSEIF uMsg == WM_CREATE
		push NULL
		push 5000
		push ID_TIMER
		push hWnd
		call SetTimer
		
    .ELSEIF uMsg == WM_TIMER
    	;push NULL
		;push offset enumWindowCallback
		;call EnumWindows
    .ELSE
    	push lParam
    	push wParam
    	push uMsg
    	push hWnd
    	call DefWindowProc

    	ret
    .ENDIF

    xor eax, eax
    ret
WndProc endp

end start
