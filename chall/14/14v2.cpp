#include <windows.h>
#include <ctime>
#define ID_TIMER    1
#define size 500
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
POINT bla;
int huong;
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
	PWSTR lpCmdLine, int nCmdShow) {

	MSG  msg;
	WNDCLASSW wc = { 0 };
	srand(time(0));
	huong = rand() % 4;
	bla.x = rand() % size;
	bla.y = rand() % size;
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpszClassName = L"Shapes";
	wc.hInstance = hInstance;
	wc.hbrBackground = GetSysColorBrush(COLOR_3DFACE);
	wc.lpfnWndProc = WndProc;
	wc.hCursor = LoadCursor(0, IDC_ARROW);

	RegisterClassW(&wc);
	CreateWindowW(wc.lpszClassName, L"Shapes",
		WS_OVERLAPPEDWINDOW | WS_VISIBLE,
		0, 0, size, size, NULL, NULL, hInstance, NULL);

	while (GetMessage(&msg, NULL, 0, 0)) {

		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return (int)msg.wParam;
}

struct oRound
{
	RECT x;
	POINT tam;
	oRound()
	{
		x.bottom = 30;
		x.left = 0;
		x.right = 30;
		x.top = 0;
	}
	oRound(POINT temp)
	{
		x.bottom = temp.y + 30;
		x.top = temp.y - 30;
		x.left = temp.x - 30;
		x.right = temp.x + 30;
	}
};
void createRound(HDC hdc, POINT temp)
{
	oRound cla(temp);
	SelectObject(hdc, GetStockObject(DC_PEN));
	SetDCPenColor(hdc, RGB(0, 0, 0));
	SelectObject(hdc, GetStockObject(DC_BRUSH));
	SetDCBrushColor(hdc, RGB(255, 0, 0));
	Ellipse(hdc, cla.x.left, cla.x.top, cla.x.right, cla.x.bottom);
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
		return 0;
	case WM_TIMER:    
		  
		InvalidateRect(hwnd, NULL, FALSE);

		return 0;
	case WM_PAINT:    
		hdc = BeginPaint(hwnd, &ps);
		if (bla.y <= 30)
		{
			if (huong == 3) huong = 0;
			if (huong == 2) huong = 1;
		}
		else
		if (bla.y >= size-30)
		{
			if (huong == 1) huong = 2;
			if (huong == 0) huong = 3;
		}
		else
		if (bla.x <= 30)
		{
			if (huong == 2) huong = 3;
			if (huong == 1) huong = 0;
		}
		else 
		if (bla.x >= size-30)
		{
			if (huong == 0) huong = 1;
			if (huong == 3) huong = 2;
		}
		if (huong == 0)
		{
			bla.x++;
			bla.y++;
		}
		if (huong == 1)
		{
			bla.x--;
			bla.y++;
		}
		if (huong == 2)
		{
			bla.x--;
			bla.y--;
		}
		if (huong == 3)
		{
			bla.x++;
			bla.y--;
		}
		SetDCBrushColor(hdc, RGB(255, 255, 255));
		Rectangle(hdc, 0, 0, size, size);
		createRound(hdc, bla);
		return 0;
	case WM_DESTROY:       
		KillTimer(hwnd, ID_TIMER);    
		PostQuitMessage(0);      
		return 0;
	}    
	return DefWindowProc(hwnd, message, wParam, lParam);
}
