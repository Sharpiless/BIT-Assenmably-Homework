.386
.model flat,stdcall
option casemap:none

include windows.inc
include gdi32.inc
includelib gdi32.lib
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib

.data
hInstance dd ?  ;���Ӧ�ó���ľ��
hWinMain dd ?   ;��Ŵ��ڵľ��
showButton byte 'button',0
button db 'button',0

.const
szClassName db 'MyClass',0
szCaptionMain db 'My first Window!',0
szText db 'Win32 Assembly,Simple and powerful!',0

.code

_ProcWinMain proc uses ebx edi esi,hWnd,uMsg,wParam,lParam  ;���ڹ���
	local @stPs:PAINTSTRUCT
	local @stRect:RECT
	local @hDc

	mov eax,uMsg  ;uMsg����Ϣ���ͣ��������WM_PAINT,WM_CREATE

	.if eax==WM_PAINT  ;������Լ����ƿͻ�����������Щ���룬����һ�δ򿪴��ڻ���ʾʲô��Ϣ
		invoke BeginPaint,hWnd,addr @stPs
		mov @hDc,eax

		invoke GetClientRect,hWnd,addr @stRect
		invoke DrawText,@hDc,addr szText,-1,addr @stRect,DT_SINGLELINE or DT_CENTER or DT_VCENTER  ;���ｫ��ʾszText����ַ���
		invoke EndPaint,hWnd,addr @stPs
	
	.elseif eax==WM_CLOSE  ;���ڹر���Ϣ
		invoke DestroyWindow,hWinMain
		invoke PostQuitMessage,NULL

	.elseif eax==WM_CREATE  ;��������  ��������ʾ����һ����ť������button�ַ���ֵ��'button'�������ݶζ��壬��ʾҪ��������һ����ť��showButton��ʾ�ð�ť�ϵ���ʾ��Ϣ
		invoke CreateWindowEx,NULL,offset button,offset showButton,\
		WS_CHILD or WS_VISIBLE,10,10,200,30,\  ;10��10��200��30����ť�ߴ��С������ȡ�����
		hWnd,1,hInstance,NULL  ;1��ʾ�ð�ť�ľ����1

	.elseif eax==WM_COMMAND  ;���ʱ���������Ϣ��WM_COMMAND
		mov eax,wParam  ;���в���wParam�����Ǿ������������һ����ť����wParam���Ǹ���ť�ľ��
		.if eax==1  ;�������жϾ���Ƕ��ٵ�֪���ĸ���ť�������ˣ��Ӷ�����Ӧ�Ĳ�������������Ǿ��Ϊ1�İ�ť�����£��⽫����һ�����Ϊ2�İ�ť
			invoke CreateWindowEx,NULL,offset button,offset showButton,\
			WS_CHILD or WS_VISIBLE,100,100,200,30,\ 
			hWnd,2,hInstance,NULL 
		.endif

	;----------------------
	;��Ȼ���ⲿ�����Լ���ӵ���Ӧ�����¼��Ĵ��룬�����ĳ����ť������ð�ť�ᷢ��ʲô�µȡ�
	;������������Ϣ������WM_CREATE�������ڴ���ʱ��WM_COMMAND��ʾ�����ťʱ,��������ӷ�֧����д��Ӧ�Ĵ����¼��Ĵ���
	;----------------------

	.else  ;����Ĭ�ϴ�����������Ϣ
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.endif

	xor eax,eax
	ret
_ProcWinMain endp

_WinMain proc  ;���ڳ���
	local @stWndClass:WNDCLASSEX  ;������һ���ṹ����������������WNDCLASSEX��һ�������ඨ���˴��ڵ�һЩ��Ҫ���ԣ�ͼ�꣬��꣬����ɫ�ȣ���Щ�������ǵ������ݣ����Ƿ�װ��WNDCLASSEX�д��ݵġ�
	local @stMsg:MSG	;��������stMsg��������MSG����������Ϣ���ݵ�	

	invoke GetModuleHandle,NULL  ;�õ�Ӧ�ó���ľ�����Ѹþ����ֵ����hInstance�У������ʲô���򵥵�������ĳ������ı�ʶ�����ļ���������ھ��������ͨ������ҵ���Ӧ������
	mov hInstance,eax
	invoke RtlZeroMemory,addr @stWndClass,sizeof @stWndClass  ;��stWndClass��ʼ��ȫ0

	invoke LoadCursor,0,IDC_ARROW
	mov @stWndClass.hCursor,eax					;---------------------------------------
	push hInstance							;
	pop @stWndClass.hInstance					;
	mov @stWndClass.cbSize,sizeof WNDCLASSEX			;�ⲿ���ǳ�ʼ��stWndClass�ṹ�и��ֶε�ֵ�������ڵĸ�������
	mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW			;���ŵĻ����ⲿ��ֱ��copy- -������Ϊ�˸ϻ����ҵ��ûʱ������
	mov @stWndClass.lpfnWndProc,offset _ProcWinMain			;
	;�������������ʵ����ָ���˸ô��ڳ���Ĵ��ڹ�����_ProcWinMain	;
	mov @stWndClass.hbrBackground,COLOR_WINDOW+1			;
	mov @stWndClass.lpszClassName,offset szClassName		;---------------------------------------
	invoke RegisterClassEx,addr @stWndClass  ;ע�ᴰ���࣬ע��ǰ����д����WNDCLASSEX�ṹ

	invoke CreateWindowEx,WS_EX_CLIENTEDGE,\  ;��������
			offset szClassName,offset szCaptionMain,\  ;szClassName��szCaptionMain���ڳ������ж�����ַ�������
			WS_OVERLAPPEDWINDOW,100,100,600,400,\	;szClassName�ǽ�������ʹ�õ������ַ���ָ�룬������'MyClass'����ʾ��'MyClass'��������������ڣ��������ӵ��'MyClass'����������
			NULL,NULL,hInstance,NULL		;����ĳ�'button'��ô�����Ľ���һ����ť��szCaptionMain��������Ǵ��ڵ����ƣ������ƻ���ʾ�ڱ�������
	mov hWinMain,eax  ;�������ں��������eax�У����ڰѾ������hWinMain�С�
	invoke ShowWindow,hWinMain,SW_SHOWNORMAL  ;��ʾ���ڣ�ע�⵽����������ݵĲ����Ǵ��ڵľ��������ǰ����˵�ģ�ͨ����������ҵ�������ʶ������
	invoke UpdateWindow,hWinMain  ;ˢ�´��ڿͻ���

	.while TRUE  ;�������޵���Ϣ��ȡ�ʹ����ѭ��
		invoke GetMessage,addr @stMsg,NULL,0,0  ;����Ϣ������ȡ����һ����Ϣ������stMsg�ṹ��
		.break .if eax==0  ;������˳���Ϣ��eax�����ó�0���˳�ѭ��
		invoke TranslateMessage,addr @stMsg  ;���ǰѻ��ڼ���ɨ����İ�����Ϣת���ɶ�Ӧ��ASCII�룬�����Ϣ����ͨ����������ģ��ⲽ������
		invoke DispatchMessage,addr @stMsg  ;���������������ҵ��ô��ڳ���Ĵ��ڹ��̣�ͨ���ô��ڹ�����������Ϣ
	.endw
	ret
_WinMain endp

main proc
	call _WinMain  ;������͵����˴��ڳ���ͽ���������������
	invoke ExitProcess,NULL
	ret
main endp
end main
