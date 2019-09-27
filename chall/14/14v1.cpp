#include <windows.h>


LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

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
		100, 100, 1000, 1000, NULL, NULL, hInstance, NULL);

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
		x.top = temp.y-30;
		x.left = temp.x - 30;
		x.right = temp.x + 30;
	}
};
struct ORound
{
	RECT x;
	POINT tam;
	ORound()
	{
		x.bottom = 35;
		x.left = 0;
		x.right = 35;
		x.top = 0;
	}
	ORound(POINT temp)
	{
		x.bottom = temp.y + 35;
		x.top = temp.y - 35;
		x.left = temp.x - 35;
		x.right = temp.x + 35;
	}
};
void createRound(HDC hdc, POINT temp)
{
	ORound bla(temp);
	SelectObject(hdc, GetStockObject(DC_PEN));
	SetDCPenColor(hdc, RGB(0, 0, 0));
	SelectObject(hdc, GetStockObject(DC_BRUSH));
	SetDCBrushColor(hdc, RGB(0, 0, 0));
	Ellipse(hdc, bla.x.left, bla.x.top, bla.x.right, bla.x.bottom);
	
	oRound cla(temp);
	SelectObject(hdc, GetStockObject(DC_PEN));
	SetDCPenColor(hdc, RGB(255, 0, 0));
	SelectObject(hdc, GetStockObject(DC_BRUSH));
	SetDCBrushColor(hdc, RGB(255, 0, 0));
	Ellipse(hdc, cla.x.left, cla.x.top, cla.x.right, cla.x.bottom);
}
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg,
	WPARAM wParam, LPARAM lParam) {

	HDC hdc;
	PAINTSTRUCT ps;
	switch (msg) {

	case WM_PAINT:
		
		hdc = BeginPaint(hwnd, &ps);
		RECT rect;
		GetClientRect(hwnd, &rect);
		POINT bla;
		bla.x = 50;
		bla.y = 50;
		createRound(hdc, bla);
		
		EndPaint(hwnd, &ps);
		break;

	case WM_DESTROY:

		PostQuitMessage(0);
		return 0;
	}

	return DefWindowProcW(hwnd, msg, wParam, lParam);
}
