.386
.model flat, stdcall
option casemap:none

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
include c:\masm32\include\gdi32.inc
         
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\msvcrt.lib
includelib c:\masm32\lib\masm32.lib
includelib c:\masm32\lib\gdi32.lib

.data 
ClassName db "SimpleWinClass", 0
AppName db "Simple Bouncing Ball", 0
MenuName db "First Menu", 0
curL dd 100
curT dd 50
curR dd 200
curB dd 150
key db 0 

.data?
hInstance HINSTANCE ?
CommandLine LPSTR ?
hDC HDC ?
ps PAINTSTRUCT <>
hOldBrush HBRUSH ?
hNewBrush HBRUSH ?
hOldPen HPEN ?
hNewPen HPEN ?


.const
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
	push 400
	push 400
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


WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.IF uMsg == WM_DESTROY
		push NULL
		call PostQuitMessage
    
    .ELSEIF uMsg == WM_PAINT
    	lea ecx, ps
    	push ecx
    	push hWnd
    	call BeginPaint
    	mov hDC, eax

    	push 000000h ; black
    	push 2
    	push PS_SOLID
    	call CreatePen
    	mov hNewPen, eax

    	push eax
    	push hDC
    	call SelectObject
    	mov hOldPen, eax

    	push 0000ffh; red
    	call CreateSolidBrush
    	mov hNewBrush, eax

    	push eax
    	push hDC
    	call SelectObject
    	mov hOldBrush, eax

    	push curB
    	push curR
    	push curT
    	push curL
    	push hDC
    	call Ellipse

    	push 10
    	call Sleep
	check_0:		
		cmp key, 0
		jnz check_1

		cmp curL, 0
		jnz check_0x

	check_01:	
		mov al, 1
		mov key, al
		jmp check_1

	check_0x:
		push -10
		push 10
		push -10
		push 10
		call SetCurPos
		jmp DrawBall



	check_1:
		cmp key, 1
		jnz check_2

		cmp curB, 400
		jl check_1x
		mov al, 2
		mov key, al
		jmp check_2
	check_1x:
		push 10
		push 10
		push 10
		push 10
		call SetCurPos

		jmp DrawBall
	check_2:
		cmp key, 2
		jnz check_3

		cmp curR, 400
		jnz check_2x
		mov al, 3
		mov key, al
		jmp check_3

	check_2x:	
		push 10
		push -10
		push 10
		push -10
		call SetCurPos
		jmp DrawBall

	check_3:
		cmp curT, 0
		jnz check_3x
		mov al, 0
		mov key, al
		jmp check_0

	check_3x:
		push -10
		push -10
		push -10
		push -10
		call SetCurPos


DrawBall:

		push hOldBrush
		push hDC
		call SelectObject

		push hNewBrush
		call DeleteObject

		push hOldPen
		push hDC
		call SelectObject

		push hNewPen
		call DeleteObject

		push offset ps
		push hWnd
		call EndPaint

		push 1
    	push NULL
    	push hWnd
    	call InvalidateRect

    .ELSEIF uMsg == WM_TIMER
    	push 0
    	push NULL
    	push hWnd
    	call InvalidateRect	
    	
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

SetCurPos proc
	push ebp
	mov ebp, esp
	;current left
	mov eax, curL
	add eax, [ebp + 14h] 
	mov curL, eax

	;current top
	mov eax, curT
	add eax, [ebp + 10h]
	mov curT, eax

	;current right
	mov eax, curR
	add eax, [ebp + 0Ch]
	mov curR, eax

	;current bottom
	mov eax, curB
	add eax, [ebp + 08h]
	mov curB, eax

	pop ebp
	ret 10h

SetCurPos endp

end start
