#tag Module
Protected Module SemanticColors
	#tag Method, Flags = &h1
		Protected Function alternateSelectedControlColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.alternateSelectedControlColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c0850CF00
		      End If
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Declare Function alternateSelectedControlColor Lib "AppKit" Selector "alternateSelectedControlColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "alternateSelectedControlColor") Then
		          NSColorPtr = alternateSelectedControlColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      Else
		        // no semantic color on 10.14 and up
		        Return &c0850CF00
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    return GetWindowsSysColor(COLOR_BTNFACE)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function alternateSelectedControlTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.alternateSelectedControlTextColor.colorValue
		    #Else
		      
		      Declare Function alternateSelectedControlTextColor Lib "AppKit" Selector "alternateSelectedControlTextColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "alternateSelectedControlTextColor") Then
		        NSColorPtr = alternateSelectedControlTextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    return GetWindowsSysColor(COLOR_INACTIVECAPTION)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function alternatingEvenContentBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFFFEFE00
		      Else
		        // semantic color on 10.14 and up
		        Dim colors() As NSColorMBS = NSColorMBS.alternatingContentBackgroundColors
		        
		        Return colors(0).colorValue
		      End If
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFFFEFE00
		        
		      Else
		        Declare Function alternatingContentBackgroundColors Lib "AppKit" Selector "alternatingContentBackgroundColors" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        // Dim NSColorPtr As Ptr
		        
		        Break
		        
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &cFFFEFE00
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function alternatingOddContentBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFFFEFE00
		      Else
		        // semantic color on 10.14 and up
		        Dim colors() As NSColorMBS = NSColorMBS.alternatingContentBackgroundColors
		        
		        Return colors(1).colorValue
		      End If
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFFFEFE00
		        
		      Else
		        Declare Function alternatingContentBackgroundColors Lib "AppKit" Selector "alternatingContentBackgroundColors" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        // Dim NSColorPtr As Ptr
		        
		        Break
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &cFFFEFE00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ColorByName(name as string) As Color
		  Select Case name
		    
		  Case "alternateSelectedControlColor"
		    Return alternateSelectedControlColor
		    
		  Case "alternateSelectedControlTextColor"
		    Return alternateSelectedControlTextColor
		    
		  Case "alternatingEvenContentBackgroundColor"
		    Return alternatingEvenContentBackgroundColor
		    
		  Case "alternatingOddContentBackgroundColor"
		    Return alternatingOddContentBackgroundColor
		    
		  Case "controlAccentColor"
		    Return controlAccentColor
		    
		  Case "controlAccentColor"
		    Return controlAccentColor
		    
		  Case "controlBackgroundColor"
		    Return controlBackgroundColor
		    
		  Case "controlColor"
		    Return controlColor
		    
		  Case "controlDarkShadowColor"
		    Return controlDarkShadowColor
		    
		  Case "controlHighlightColor"
		    Return controlHighlightColor
		    
		  Case "controlLightHighlightColor"
		    Return controlLightHighlightColor
		    
		  Case "controlShadowColor"
		    Return controlShadowColor
		    
		  Case "controlTextColor"
		    Return controlTextColor
		    
		  Case "disabledControlTextColor"
		    Return disabledControlTextColor
		    
		  Case "findHighlightColor"
		    Return findHighlightColor
		    
		  Case "gridColor"
		    Return gridColor
		    
		  Case "headerColor"
		    Return headerColor
		    
		  Case "headerTextColor"
		    Return headerTextColor
		    
		  Case "highlightColor"
		    Return HighlightColor
		    
		  Case "keyboardFocusIndicatorColor"
		    Return keyboardFocusIndicatorColor
		    
		  Case "knobColor"
		    Return knobColor
		    
		  Case "labelColor"
		    Return labelColor
		    
		  Case "linkColor"
		    Return linkColor
		    
		  Case "placeHolderTextColor"
		    Return placeHolderTextColor
		    
		  Case "quaternaryLabelColor"
		    Return quaternaryLabelColor
		    
		  Case "scrollBarColor"
		    Return scrollBarColor
		    
		  Case "secondaryLabelColor"
		    Return secondaryLabelColor
		    
		  Case "secondarySelectedControlColor"
		    Return secondarySelectedControlColor
		    
		  Case "selectedContentBackgroundColor"
		    Return selectedContentBackgroundColor
		    
		  Case "selectedControlColor"
		    Return selectedControlColor
		    
		  Case "selectedControlTextColor"
		    Return selectedControlTextColor
		    
		  Case "selectedKnobColor"
		    Return selectedKnobColor
		    
		  Case "selectedMenuItemColor"
		    Return selectedMenuItemColor
		    
		  Case "selectedMenuItemTextColor"
		    Return selectedMenuItemTextColor
		    
		  Case "selectedTextBackgroundColor"
		    Return selectedTextBackgroundColor
		    
		  Case "selectedTextColor"
		    Return selectedTextColor
		    
		  Case "separatorColor"
		    Return separatorColor
		    
		  Case "shadowColor"
		    Return shadowColor
		    
		  Case "systemBlueColor"
		    Return systemBlueColor
		    
		  Case "systemBrownColor"
		    Return systemBrownColor
		    
		  Case "systemGrayColor"
		    Return systemGrayColor
		    
		  Case "systemGreenColor"
		    Return systemGreenColor
		    
		  Case "systemOrangeColor"
		    Return systemOrangeColor
		    
		  Case "systemPinkColor"
		    Return systemPinkColor
		    
		  Case "systemPurpleColor"
		    Return systemPurpleColor
		    
		  Case "systemRedColor"
		    Return systemRedColor
		    
		  Case "systemYellowColor"
		    Return systemYellowColor
		    
		  Case "tertiaryLabelColor"
		    Return tertiaryLabelColor
		    
		  Case "textBackgroundColor"
		    Return textBackgroundColor
		    
		  Case "textColor"
		    Return TextColor
		    
		  Case "underPageBackgroundColor"
		    Return underPageBackgroundColor
		    
		  Case "unemphasizedSelectedContentBackgroundColor"
		    Return unemphasizedSelectedContentBackgroundColor
		    
		  Case "unemphasizedSelectedTextBackgroundColor"
		    Return unemphasizedSelectedTextBackgroundColor
		    
		  Case "unemphasizedSelectedTextColor"
		    Return unemphasizedSelectedTextColor
		    
		  Case "windowBackgroundColor"
		    Return windowBackgroundColor
		    
		  Case "windowFrameColor"
		    Return windowFrameColor
		    
		  Case "windowFrameTextColor"
		    Return windowFrameTextColor
		    
		  Else
		    Break
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function controlAccentColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return REALbasic.HighlightColor
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.controlAccentColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return REALbasic.HighlightColor
		      Else
		        
		        Declare Function controlAccentColor Lib "AppKit" Selector "controlAccentColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "controlAccentColor") Then
		          NSColorPtr = controlAccentColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_CAPTIONTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function controlBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.controlBackgroundColor.colorValue
		      
		    #Else
		      Declare Function controlBackgroundColor Lib "AppKit" Selector "controlBackgroundColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "controlBackgroundColor") Then
		        NSColorPtr = controlBackgroundColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_BTNFACE)
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function controlColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.controlColor.colorValue
		      
		    #Else
		      
		      Declare Function controlColor Lib "AppKit" Selector "controlColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "controlColor") Then
		        NSColorPtr = controlColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_BTNFACE)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function controlDarkShadowColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.controlDarkShadowColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c00000000
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Break
		      Else
		        // no semantic color on 10.14 and up
		        Return &c00000000
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_BTNSHADOW)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function controlHighlightColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.controlHighlightColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &cE2E2E200
		      End If
		      
		    #Else
		      
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Break
		      Else
		        // no semantic color on 10.14 and up
		        Return &cE2E2E200
		      End If
		      
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_HIGHLIGHTTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function controlLightHighlightColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.controlLightHighlightColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &cFFFFFF00
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Break
		      Else
		        // no semantic color on 10.14 and up
		        Return &cFFFFFF00
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_3DLIGHT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function controlShadowColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.controlShadowColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c8D8D8D00
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Break
		      Else
		        // no semantic color on 10.14 and up
		        Return &c8D8D8D00
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_3DSHADOW)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function controlTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.controlTextColor.colorValue
		      
		    #Else
		      Declare Function controlTextColor Lib "AppKit" Selector "controlTextColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "controlTextColor") Then
		        NSColorPtr = controlTextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_CAPTIONTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function disabledControlTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.disabledControlTextColor.colorValue
		      
		    #Else
		      
		      Declare Function disabledControlTextColor Lib "AppKit" Selector "disabledControlTextColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "disabledControlTextColor") Then
		        NSColorPtr = disabledControlTextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_INACTIVECAPTIONTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function findHighlightColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFFFF0A00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.findHighlightColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFFFF0A00
		      Else
		        Declare Function findHighlightColor Lib "AppKit" Selector "findHighlightColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "findHighlightColor") Then
		          NSColorPtr = findHighlightColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		        
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_HIGHLIGHT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetNSArrayObj(obj As ptr, zeroBasedIndex As Integer) As Ptr
		  // don't set the ptr as we want to return a nil ptr if it is an array but the request is out of bounds
		  Dim rv As ptr
		  #If TargetMacOS
		    Declare Function NSArrayCount Lib "Foundation" selector "count" (obj As Ptr) As Integer
		    Declare Function NSArrayObjectAtIndex Lib "Foundation" selector "objectAtIndex:" (obj As Ptr, zeroBasedIndex As Integer) As Ptr
		    If RespondsToSelector(obj, "count") Then
		      Dim c As Integer = NSArrayCount(obj)
		      If c>0 Then
		        rv = NSArrayObjectAtIndex(obj,zeroBasedIndex)
		      End If
		    Else
		      rv = obj
		    End If
		  #EndIf
		  
		  Return rv
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetWindowsSysColor(colorID as integer) As Color
		  #Pragma unused colorID 
		  // DWORD GetSysColor(int nIndex);
		  // 
		  // Value               Meaning  
		  // COLOR_3DDKSHADOW    21        Dark shadow For three-dimensional display elements.
		  // COLOR_3DFACE     15 Face Color For three-dimensional display elements And For dialog box backgrounds.
		  // COLOR_3DHIGHLIGHT 20 Highlight Color For three-dimensional display elements (For edges facing the light source.)
		  // COLOR_3DHILIGHT 20 Highlight Color For three-dimensional display elements (For edges facing the light source.)
		  // COLOR_3DLIGHT 22 Light Color For three-dimensional display elements (For edges facing the light source.)
		  // COLOR_3DSHADOW 16 Shadow Color For three-dimensional display elements (For edges facing away from the light source).
		  // COLOR_ACTIVEBORDER 10 Active Window border.
		  
		  // COLOR_ACTIVECAPTION 2 Active Window title bar. The associated foreground Color Is COLOR_CAPTIONTEXT.
		  // Specifies the Left side Color In the Color gradient Of an active Window's title bar if the gradient effect is enabled.
		  // 
		  // COLOR_APPWORKSPACE 12 Background Color Of multiple document Interface (MDI) applications.
		  // COLOR_BACKGROUND 1 Desktop.
		  // COLOR_BTNFACE 15 Face Color For three-dimensional display elements And For dialog box backgrounds. The associated foreground Color Is COLOR_BTNTEXT.
		  // COLOR_BTNHIGHLIGHT 20 Highlight Color For three-dimensional display elements (For edges facing the light source.)
		  // COLOR_BTNHILIGHT 20 Highlight Color For three-dimensional display elements (For edges facing the light source.)
		  // COLOR_BTNSHADOW 16 Shadow Color For three-dimensional display elements (For edges facing away from the light source).
		  // COLOR_BTNTEXT 18 Text on push buttons. The associated background Color Is COLOR_BTNFACE.
		  // COLOR_CAPTIONTEXT 9 Text In caption, size box, And scroll bar arrow box. The associated background Color Is COLOR_ACTIVECAPTION.
		  // COLOR_DESKTOP 1 Desktop.
		  // COLOR_GRADIENTACTIVECAPTION 27 Right side Color In the Color gradient Of an active Window's title bar. COLOR_ACTIVECAPTION specifies the left side color. Use SPI_GETGRADIENTCAPTIONS with the SystemParametersInfo function to determine whether the gradient effect is enabled.
		  // COLOR_GRADIENTINACTIVECAPTION 28 Right side Color In the Color gradient Of an inactive Window's title bar. COLOR_INACTIVECAPTION specifies the left side color.
		  // COLOR_GRAYTEXT 17 Grayed (disabled) Text. This Color Is set To 0 If the current display driver does Not support a solid gray Color.
		  // COLOR_HIGHLIGHT 13 Item(s) selected In a control. The associated foreground Color Is COLOR_HIGHLIGHTTEXT.
		  // COLOR_HIGHLIGHTTEXT 14 Text Of item(s) selected In a control. The associated background Color Is COLOR_HIGHLIGHT.
		  // COLOR_HOTLIGHT 26 Color For a hyperlink Or hot-tracked item. The associated background Color Is COLOR_WINDOW.
		  // COLOR_INACTIVEBORDER 11 Inactive Window border.
		  
		  // COLOR_INACTIVECAPTION 3 Inactive Window caption. The associated foreground Color Is COLOR_INACTIVECAPTIONTEXT.
		  // Specifies the Left side Color In the Color gradient Of an inactive Window's title bar if the gradient effect is enabled.
		  // 
		  // COLOR_INACTIVECAPTIONTEXT 19 Color Of Text In an inactive caption. The associated background Color Is COLOR_INACTIVECAPTION.
		  // COLOR_INFOBK 24 Background Color For tooltip controls. The associated foreground Color Is COLOR_INFOTEXT.
		  // COLOR_INFOTEXT 23 Text Color For tooltip controls. The associated background Color Is COLOR_INFOBK.
		  // COLOR_MENU 4 Menu background. The associated foreground Color Is COLOR_MENUTEXT.
		  
		  // COLOR_MENUHILIGHT 29 The Color used To highlight menu items when the menu appears As a flat menu (see SystemParametersInfo). The highlighted menu item Is outlined With COLOR_HIGHLIGHT.
		  // Windows 2000:  This value Is Not supported.
		  // 
		  // COLOR_MENUBAR 30 The background Color For the menu bar when menus appear As flat menus (see SystemParametersInfo). However, COLOR_MENU continues To specify the background Color Of the menu popup.
		  // Windows 2000:  This value Is Not supported.
		  // 
		  // COLOR_MENUTEXT 7 Text In menus. The associated background Color Is COLOR_MENU.
		  // COLOR_SCROLLBAR 0 Scroll bar gray area.
		  // COLOR_WINDOW 5 Window background. The associated foreground colors are COLOR_WINDOWTEXT And COLOR_HOTLITE.
		  // COLOR_WINDOWFRAME 6 Window frame.
		  // COLOR_WINDOWTEXT 8 Text In windows. The associated background Color Is COLOR_WINDOW.
		  
		  #If TargetWindows
		    Soft Declare Function GetSysColor Lib "User32" (nIndex As Int32) As UInt32
		    
		    Return Color( GetSysColor(colorID) )
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function gridColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.gridColor.colorValue
		      
		    #Else
		      Declare Function gridColor Lib "AppKit" Selector "gridColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "gridColor") Then
		        NSColorPtr = gridColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_ACTIVEBORDER)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function headerColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.headerColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c99999900
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        
		        Declare Function headerColor Lib "AppKit" Selector "headerColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "headerColor") Then
		          NSColorPtr = headerColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		        
		      Else
		        // no semantic color on 10.14 and up
		        Return &c99999900
		      End If
		      
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_ACTIVECAPTION)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function headerTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.headerTextColor.colorValue
		      
		    #Else
		      Declare Function headerTextColor Lib "AppKit" Selector "headerTextColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "headerTextColor") Then
		        NSColorPtr = headerTextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_CAPTIONTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function highlightColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.HighlightColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &cFFFFFF00
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        
		        Declare Function highlightColor Lib "AppKit" Selector "highlightColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "highlightColor") Then
		          NSColorPtr = HighlightColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      Else
		        // no semantic color on 10.14 and up
		        Return &cFFFFFF00
		      End If
		      
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_HIGHLIGHT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitNSColorClass()
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" ( name As CFStringRef ) As Ptr
		    
		    If NSColorClass = Nil Then
		      NSColorClass = NSClassFromString("NSColor")
		    End If
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function keyboardFocusIndicatorColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.keyboardFocusIndicatorColor.colorValue
		      
		    #Else
		      Declare Function keyboardFocusIndicatorColor Lib "AppKit" Selector "keyboardFocusIndicatorColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "keyboardFocusIndicatorColor") Then
		        NSColorPtr = keyboardFocusIndicatorColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_ACTIVEBORDER)
		  #EndIf
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function knobColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.knobColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c8685AC00
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        break
		      Else
		        // no semantic color on 10.14 and up
		        Return &c8685AC00
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &c8685AC00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function labelColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.labelColor.colorValue
		      
		    #Else
		      Declare Function labelColor Lib "AppKit" Selector "labelColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "labelColor") Then
		        NSColorPtr = labelColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		      
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_BTNFACE)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function linkColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c3486FE00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.linkColor.colorValue
		      End If
		      
		    #Else
		      
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c3486FE00
		      Else
		        Declare Function linkColor Lib "AppKit" Selector "linkColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "linkColor") Then
		          NSColorPtr = linkColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_HOTLIGHT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MacMajorVersion() As integer
		  #If targetMacOS
		    Dim rValue As OSVersionInfo 
		    
		    rValue = MacOSVersionInfo
		    
		    Return rValue.major
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MacMinorVersion() As Integer
		  #If targetMacOS
		    Dim rValue As OSVersionInfo 
		    
		    rValue = MacOSVersionInfo
		    
		    Return rValue.minor
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MacOSVersionInfo() As OSVersionInfo
		  #If targetMacOS
		    Static rvalue As OSVersionInfo
		    Static inited As Boolean
		    
		    If inited Then 
		      Return rvalue
		    End If
		    
		    Declare Function NSClassFromString Lib "AppKit" ( className As CFStringRef ) As Ptr
		    Declare Function processInfo Lib "AppKit" selector "processInfo" ( ClassRef As Ptr ) As Ptr
		    Dim myInfo As Ptr = processInfo( NSClassFromString( "NSProcessInfo" ) )
		    Declare Function operatingSystemVersion Lib "AppKit" selector "operatingSystemVersion" ( NSProcessInfo As Ptr ) As OSVersionInfo
		    rvalue = operatingSystemVersion( myInfo )
		    
		    inited = True
		    
		    Return rValue
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NSColorToColor(theColor As Ptr) As Color
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" ( name As CFStringRef ) As Ptr
		    Declare Function NSColorType Lib "AppKit" Selector "type" (obj As Ptr) As Integer
		    Declare Function ColorUsingType Lib "AppKit" Selector "colorUsingType:" (obj As Ptr, colorType As Integer) As Ptr
		    If theColor = Nil Then
		      Return &cFF0000
		    End If
		    
		    // If the color is still an array when we get here
		    // return the first element
		    If NSIsKindOfClass(theColor, "NSArray") Then
		      theColor = GetNSArrayObj(theColor, 0)
		    End If
		    
		    // Get the passed color type
		    Dim ColorType As Integer = 0
		    If RespondsToSelector(theColor, "type") Then
		      ColorType = NSColorType(theColor)
		    End If
		    
		    // If the color is a pattern or a color asset (and we're using 10.13+) try to convert the color to a component-based color (RGB)
		    If ColorType > 0 And RespondsToSelector(theColor, "colorUsingType:") Then
		      Dim tmp As ptr = ColorUsingType(theColor, 0)
		      If tmp <> Nil Then
		        theColor = tmp
		        // Check the color type again
		        ColorType = NSColorType(theColor)
		      End If
		    End If
		    
		    // If it's a component-based color at this point, convert to the GenericRGBColorSpace
		    Dim convertedColor As Ptr
		    If ColorType = 0 Then
		      // Try converting to the generic rgb color space
		      // Need to convert using the user's colorspace
		      // First get the device colorspace  
		      Declare Function genericRGBColorSpace Lib "AppKit" selector "genericRGBColorSpace" (obj As Ptr) As Ptr
		      // https://developer.apple.com/documentation/appkit/nscolor/1527379-colorusingcolorspace?language=objc
		      Declare Function colorUsingColorSpace Lib "AppKit.framework" selector "colorUsingColorSpace:"  (colorObj As Ptr, colorspace As Ptr) As Ptr
		      Static ColorSpace As Ptr = genericRGBColorSpace(NSClassFromString("NSColorSpace"))
		      
		      // If converting fails, colorUsingColorSpace will return a null ptr here
		      If respondsToSelector(theColor, "colorUsingColorSpace:") Then
		        convertedColor = colorUsingColorSpace(theColor, ColorSpace)
		      End If
		    End If
		    
		    // If the convertedcolor is nil draw it to a picture and pull the color
		    If convertedColor = Nil Then
		      Break
		      // Declare Sub NSColorSet Lib "AppKit" selector "set" (obj As ptr)
		      // Declare Sub NSRectFill Lib "AppKit" (rect As NSRect)
		      // Declare Function NSClassFromString Lib "Foundation" ( className As CFStringRef ) As Ptr
		      // Declare Sub restoreGraphicsState Lib "AppKit" selector "restoreGraphicsState" ( classRef As Ptr )
		      // 
		      // Static p As New picture( 10, 10 )
		      // Dim r As NSRect
		      // r.origin.x = 0
		      // r.origin.y = 0
		      // r.Dimensions.width = p.Width
		      // r.Dimensions.height = p.Height
		      // 
		      // Dim locked As Boolean = p.graphics.beginNSDrawing
		      // NSColorSet theColor
		      // NSRectFill r
		      // If locked Then restoreGraphicsState( NSClassFromString( "NSGraphicsContext" ) )
		      // 
		      // // Pull the sample from the middle of the picture in case there are borders being drawn
		      // Return p.rgbSurface.pixel( 5, 5)
		    End If
		    
		    // Otherwise, grab its red, green, blue and alpha component
		    Declare Function redComponent Lib "AppKit" Selector "redComponent" (obj As Ptr) As Double
		    Declare Function greenComponent Lib "AppKit" Selector "greenComponent" (obj As Ptr) As Double
		    Declare Function blueComponent Lib "AppKit" Selector "blueComponent" (obj As Ptr) As Double
		    Declare Function alphaComponent Lib "AppKit" Selector "alphaComponent" (obj As Ptr) As Double
		    Try
		      Dim red As Double = redComponent(convertedColor) * 255.0
		      Dim green As Double = greenComponent(convertedColor) * 255.0
		      Dim blue As Double = blueComponent(convertedColor) * 255.0
		      Dim Alpha As Double = (1-alphaComponent(convertedColor)) * 255.0
		      
		      Return RGB(red, green, blue, alpha)
		    Catch ex As RuntimeException
		      
		    End Try
		  #Else
		    
		  #EndIf
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NSIsKindOfClass(obj As Ptr, ClassName As String) As Boolean
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" ( name As CFStringRef ) As Ptr
		    Declare Function isKindOfClass Lib "Cocoa" selector "isKindOfClass:" (obj As ptr, classtype As ptr) As Boolean
		    
		    Return isKindOfClass(obj, NSClassFromString(classname))
		  #EndIf
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function placeHolderTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFFFEFE00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.placeHolderTextColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFFFEFE00
		      Else
		        
		        Declare Function placeholderTextColor Lib "AppKit" Selector "placeholderTextColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "placeholderTextColor") Then
		          NSColorPtr = placeholderTextColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_GRAYTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function quaternaryLabelColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.quaternaryLabelColor.colorValue
		      
		    #Else
		      Declare Function quaternaryLabelColor Lib "AppKit" Selector "quaternaryLabelColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "quaternaryLabelColor") Then
		        NSColorPtr = quaternaryLabelColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    
		    return &cC0C0C000
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RespondsToSelector(obj As ptr, selector As String) As Boolean
		  
		  #If TargetMacOS
		    Declare Function sel_registerName Lib "/usr/lib/libobjc.dylib" (Name As CString) As Ptr
		    Declare Function RespondsToSelector Lib "Cocoa.framework" Selector "respondsToSelector:" (Target As Ptr, Sel As Ptr) As Boolean
		    
		    Dim sel As CString = selector
		    
		    Return RespondsToSelector(obj, sel_registerName(sel))
		  #EndIf
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function scrollBarColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.scrollBarColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c99999900
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        
		        Break
		      Else
		        // no semantic color on 10.14 and up
		        Return &c99999900
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_SCROLLBAR)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function secondaryLabelColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      
		      Return NSColorMBS.secondaryLabelColor.colorValue
		      
		      
		    #Else
		      Declare Function secondaryLabelColor Lib "AppKit" Selector "secondaryLabelColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "secondaryLabelColor") Then
		        NSColorPtr = secondaryLabelColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    
		    Return &c60606000
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function secondarySelectedControlColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.secondarySelectedControlColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &cCACACA00
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        
		        Declare Function secondarySelectedControlColor Lib "AppKit" Selector "secondarySelectedControlColor" ( obj As Ptr ) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "secondarySelectedControlColor") Then
		          NSColorPtr = secondarySelectedControlColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      Else
		        // no semantic color on 10.14 and up
		        Return &cCACACA00
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Break
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function selectedContentBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c053FC500
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.selectedContentBackgroundColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c053FC500
		      Else
		        Declare Function selectedContentBackgroundColor Lib "AppKit" Selector "selectedContentBackgroundColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "selectedContentBackgroundColor") Then
		          NSColorPtr = selectedContentBackgroundColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Break
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function selectedControlColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.selectedControlColor.colorValue
		      
		    #Else
		      Declare Function selectedControlColor Lib "AppKit" Selector "selectedControlColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "selectedControlColor") Then
		        NSColorPtr = selectedControlColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_ACTIVECAPTION)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function selectedControlTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.selectedControlTextColor.colorValue
		      
		    #Else
		      Declare Function selectedControlTextColor Lib "AppKit" Selector "selectedControlTextColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "selectedControlTextColor") Then
		        NSColorPtr = selectedControlTextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_CAPTIONTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function selectedKnobColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.selectedKnobColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c52508600
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Break
		      Else
		        // no semantic color on 10.14 and up
		        Return &c52508600
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Break
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function selectedMenuItemColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.selectedMenuItemColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c335DF100
		      End If
		      
		    #Else    
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        
		        Declare Function selectedMenuItemColor Lib "AppKit" Selector "selectedMenuItemColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "selectedMenuItemColor") Then
		          NSColorPtr = selectedMenuItemColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      Else
		        // no semantic color on 10.14 and up
		        Return &c335DF100
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_MENUHILIGHT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function selectedMenuItemTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.selectedMenuItemTextColor.colorValue
		      
		      
		    #Else
		      Declare Function selectedMenuItemTextColor Lib "AppKit" Selector "selectedMenuItemTextColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "selectedMenuItemTextColor") Then
		        NSColorPtr = selectedMenuItemTextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_MENUTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function selectedTextBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.selectedTextBackgroundColor.colorValue
		      
		      
		    #Else
		      Declare Function selectedTextBackgroundColor Lib "AppKit" Selector "selectedTextBackgroundColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "selectedTextBackgroundColor") Then
		        NSColorPtr = selectedTextBackgroundColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_BTNFACE)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function selectedTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.selectedTextColor.colorValue
		      
		      
		    #Else
		      Declare Function selectedTextColor Lib "AppKit" Selector "selectedTextColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "selectedTextColor") Then
		        NSColorPtr = selectedTextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_HIGHLIGHTTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function separatorColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFFFEFE00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.separatorColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return headerColor
		      Else
		        Declare Function separatorColor Lib "AppKit" Selector "separatorColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "separatorColor") Then
		          NSColorPtr = separatorColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_ACTIVEBORDER)
		  #EndIf
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function shadowColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.shadowColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c00000000
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        
		        Declare Function shadowColor Lib "AppKit" Selector "shadowColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "shadowColor") Then
		          NSColorPtr = shadowColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      Else
		        // no semantic color on 10.14 and up
		        Return &c00000000
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_3DSHADOW)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemBlueColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c106AFE00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemBlueColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c106AFE00
		      Else
		        Declare Function systemBlueColor Lib "AppKit" Selector "systemBlueColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemBlueColor") Then
		          NSColorPtr = systemBlueColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &c106AFE00
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemBrownColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c9B7B5500
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemBrownColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c9B7B5500
		      else
		        Declare Function systemBrownColor Lib "AppKit" Selector "systemBrownColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemBrownColor") Then
		          NSColorPtr = systemBrownColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &c9B7B5500
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemGrayColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c85858B00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemGrayColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c85858B00
		      Else
		        Declare Function systemGrayColor Lib "AppKit" Selector "systemGrayColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemGrayColor") Then
		          NSColorPtr = systemGrayColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &c85858B00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemGreenColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c30D33A00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemGreenColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c30D33A00
		      Else
		        
		        Declare Function systemGreenColor Lib "AppKit" Selector "systemGreenColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemGreenColor") Then
		          NSColorPtr = systemGreenColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &c30D33A00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemOrangeColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFC8D0D00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemOrangeColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFC8D0D00
		      Else
		        Declare Function systemOrangeColor Lib "AppKit" Selector "systemOrangeColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemOrangeColor") Then
		          NSColorPtr = systemOrangeColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &cFC8D0D00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemPinkColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFB194C00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemPinkColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFB194C00
		      Else
		        Declare Function systemPinkColor Lib "AppKit" Selector "systemPinkColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemPinkColor") Then
		          NSColorPtr = systemPinkColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &cFB194C00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemPurpleColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cAF38EE00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemPurpleColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cAF38EE00
		      Else
		        Declare Function systemPurpleColor Lib "AppKit" Selector "systemPurpleColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemPurpleColor") Then
		          NSColorPtr = systemPurpleColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &cAF38EE00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemRedColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFB2B2C00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemRedColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFB2B2C00
		      Else
		        Declare Function systemRedColor Lib "AppKit" Selector "systemRedColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemRedColor") Then
		          NSColorPtr = systemRedColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &cFB2B2C00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function systemYellowColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFECF0E00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.systemYellowColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFECF0E00
		      Else
		        Declare Function systemYellowColor Lib "AppKit" Selector "systemYellowColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "systemYellowColor") Then
		          NSColorPtr = systemYellowColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return &cFECF0E00
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function tertiaryLabelColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.tertiaryLabelColor.colorValue
		      
		      
		    #Else
		      Declare Function tertiaryLabelColor Lib "AppKit" Selector "tertiaryLabelColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "tertiaryLabelColor") Then
		        NSColorPtr = tertiaryLabelColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    
		    return &cFFFEFE00
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function textBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.textBackgroundColor.colorValue
		      
		      
		    #Else
		      Declare Function textBackgroundColor Lib "AppKit" Selector "textBackgroundColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "textBackgroundColor") Then
		        NSColorPtr = textBackgroundColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_ACTIVECAPTION)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function textColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.TextColor.colorValue
		      
		      
		    #Else
		      Declare Function textColor Lib "AppKit" Selector "textColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "textColor") Then
		        NSColorPtr = TextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_CAPTIONTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function underPageBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c1D1D1D00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.underPageBackgroundColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c1D1D1D00
		      Else
		        
		        Declare Function underPageBackgroundColor Lib "AppKit" Selector "underPageBackgroundColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "underPageBackgroundColor") Then
		          NSColorPtr = underPageBackgroundColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_BACKGROUND)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function unemphasizedSelectedContentBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c36363600
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.unemphasizedSelectedContentBackgroundColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c36363600
		      Else
		        Declare Function unemphasizedSelectedContentBackgroundColor Lib "AppKit" Selector "unemphasizedSelectedContentBackgroundColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "unemphasizedSelectedContentBackgroundColor") Then
		          NSColorPtr = unemphasizedSelectedContentBackgroundColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_INACTIVECAPTION)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function unemphasizedSelectedTextBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &c36363600
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.unemphasizedSelectedTextBackgroundColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &c36363600
		      Else
		        Declare Function unemphasizedSelectedTextBackgroundColor Lib "AppKit" Selector "unemphasizedSelectedTextBackgroundColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "unemphasizedSelectedTextBackgroundColor") Then
		          NSColorPtr = unemphasizedSelectedTextBackgroundColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_INACTIVECAPTION)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function unemphasizedSelectedTextColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return &cFFFFFF00
		      Else
		        // semantic color on 10.14 and up
		        Return NSColorMBS.unemphasizedSelectedTextColor.colorValue
		      End If
		      
		    #Else
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        Return &cFFFFFF00
		      Else
		        Declare Function unemphasizedSelectedTextColor Lib "AppKit" Selector "unemphasizedSelectedTextColor" (obj As Ptr) As Ptr
		        
		        InitNSColorClass
		        Dim NSColorPtr As Ptr
		        
		        If RespondsToSelector( NSColorClass, "unemphasizedSelectedTextColor") Then
		          NSColorPtr = unemphasizedSelectedTextColor(NSColorClass)
		        End If
		        
		        If NSColorPtr = Nil Then
		          Return &cFF0000
		        End If
		        
		        Return NSColorToColor(NSColorPtr)
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_INACTIVECAPTIONTEXT)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function windowBackgroundColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      Return NSColorMBS.windowBackgroundColor.colorValue
		      
		      
		    #Else
		      Declare Function windowBackgroundColor Lib "AppKit" Selector "windowBackgroundColor" (obj As Ptr) As ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "windowBackgroundColor") Then
		        NSColorPtr = windowBackgroundColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_WINDOW)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function windowFrameColor() As color
		  #If TargetMacOS
		    #If UseMBS 
		      If SystemInformationMBS.MacMajorVersion = 10 And 10 <= SystemInformationMBS.MacMinorVersion And SystemInformationMBS.MacMinorVersion < 14 Then
		        Return NSColorMBS.windowFrameColor.colorValue
		      Else
		        // no semantic color on 10.14 and up
		        Return &c99999900
		      End If
		      
		    #Else
		      
		      If MacMajorVersion = 10 And 10 <= MacMinorVersion And MacMinorVersion < 14 Then
		        break
		      Else
		        // no semantic color on 10.14 and up
		        Return &c99999900
		      End If
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_WINDOWFRAME)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function windowFrameTextColor() As color
		  #If TargetMacOS
		    
		    #If UseMBS 
		      Return NSColorMBS.windowFrameTextColor.colorValue
		      
		    #Else
		      Declare Function windowFrameTextColor Lib "AppKit" Selector "windowFrameTextColor" (obj As Ptr) As Ptr
		      
		      InitNSColorClass
		      Dim NSColorPtr As Ptr
		      
		      If RespondsToSelector( NSColorClass, "windowFrameTextColor") Then
		        NSColorPtr = windowFrameTextColor(NSColorClass)
		      End If
		      
		      If NSColorPtr = Nil Then
		        Return &cFF0000
		      End If
		      
		      Return NSColorToColor(NSColorPtr)
		    #EndIf
		  #ElseIf TargetWindows
		    Return GetWindowsSysColor(COLOR_WINDOWTEXT)
		  #EndIf
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private NSColorClass As Ptr
	#tag EndProperty


	#tag Constant, Name = COLOR_3DDKSHADOW, Type = Double, Dynamic = False, Default = \"21", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_3DFACE, Type = Double, Dynamic = False, Default = \"15", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_3DHIGHLIGHT, Type = Double, Dynamic = False, Default = \"20", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_3DHILIGHT, Type = Double, Dynamic = False, Default = \"20", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_3DLIGHT, Type = Double, Dynamic = False, Default = \"22", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_3DSHADOW, Type = Double, Dynamic = False, Default = \"16", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_ACTIVEBORDER, Type = Double, Dynamic = False, Default = \"10", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_ACTIVECAPTION, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_APPWORKSPACE, Type = Double, Dynamic = False, Default = \"12", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_BACKGROUND, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_BTNFACE, Type = Double, Dynamic = False, Default = \"15", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_BTNHIGHLIGHT, Type = Double, Dynamic = False, Default = \"20", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_BTNHILIGHT, Type = Double, Dynamic = False, Default = \"20", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_BTNSHADOW, Type = Double, Dynamic = False, Default = \"16", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_BTNTEXT, Type = Double, Dynamic = False, Default = \"18", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_CAPTIONTEXT, Type = Double, Dynamic = False, Default = \"9", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_DESKTOP, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_GRADIENTACTIVECAPTION, Type = Double, Dynamic = False, Default = \"27", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_GRADIENTINACTIVECAPTION, Type = Double, Dynamic = False, Default = \"28", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_GRAYTEXT, Type = Double, Dynamic = False, Default = \"17", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_HIGHLIGHT, Type = Double, Dynamic = False, Default = \"13", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_HIGHLIGHTTEXT, Type = Double, Dynamic = False, Default = \"14", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_HOTLIGHT, Type = Double, Dynamic = False, Default = \"26", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_INACTIVEBORDER, Type = Double, Dynamic = False, Default = \"11", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_INACTIVECAPTION, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_INACTIVECAPTIONTEXT, Type = Double, Dynamic = False, Default = \"19", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_INFOBK, Type = Double, Dynamic = False, Default = \"24", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_INFOTEXT, Type = Double, Dynamic = False, Default = \"23", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_MENU, Type = Double, Dynamic = False, Default = \"4", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_MENUBAR, Type = Double, Dynamic = False, Default = \"30", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_MENUHILIGHT, Type = Double, Dynamic = False, Default = \"29", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_MENUTEXT, Type = Double, Dynamic = False, Default = \"7", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_SCROLLBAR, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_WINDOW, Type = Double, Dynamic = False, Default = \"5", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_WINDOWFRAME, Type = Double, Dynamic = False, Default = \"6", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = COLOR_WINDOWTEXT, Type = Double, Dynamic = False, Default = \"8", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = UseMBS, Type = Boolean, Dynamic = False, Default = \"false", Scope = Public
	#tag EndConstant


	#tag Structure, Name = OSVersionInfo, Flags = &h1, Attributes = \"StructureAlignment \x3D 1"
		major as integer
		  minor as integer
		bug as integer
	#tag EndStructure


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
