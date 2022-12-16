#tag Module
Protected Module WindowExtensions
	#tag Method, Flags = &h0
		Function BetterBitmapForCaching(extends w as Window, width as integer, height as integer, depth as integer = 0) As Picture
		  Dim base As picture = w.BitmapForCaching(1,1)
		  
		  If base <> Nil Then
		    
		    Dim g As graphics = base.Graphics
		    
		    Dim p As picture
		    
		    If depth <> 0 Then
		      p = New picture(width * g.ScaleX, height * g.ScaleY, depth )
		    Else
		      p = New picture(width * g.ScaleX, height * g.ScaleY )
		    End If
		    
		    p.Graphics.ScaleX = g.ScaleX
		    p.Graphics.ScaleY = g.ScaleY
		    p.Graphics.AntiAlias = g.AntiAlias
		    p.Graphics.AntiAliasMode = g.AntiAliasMode
		    p.Graphics.Bold = g.Bold
		    p.Graphics.ForeColor = g.ForeColor
		    p.Graphics.Italic = g.Italic
		    p.Graphics.PenHeight = g.PenHeight
		    p.Graphics.PenWidth = g.PenWidth
		    p.Graphics.TextFont = g.TextFont
		    p.Graphics.TextSize = g.TextSize
		    p.Graphics.TextUnit = g.TextUnit
		    p.Graphics.Transparency = g.Transparency
		    p.Graphics.Underline = g.Underline
		    
		    Return p
		    
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindControlWithName(extends w as Window, name as string, index as integer = -2147483648) As Variant
		  // index = -2147483648 is a "magic" xojo value for "no index" or "not part of a control set"
		  
		  If index = -2147483648 Then
		    Return w._ControlByName(name)
		  Else
		    Return w._ControlByNameIndex(name, index) 
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FirstWindowOfType(findInfo as Introspection.TypeInfo) As Window
		  For i As Integer = 0 To WindowCount - 1
		    
		    Dim thisWindowInfo As  Introspection.TypeInfo = Introspection.GetType( Window(i) )
		    
		    If thisWindowInfo.FullName = findInfo.FullName Then
		      Return Window(i)
		    End If
		    
		  Next
		  
		  Return Nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HidesOnDeactivate(extends w as Window, shouldHide as boolean)
		  #If TargetCocoa
		    Declare Sub NSWindowSetHidesOnDeactivate Lib "AppKit" selector "setHidesOnDeactivate:" (obj As Integer, value As Boolean)
		    
		    NSWindowSetHidesOnDeactivate(w.Handle,shouldHide)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsFullScreen(extends w as Window) As boolean
		  #If TargetMacOS
		    // https://developer.apple.com/documentation/appkit/nsview/1483337-isinfullscreenmode
		    // Declaration
		    // @property(getter=isInFullScreenMode, readonly) BOOL inFullScreenMode;
		    
		    Declare Function getIsInFullScreenMode Lib "Cocoa.framework" selector "isInFullScreenMode" (obj As Integer) As Boolean
		    
		    Return getIsInFullScreenMode( w.Handle )
		    
		    
		  #EndIf
		  
		  #If TargetWindows
		    
		    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-windowplacement
		    // C++
		    // 
		    // Copy
		    // typedef struct tagWINDOWPLACEMENT {
		    // UINT  length;
		    // UINT  flags;
		    // UINT  showCmd;
		    // POINT ptMinPosition;
		    // POINT ptMaxPosition;
		    // RECT  rcNormalPosition;
		    // RECT  rcDevice;
		    // } WINDOWPLACEMENT;
		    
		    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowplacement
		    // User32.lib
		    // Soft Declare BOOL GetWindowPlacement(
		    // HWND            hWnd,
		    // WINDOWPLACEMENT *lpwndpl
		    // );
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsMaximized(extends w as Window) As boolean
		  #Pragma unused w
		  
		  #If TargetMacOS
		    
		  #EndIf
		  
		  #If TargetWindows
		    // // https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-windowplacement
		    // // C++
		    // // 
		    // // Copy
		    // // typedef struct tagWINDOWPLACEMENT {
		    // // UINT  length;
		    // // UINT  flags;
		    // // UINT  showCmd;
		    // // POINT ptMinPosition;
		    // // POINT ptMaxPosition;
		    // // RECT  rcNormalPosition;
		    // // RECT  rcDevice;
		    // // } WINDOWPLACEMENT;
		    // 
		    // Dim position As WINDOWPLACEMENT
		    // position.length = 32
		    // 
		    // // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowplacement
		    // // User32.lib
		    // // Soft Declare BOOL GetWindowPlacement(
		    // // HWND            hWnd,
		    // // WINDOWPLACEMENT *lpwndpl
		    // // );
		    // 
		    // Soft Declare Function GetWindowPlacement Lib "User32.dll" ( hWnd As Integer, ByRef lpwndpl As WINDOWPLACEMENT) As Boolean
		    // 
		    // If GetWindowPlacement ( w.handle, position ) Then
		    // Break
		    // Else
		    // Break
		    // End If
		    
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeContentAreaFillWindow(extends w as Window)
		  #If TargetMacOS
		    Const AppKit = "AppKit"
		    Const NSWindowTitleHidden = 1
		    Const NSFullSizeContentViewWindowMask = 32768
		    
		    Declare Sub titleVisibility Lib AppKit Selector "setTitleVisibility:" (handle As Integer, value As Integer)
		    titleVisibility(w.Handle, NSWindowTitleHidden)
		    
		    Declare Sub setStyleMask Lib AppKit Selector "setStyleMask:" (handle As Integer, value As Integer)
		    Declare Function styleMask Lib AppKit Selector "styleMask" (handle As Integer) As Integer
		    setStyleMAsk(w.Handle, styleMask(w.Handle) + NSFullSizeContentViewWindowMask)
		    
		    Declare Sub titlebarAppearsTransparent Lib AppKit Selector "setTitlebarAppearsTransparent:" (handle As Integer, value As Boolean)
		    titleBarAppearsTransparent(w.Handle, True)
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name(extends w as Window) As string
		  
		  Dim tinfo As Introspection.TypeInfo = Introspection.GetType(w)
		  
		  Return tInfo.Name
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveTitleBar(extends w as window)
		  #If TargetMacOS
		    
		    // the masks are In NSWindow.h
		    
		    Const NSWindowStyleMaskBorderless     = 0
		    Const NSWindowStyleMaskTitled         = 1 // 1 << 0,
		    Const NSWindowStyleMaskClosable       = 2 // 1 << 1,
		    Const NSWindowStyleMaskMiniaturizable = 4 // 1 << 2,
		    Const NSWindowStyleMaskResizable      = 8 // 1 << 3,
		    
		    // /* Specifies a Window With textured background. Textured windows generally don't draw a top border line under the titlebar/toolbar. To get that line, use the NSUnifiedTitleAndToolbarWindowMask mask.
		    // */
		    Const NSWindowStyleMaskTexturedBackground = 256 // API_DEPRECATED("Textured window style should no longer be used", macos(10.2, 11.0)) = 1 << 8,
		    
		    // /* Specifies a Window whose titlebar And toolbar have a unified look - that Is, a continuous background. Under the titlebar And toolbar a horizontal separator line will appear.
		    // */
		    Const NSWindowStyleMaskUnifiedTitleAndToolbar = 8192 // = 1 << 12,
		    
		    // /* When set, the Window will appear full Screen. This mask Is automatically toggled when toggleFullScreen: Is called.
		    // */
		    Const NSWindowStyleMaskFullScreen = 16384 // = 1 << 14,
		    
		    // /* If set, the contentView will consume the full size Of the window; it can be combined With other Window style masks, but Is only respected For windows With a titlebar.
		    // Utilizing this mask opts-In To layer-backing. Utilize the contentLayoutRect Or Auto-layout contentLayoutGuide To layout views underneath the titlebar/toolbar area.
		    // */
		    Const NSWindowStyleMaskFullSizeContentView  = 32768 // API_AVAILABLE(macos(10.10)) = 1 << 15,
		    
		    // /* The following are only applicable For NSPanel (Or a subclass thereof)
		    // */
		    Const NSWindowStyleMaskUtilityWindow        =   16 // = 1 << 4,
		    Const NSWindowStyleMaskDocModalWindow       =   64 // = 1 << 6,
		    Const NSWindowStyleMaskNonactivatingPanel   =  128 // = 1 << 7, // Specifies that a panel that does not activate the owning application
		    Const NSWindowStyleMaskHUDWindow            = 8192 // = 1 << 13 // API_AVAILABLE(macos(10.6)) // Specifies a heads up display panel
		    
		    Dim newStyle As UInt32 = 0 //no titlebar
		    
		    Soft Declare Sub setStyleMask Lib "Cocoa.framework" selector "setStyleMask:" (id As Ptr, mask As UInt32)
		    setStyleMask(Ptr(w.Handle), newStyle)
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetTabbingMode(extends w as Window, mode as WindowTabbingMode)
		  #If TargetMacOS
		    Declare Sub SetTabbingMode Lib "AppKit" selector "setTabbingMode:" (obj As Integer, value As Integer)
		    
		    // Automatic    0    
		    // Disallowed    2    
		    // Preferred    1
		    
		    SetTabbingMode(w.handle, Integer(mode) )
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnifiedTitleAndToolbar(extends w as window)
		  #If targetMacOS
		    
		    Declare Function NSClassFromString Lib "Foundation" (aClassName As CFStringRef) As Ptr
		    If NSClassFromString( "NSVisualEffectView" ) <> Nil Then
		      Declare Sub titleVisibility Lib "AppKit" selector "setTitleVisibility:" ( handle As Integer, value As Integer )
		      Const NSWindowTitleHidden = 1
		      titleVisibility( w.handle, NSWindowTitleHidden )
		    End If
		    
		    Const NSFullSizeContentViewWindowMask = 32768
		    If NSClassFromString( "NSVisualEffectView" ) <> Nil Then
		      Declare Sub setStyleMask Lib "AppKit" selector "setStyleMask:" ( handle As Integer, value As Integer )
		      Declare Function styleMask Lib "AppKit" selector "styleMask" ( handle As Integer ) As Integer
		      Declare Sub titlebarAppearsTransparent Lib "AppKit" selector "setTitlebarAppearsTransparent:" ( handle As Integer, value As Boolean )
		      
		      setStyleMask( w.handle, styleMask( w.handle ) + NSFullSizeContentViewWindowMask )
		      titleBarAppearsTransparent( w.handle, True )
		    End If
		  #EndIf
		End Sub
	#tag EndMethod


	#tag Structure, Name = WINDOWPLACEMENT, Flags = &h21
		length as Uint32
		  flags as Uint32 // UINT  flags
		  showCmd as Uint32 // UINT  showCmd
		  ptMinPosition as WINPOINT // POINT ptMinPosition;
		  
		  ptMaxPosition as WINPOINT // POINT ptMaxPosition;
		  tcNormalPosition as WINRECT // RECT  rcNormalPosition;
		rcDevice as WINRECT // RECT  rcDevice;
	#tag EndStructure

	#tag Structure, Name = WINPOINT, Flags = &h0
		x as Int32 //    LONG x;
		  
		y as Int32 //   LONG y;
	#tag EndStructure

	#tag Structure, Name = WINRECT, Flags = &h0
		left as Int32 //  LONG left;
		  top as Int32 //   LONG top;
		  right as Int32 //  LONG right;
		bottom as Int32 //  LONG bottom;
	#tag EndStructure


	#tag Enum, Name = WindowTabbingMode, Type = Integer, Flags = &h0
		Automatic = 0
		  Disallowed = 2
		Preferred  = 1
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
