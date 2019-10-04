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
	push 210
	push 300
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
		
		Push NULL              	
    	Push hInstance       	
    	Push EditID             
    	Push hWnd            	
    	Push 25               	
    	Push 200             	
    	Push 35                	
    	Push 40                	
    	Push WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or ES_AUTOHSCROLL 	
    	Push NULL             	
    	Push Offset EditClassName
    	Push WS_EX_CLIENTEDGE 	
    	Call CreateWindowEx     
    	
        Mov  hwndEdit1, eax     	

        Push hwndEdit1
        Call SetFocus

        Push NULL              	
    	Push hInstance       	
    	Push EditID2            
    	Push hWnd            	
    	Push 25               	
    	Push 200             	
    	Push 70                	
    	Push 40                	
    	Push WS_CHILD or WS_VISIBLE or WS_DISABLED	
    	Push NULL             	
    	Push Offset EditClassName2 	
    	Push WS_EX_CLIENTEDGE 	
    	Call CreateWindowEx     
    	
        Mov  hwndEdit2, eax     	

     	push 0
     	push IDM_HELLO
     	push WM_COMMAND
     	push hWnd 
     	call SendMessage
    .ELSEIF uMsg == WM_COMMAND
    	mov eax, wParam
    	.IF lParam == 0
    		.IF ax == IDM_HELLO
    			push offset TestText
    			push hwndEdit1
    			call SetWindowText

    			
    		.ELSEIF ax == IDM_GETTEXT
    			push 512
    			push offset buffer
    			push hwndEdit1
    			call GetWindowText

    			push offset buffer
            	call Reversing_Text

    			Push 0            	
                Push IDM_SETTEXT	
                Push WM_COMMAND		
                Push hWnd          	
                Call SendMessage    

            .ELSEIF ax == IDM_SETTEXT

            	push offset buffer
    			push hwndEdit2
    			call SetWindowText

    
    		.ELSE
    			push hWnd
    			call DestroyWindow
    		.ENDIF

    	.ELSE
    		.IF ax == EditID
       			
       			Push 0            	
                Push IDM_GETTEXT	
                Push WM_COMMAND		
                Push hWnd          	
                Call SendMessage    
                	
	     	.ENDIF

    	.ENDIF


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


Reversing_Text proc
	push ebp
	mov ebp, esp
	mov ecx, [ebp + 08h]
	xor esi, esi
	push ecx
	call Strlen
	mov edi, eax
	shr eax, 1
	dec eax
	xor edx, edx
main_loop:
	push edi
	mov dl, byte ptr [ecx + esi]
	sub edi, esi
	mov dh, byte ptr [ecx + edi - 1]
	mov byte ptr [ecx + esi], dh
	mov byte ptr [ecx + edi - 1], dl
	inc esi
	pop edi
	cmp esi, eax
	jle main_loop

	pop ebp
	ret 4
Reversing_Text endp


Strlen proc
	push ebp
	mov ebp, esp
	push ecx
	push esi
	mov ecx, [ebp + 08h]
	xor esi, esi
main_loop:
	cmp byte ptr [ecx + esi], 0
	jz done
	inc esi
	jmp main_loop
done:
	mov eax, esi
	pop esi
	pop ecx
	pop ebp
	ret 4
Strlen endp
end start
