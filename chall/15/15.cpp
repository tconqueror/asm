#include <windows.h>
#include <ctime>
#include <tchar.h>
#define ID_TIMER    1
#define size 500
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
HWND TextBox;
HWND rTextBox;
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
	PWSTR lpCmdLine, int nCmdShow) {

	MSG  msg;
	WNDCLASSW wc = { 0 };
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpszClassName = L"Shapes";
	wc.hInstance = hInstance;
	wc.hbrBackground = GetSysColorBrush(COLOR_3DFACE);
	wc.lpfnWndProc = WndProc;
	wc.hCursor = LoadCursor(0, IDC_ARROW);

	RegisterClassW(&wc);
	CreateWindowW(wc.lpszClassName, L"Shapes",
		WS_OVERLAPPEDWINDOW | WS_VISIBLE,
		0, 0, size, size/2, NULL, NULL, hInstance, NULL);

	while (GetMessage(&msg, NULL, 0, 0)) {

		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return (int)msg.wParam;
}
TCHAR str[100];
TCHAR rstr[100];
int length;
void reverseString(int length)
{
	for (int i = 0; i < length; i++)
	{
		rstr[i] = str[length - i - 1];
	}
	rstr[length] = 0;
}
LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	HDC hdc;
	PAINTSTRUCT ps;
	RECT rect;
	GetClientRect(hwnd, &rect);
	switch (message)
	{
	case WM_CREATE:
		SetTimer(hwnd, ID_TIMER, 1, NULL);
		TextBox = CreateWindow(L"EDIT",L"",WS_BORDER | WS_CHILD | WS_VISIBLE, 10,50,size-10,20,hwnd,NULL,NULL,NULL);
		rTextBox = CreateWindow(L"STATIC", str, WS_BORDER | WS_CHILD | WS_VISIBLE, 10,100, size - 10, 20, hwnd, NULL, NULL, NULL);
		return 0;
	case WM_TIMER:
		//for (int i = 0; i < 100; i++)
		//	str[i] = 0;
		length = GetWindowText(TextBox, str, 100);
		reverseString(length);
		SetWindowText(rTextBox, rstr);
		// rTextBox = CreateWindow(L"STATIC", str, WS_BORDER | WS_CHILD | WS_VISIBLE, 10, 100, size - 10, 20, hwnd, NULL, NULL, NULL);
		return 0;
	
	case WM_DESTROY:
		KillTimer(hwnd, ID_TIMER);
		PostQuitMessage(0);
		return 0;
	}
	return DefWindowProc(hwnd, message, wParam, lParam);
}
