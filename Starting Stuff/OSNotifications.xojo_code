#tag Module
Protected Module OSNotifications
	#tag Method, Flags = &h1
		Protected Sub Notify()
		  #If targetMacOS
		    
		  #ElseIf TargetWindows
		    
		    WinDoNotify
		    
		  #ElseIf targetLinux
		    Break
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub WinDoNotify()
		  // https://learn.microsoft.com/en-us/windows/win32/shell/notification-area
		  // 
		  // typedef struct _NOTIFYICONDATAA {
		  // DWORD cbSize;
		  // HWND  hWnd;
		  // UINT  uID;
		  // UINT  uFlags;
		  // UINT  uCallbackMessage;
		  // HICON hIcon;
		  // #If ...
		  // CHAR  szTip[64];
		  // #Else
		  // CHAR  szTip[128];
		  // #EndIf
		  // DWORD dwState;
		  // DWORD dwStateMask;
		  // CHAR  szInfo[256];
		  // union {
		  // UINT uTimeout;
		  // UINT uVersion;
		  // } DUMMYUNIONNAME;
		  // CHAR  szInfoTitle[64];
		  // DWORD dwInfoFlags;
		  // GUID  guidItem;
		  // HICON hBalloonIcon;
		  // } NOTIFYICONDATAA, *PNOTIFYICONDATAA;
		  // 
		  // 
		  // BOOL Shell_NotifyIconA(
		  // [in] DWORD            dwMessage,
		  // [in] PNOTIFYICONDATAA lpData
		  // );
		End Sub
	#tag EndMethod


	#tag Structure, Name = WinGUID, Flags = &h0
		Data1 as Uint32
		  Data2 as Uint16
		  Data3 as Uint16
		Data4 as String*8

	#tag EndStructure

	#tag Structure, Name = WinNotifyData, Flags = &h1
		cbSize as Uint32
		  hWnd as INTEGER
		  uID AS UINT32
		  uFlags as Uint32
		  uCallbackMessage as Uint32
		  hIcon as Integer
		  szTip as String*128
		  dwState as Uint32
		  dwStateMask as Uint32
		  szInfo as String*256
		  uTimeoutVersion as UINT32
		  szInfoTitle as String*64
		  dwInfoFlags as Uint32
		  guidItem as WinGUID
		hBalloonIcon as Integer
	#tag EndStructure


End Module
#tag EndModule
