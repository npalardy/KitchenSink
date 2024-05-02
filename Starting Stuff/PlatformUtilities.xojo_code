#tag Module
Protected Module PlatformUtilities
	#tag Method, Flags = &h1
		Protected Sub BeginActivity(reason as string)
		  #If targetMacOS
		    
		    Declare Function NSClassFromString Lib "Foundation" ( name As CFStringRef ) As Integer
		    Declare Function retain Lib "Foundation" Selector "retain" ( obj As Integer ) As Integer
		    Declare Sub release Lib "Foundation" Selector "release" ( obj As Integer )
		    
		    // NSProcessInfo
		    Declare Function processInfo Lib "Foundation" Selector "processInfo" ( obj As Integer ) As Integer
		    Declare Function beginActivity Lib "Foundation" Selector "beginActivityWithOptions:reason:" ( obj As Integer, options As UInt64, reason As CFStringRef )  As Integer
		    Const NSActivityUserInitiated = &hFFFFFF
		    
		    If m_MacAppNapToken <> 0 Then
		      Exit Sub
		    End If
		    
		    Dim NSProcessInfo As Integer = NSClassFromString( "NSProcessInfo" )
		    Dim token As Integer = beginActivity( processInfo( NSProcessInfo ), NSActivityUserInitiated, reason )
		    m_MacAppNapToken = retain( token )
		    
		  #EndIf
		  
		  #If TargetWindows
		    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setthreadexecutionstate
		    // Value    Meaning
		    // ES_AWAYMODE_REQUIRED
		    // 0x00000040
		    // Enables away mode. This value must be specified With ES_CONTINUOUS.
		    // Away mode should be used only by media-recording And media-distribution applications that must perform critical background processing on desktop computers While the computer appears To be sleeping. See Remarks.
		    // ES_CONTINUOUS
		    // 0x80000000
		    // Informs the System that the state being set should remain In effect Until the Next Call that uses ES_CONTINUOUS And one Of the other state flags Is cleared.
		    // ES_DISPLAY_REQUIRED
		    // 0x00000002
		    // Forces the display To be on by resetting the display idle timer.
		    // ES_SYSTEM_REQUIRED
		    // 0x00000001
		    // Forces the System To be In the working state by resetting the System idle timer.
		    // ES_USER_PRESENT
		    // 0x00000004
		    // This value is not supported. If ES_USER_PRESENT is combined with other esFlags values, the call will fail and none of the specified states will be set.
		    
		    // according to https://blog.samphire.net/2017/01/22/windows-to-xojo-data-type-conversion/
		    // EXECUTION_STATE    UInt32    name As UInt32
		    
		    // EXECUTION_STATE SetThreadExecutionState([in] EXECUTION_STATE esFlags);
		    // If the Function succeeds, the Return value Is the previous thread execution state.
		    // If the Function fails, the Return value Is NULL.
		    
		    // since we dont maintain a stack of previous states we should only set this once
		    If m_Windows_previous_thread_state <> 0 Then
		      Exit Sub
		    End If
		    
		    Const ES_AWAYMODE_REQUIRED = &h00000040
		    Const ES_CONTINUOUS = &h80000000
		    Const ES_DISPLAY_REQUIRED = &h00000002
		    Const ES_SYSTEM_REQUIRED = &h00000001
		    Const ES_USER_PRESENT = &h00000004
		    
		    Soft Declare Function SetThreadExecutionState Lib "Kernel32.dll" ( new_state As UInt32 ) As UInt32
		    
		    m_Windows_previous_thread_state = SetThreadExecutionState( ES_CONTINUOUS + ES_SYSTEM_REQUIRED + ES_AWAYMODE_REQUIRED )
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub CloseNSColorPanel()
		  
		  #If TargetMacOS Then
		    Declare Function NSClassFromString Lib "AppKit" ( className As CFStringRef ) As ptr
		    Declare Function sharedColorPanel Lib "AppKit" selector "sharedColorPanel" ( classRef As Ptr ) As Ptr
		    Declare Sub close Lib "AppKit" selector "close" ( panel As Ptr )
		    close( sharedColorPanel( NSClassFromString( "NSColorPanel" ) ) ) 
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CPUType() As string
		  Initialize
		  
		  Return m_cputype
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DoubleClickInterval() As Double
		  // returns as double that is the # of TICKS
		  
		  #If TargetMacOS
		    
		    Const CocoaLib As String = "Cocoa.framework"
		    Declare Function NSClassFromString Lib CocoaLib(aClassName As CFStringRef) As ptr
		    Declare Function doubleClickInterval Lib CocoaLib selector "doubleClickInterval" (aClass As ptr) As Double
		    
		    Try
		      dim RefToClass as Ptr = NSClassFromString("NSEvent")
		      Return doubleClickInterval(RefToClass) * 60
		    Catch err As ObjCException
		      Break
		      #If debugbuild
		        MsgBox err.message
		      #EndIf
		    End
		  #EndIf
		  
		  #If TargetWin32
		    Declare Function GetDoubleClickTime Lib "User32.DLL" () As Integer
		    Try
		      Return GetDoubleClickTime
		    Catch err As ObjCException
		      Break
		      #If debugbuild
		        MsgBox err.message
		      #EndIf
		    End
		  #EndIf
		  
		  Break
		  #If debugbuild
		    MsgBox CurrentMethodName + " Unhandled case"
		  #EndIf
		  Return 0
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub EndActivity()
		  #If targetMacOS
		    
		    // Ends the activity previously started with MacAppNapBeginActivity. This allows
		    // the process to be put back under App Nap.
		    Declare Function NSClassFromString Lib "Foundation" ( name As CFStringRef ) As Integer
		    Declare Function retain Lib "Foundation" Selector "retain" ( obj As Integer ) As Integer
		    Declare Sub release Lib "Foundation" Selector "release" ( obj As Integer )
		    
		    // NSProcessInfo
		    Declare Function processInfo Lib "Foundation" Selector "processInfo" ( obj As Integer ) As Integer
		    Declare Function beginActivity Lib "Foundation" Selector "beginActivityWithOptions:reason:" ( obj As Integer, options As UInt64, reason As CFStringRef )  As Integer
		    Declare Sub endActivity Lib "Foundation" Selector "endActivity:" ( obj As Integer, token As Integer )
		    
		    
		    If m_MacAppNapToken = 0 Then
		      Exit Sub
		    End If
		    
		    Dim NSProcessInfo As Integer = NSClassFromString( "NSProcessInfo" )
		    endActivity( processInfo( NSProcessInfo ), m_MacAppNapToken )
		    release( m_MacAppNapToken )
		    m_MacAppNapToken = 0
		  #EndIf
		  
		  #If TargetWindows
		    
		    // since we dont maintain a stack of previous states we should only set this once
		    If m_Windows_previous_thread_state = 0 Then
		      Exit Sub
		    End If
		    
		    Soft Declare Function SetThreadExecutionState Lib "Kernel32.dll" ( new_state As UInt32 ) As UInt32
		    
		    m_Windows_previous_thread_state = SetThreadExecutionState( m_Windows_previous_thread_state )
		    m_Windows_previous_thread_state = 0
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function get_errno() As Integer
		  // From Andrew Lambert
		  // https://forum.xojo.com/t/accessing-errno-generated-by-an-external-c-library/75151/7
		  
		  Dim err As Integer
		  Dim mb As MemoryBlock
		  
		  #If TargetWin32 Then
		    Declare Function _get_errno Lib "msvcrt" (ByRef Error As Integer) As Integer
		    Dim e As Integer = _get_errno(err)
		    If e <> 0 Then 
		      err = e
		    End If
		  #ElseIf TargetLinux
		    Declare Function __errno_location Lib "libc.so" () As Ptr
		    mb = __errno_location()
		  #ElseIf TargetMacOS
		    Declare Function __error Lib "System" () As Ptr
		    mb = __error()
		  #EndIf
		  If mb <> Nil Then 
		    err = mb.Int32Value(0)
		  End If
		  
		  Return err
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HIBYTE(wValue as Uint16) As Uint8
		  return bitwise.shiftright(wvalue and &hFF00,8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Initialize()
		  If m_Initialized Then 
		    Return
		  End If
		  
		  m_Initialized = True
		  
		  #If TargetMacOS
		    
		    // --- We're using 10.10
		    Declare Function NSClassFromString Lib "AppKit" ( className As CFStringRef ) As Ptr
		    Declare Function processInfo Lib "AppKit" Selector "processInfo" ( ClassRef As Ptr ) As Ptr
		    Dim myInfo As Ptr = processInfo( NSClassFromString( "NSProcessInfo" ) )
		    Declare Function operatingSystemVersion Lib "AppKit" Selector "operatingSystemVersion" ( NSProcessInfo As Ptr ) As OSVersionInfo
		    Dim rvalue As OSVersionInfo = operatingSystemVersion( myInfo )
		    
		    m_MajorVersion = rValue.major
		    m_MinorVersion = rvalue.minor
		    m_Bug = rvalue.bug
		    
		    // Dim s As New shell
		    // s.execute("`which sysctl` kern.osversion")
		    // Dim tmp As String = s.result
		    // 
		    // If tmp.BeginsWith("kern.osversion:") Then
		    // m_build = Trim( tmp.ReplaceAll("kern.osversion:", "" ) )
		    // End If
		    
		    Declare Function sysctlbyname Lib "/usr/lib/libSystem.dylib" (name As cString, out As ptr, ByRef size As UInteger, newP As ptr, newPSize As UInteger) As Integer
		    
		    Dim size As UInteger = 128
		    Dim mb As New memoryblock(size)
		    
		    If sysctlbyname( "kern.osversion", mb, size, Nil, 0 ) = 0 Then
		      m_build = Trim(mb.CString(0))
		    End If
		    
		    size = 256
		    mb = New memoryblock(size)
		    Dim retvalue As Integer = sysctlbyname( "machdep.cpu.brand_string", mb, size, Nil, 0 )
		    If sysctlbyname( "machdep.cpu.brand_string", mb, size, Nil, 0 ) = 0 Then
		      m_cputype = Trim(mb.CString(0))
		    End If
		    
		  #ElseIf TargetWindows
		    
		    Dim m As MemoryBlock
		    Dim wsuitemask As Integer
		    Dim ret As Integer
		    Dim szCSDVersion As String
		    Dim s As String
		    
		    Soft Declare Function GetVersionExA Lib "kernel32" (lpVersionInformation As ptr) As Integer
		    Soft Declare Function GetVersionExW Lib "kernel32" (lpVersionInformation As ptr) As Integer
		    
		    Dim retryUsingAVersion As Boolean = True
		    
		    If System.IsFunctionAvailable( "GetVersionExW", "Kernel32" ) Then
		      
		      retryUsingAVersion = False
		      
		      m = NewMemoryBlock(284) ''use this for osversioninfoex structure (2000+ only)
		      m.long(0) = m.size 'must set size before calling getversionex 
		      ret = GetVersionExW(m) 'if not 2000+, will return 0
		      
		      If ret = 0 Then
		        // need to rety since 0 means "FAILED"
		        m = NewMemoryBlock(276)
		        m.long(0) = m.size 'must set size before calling getversionex 
		        ret = GetVersionExW(m)
		        
		        If ret = 0 Then
		          // Something really strange has happened, so use the A version
		          // instead
		          retryUsingAVersion = True
		        End
		      End
		      
		    End If
		    
		    If retryUsingAVersion = True Then
		      m = NewMemoryBlock(156) ''use this for osversioninfoex structure (2000+ only)
		      m.long(0) = m.size 'must set size before calling getversionex
		      ret = GetVersionExA(m) 'if not 2000+, will return 0
		      If ret = 0 Then
		        m = NewMemoryBlock(148) ' 148 sum of the bytes included in the structure (long = 4bytes, etc.)
		        m.long(0) = m.size 'must set size before calling getversionex
		        ret = GetVersionExA(m)
		        If ret = 0 Then
		          Return
		        End
		      End
		    End If
		    
		    m_MajorVersion = m.long(4)
		    m_MinorVersion = m.long(8)
		    m_Bug = m.long(12)
		    
		  #EndIf
		  
		  
		  Dim p As New picture(1,1)
		  p.Graphics.TextFont = "System"
		  m_SystemZeroSize = p.Graphics.TextSize
		  
		  p.Graphics.TextFont = "SmallSystem"
		  m_SmallSystemZeroSize = p.Graphics.TextSize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsWindows10OrGreater() As boolean
		  #If TargetWindows
		    
		    // _WIN32_WINNT version constants
		    //
		    Const _WIN32_WINNT_NT4   =                  &h0400 // Windows NT 4.0
		    Const _WIN32_WINNT_WIN2K =                 &h0500 // Windows 2000
		    Const _WIN32_WINNT_WINXP =                 &h0501 // Windows XP
		    Const _WIN32_WINNT_WS03  =                 &h0502 // Windows Server 2003
		    Const _WIN32_WINNT_WIN6  =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_VISTA =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_WS08  =                 &h0600 // Windows Server 2008
		    Const _WIN32_WINNT_LONGHORN =              &h0600 // Windows Vista
		    Const _WIN32_WINNT_WIN7     =              &h0601 // Windows 7
		    Const _WIN32_WINNT_WIN8     =              &h0602 // Windows 8
		    Const _WIN32_WINNT_WINBLUE  =              &h0603 // Windows 8.1
		    Const _WIN32_WINNT_WINTHRESHOLD =           &h0A00 // Windows 10
		    Const _WIN32_WINNT_WIN10 =                 &h0A00 // Windows 10
		    
		    Return IsWindowsVersionOrGreater(HIBYTE(_WIN32_WINNT_WINTHRESHOLD), LOBYTE(_WIN32_WINNT_WINTHRESHOLD), 0)
		  #Else
		    Return False
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsWindows7OrGreater() As boolean
		  #If TargetWindows
		    // _WIN32_WINNT version constants
		    //
		    Const _WIN32_WINNT_NT4   =                  &h0400 // Windows NT 4.0
		    Const _WIN32_WINNT_WIN2K =                 &h0500 // Windows 2000
		    Const _WIN32_WINNT_WINXP =                 &h0501 // Windows XP
		    Const _WIN32_WINNT_WS03  =                 &h0502 // Windows Server 2003
		    Const _WIN32_WINNT_WIN6  =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_VISTA =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_WS08  =                 &h0600 // Windows Server 2008
		    Const _WIN32_WINNT_LONGHORN =              &h0600 // Windows Vista
		    Const _WIN32_WINNT_WIN7     =              &h0601 // Windows 7
		    Const _WIN32_WINNT_WIN8     =              &h0602 // Windows 8
		    Const _WIN32_WINNT_WINBLUE  =              &h0603 // Windows 8.1
		    Const _WIN32_WINNT_WINTHRESHOLD =           &h0A00 // Windows 10
		    Const _WIN32_WINNT_WIN10 =                 &h0A00 // Windows 10
		    
		    Return IsWindowsVersionOrGreater(HIBYTE(_WIN32_WINNT_WIN7), LOBYTE(_WIN32_WINNT_WIN7), 0)
		  #Else
		    Return False
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsWindows7SP1OrGreater() As boolean
		  #If TargetWindows
		    // _WIN32_WINNT version constants
		    //
		    Const _WIN32_WINNT_NT4   =                  &h0400 // Windows NT 4.0
		    Const _WIN32_WINNT_WIN2K =                 &h0500 // Windows 2000
		    Const _WIN32_WINNT_WINXP =                 &h0501 // Windows XP
		    Const _WIN32_WINNT_WS03  =                 &h0502 // Windows Server 2003
		    Const _WIN32_WINNT_WIN6  =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_VISTA =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_WS08  =                 &h0600 // Windows Server 2008
		    Const _WIN32_WINNT_LONGHORN =              &h0600 // Windows Vista
		    Const _WIN32_WINNT_WIN7     =              &h0601 // Windows 7
		    Const _WIN32_WINNT_WIN8     =              &h0602 // Windows 8
		    Const _WIN32_WINNT_WINBLUE  =              &h0603 // Windows 8.1
		    Const _WIN32_WINNT_WINTHRESHOLD =           &h0A00 // Windows 10
		    Const _WIN32_WINNT_WIN10 =                 &h0A00 // Windows 10
		    
		    Return IsWindowsVersionOrGreater(HIBYTE(_WIN32_WINNT_WIN7), LOBYTE(_WIN32_WINNT_WIN7), 1)
		  #Else
		    Return False
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsWindows8OrGreater() As boolean
		  #If TargetWindows
		    // _WIN32_WINNT version constants
		    //
		    Const _WIN32_WINNT_NT4   =                  &h0400 // Windows NT 4.0
		    Const _WIN32_WINNT_WIN2K =                 &h0500 // Windows 2000
		    Const _WIN32_WINNT_WINXP =                 &h0501 // Windows XP
		    Const _WIN32_WINNT_WS03  =                 &h0502 // Windows Server 2003
		    Const _WIN32_WINNT_WIN6  =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_VISTA =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_WS08  =                 &h0600 // Windows Server 2008
		    Const _WIN32_WINNT_LONGHORN =              &h0600 // Windows Vista
		    Const _WIN32_WINNT_WIN7     =              &h0601 // Windows 7
		    Const _WIN32_WINNT_WIN8     =              &h0602 // Windows 8
		    Const _WIN32_WINNT_WINBLUE  =              &h0603 // Windows 8.1
		    Const _WIN32_WINNT_WINTHRESHOLD =           &h0A00 // Windows 10
		    Const _WIN32_WINNT_WIN10 =                 &h0A00 // Windows 10
		    
		    Return IsWindowsVersionOrGreater(HIBYTE(_WIN32_WINNT_WIN8), LOBYTE(_WIN32_WINNT_WIN8), 0)
		  #Else
		    Return False
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsWindows8Point1OrGreater() As boolean
		  #If TargetWindows
		    // _WIN32_WINNT version constants
		    //
		    Const _WIN32_WINNT_NT4   =                  &h0400 // Windows NT 4.0
		    Const _WIN32_WINNT_WIN2K =                 &h0500 // Windows 2000
		    Const _WIN32_WINNT_WINXP =                 &h0501 // Windows XP
		    Const _WIN32_WINNT_WS03  =                 &h0502 // Windows Server 2003
		    Const _WIN32_WINNT_WIN6  =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_VISTA =                 &h0600 // Windows Vista
		    Const _WIN32_WINNT_WS08  =                 &h0600 // Windows Server 2008
		    Const _WIN32_WINNT_LONGHORN =              &h0600 // Windows Vista
		    Const _WIN32_WINNT_WIN7     =              &h0601 // Windows 7
		    Const _WIN32_WINNT_WIN8     =              &h0602 // Windows 8
		    Const _WIN32_WINNT_WINBLUE  =              &h0603 // Windows 8.1
		    Const _WIN32_WINNT_WINTHRESHOLD =           &h0A00 // Windows 10
		    Const _WIN32_WINNT_WIN10 =                 &h0A00 // Windows 10
		    
		    Return IsWindowsVersionOrGreater(HIBYTE(_WIN32_WINNT_WINBLUE), LOBYTE(_WIN32_WINNT_WINBLUE), 0)
		  #Else
		    Return False
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsWindowsServer() As boolean
		  #If TargetWindows
		    // 
		    // // _WIN32_WINNT version constants
		    // //
		    // Const _WIN32_WINNT_NT4   =                  &h0400 // Windows NT 4.0
		    // Const _WIN32_WINNT_WIN2K =                 &h0500 // Windows 2000
		    // Const _WIN32_WINNT_WINXP =                 &h0501 // Windows XP
		    // Const _WIN32_WINNT_WS03  =                 &h0502 // Windows Server 2003
		    // Const _WIN32_WINNT_WIN6  =                 &h0600 // Windows Vista
		    // Const _WIN32_WINNT_VISTA =                 &h0600 // Windows Vista
		    // Const _WIN32_WINNT_WS08  =                 &h0600 // Windows Server 2008
		    // Const _WIN32_WINNT_LONGHORN =              &h0600 // Windows Vista
		    // Const _WIN32_WINNT_WIN7     =              &h0601 // Windows 7
		    // Const _WIN32_WINNT_WIN8     =              &h0602 // Windows 8
		    // Const _WIN32_WINNT_WINBLUE  =              &h0603 // Windows 8.1
		    // Const _WIN32_WINNT_WINTHRESHOLD =           &h0A00 // Windows 10
		    // Const _WIN32_WINNT_WIN10 =                 &h0A00 // Windows 10
		    // 
		    // OSVERSIONINFOEXW osvi = { sizeof(osvi), 0, 0, 0, 0, {0}, 0, 0, 0, VER_NT_WORKSTATION };
		    // DWORDLONG        Const dwlConditionMask = VerSetConditionMask( 0, VER_PRODUCT_TYPE, VER_EQUAL );
		    // 
		    // Return !VerifyVersionInfoW(&osvi, VER_PRODUCT_TYPE, dwlConditionMask);
		  #Else
		    Return False
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsWindowsVersionOrGreater(wMajorVersion as integer, wMinorVersion as integer, wServicePackMajor as integer) As boolean
		  #Pragma unused wMajorVersion
		  #Pragma unused wMinorVersion 
		  #pragma unused wServicePackMajor
		  
		  #If TargetWindows
		    // typedef struct _OSVERSIONINFOEXW {
		    // DWORD dwOSVersionInfoSize;   //    uint32 -> 4
		    // DWORD dwMajorVersion;        //    uint32 -> 4
		    // DWORD dwMinorVersion;        //    uint32 -> 4
		    // DWORD dwBuildNumber;         //    uint32 -> 4
		    // DWORD dwPlatformId;          //    uint32 -> 4
		    // WCHAR szCSDVersion[128];     // 128 * 2 -> 256
		    // WORD  wServicePackMajor;     //    uint16 -> 2
		    // WORD  wServicePackMinor;     //    uint16 -> 2
		    // WORD  wSuiteMask;            //    uint16 -> 2
		    // Byte  wProductType;          //     uint8 -> 1
		    // Byte  wReserved;             //     uint8 -> 1
		    // } OSVERSIONINFOEXW, *POSVERSIONINFOEXW, *LPOSVERSIONINFOEXW, RTL_OSVERSIONINFOEXW, *PRTL_OSVERSIONINFOEXW;
		    
		    // OSVERSIONINFOEXW osvi = { sizeof(osvi), 0, 0, 0, 0, {0}, 0, 0 };
		    // DWORDLONG Const dwlConditionMask = VerSetConditionMask( VerSetConditionMask( VerSetConditionMask( 0, VER_MAJORVERSION, VER_GREATER_EQUAL), VER_MINORVERSION, VER_GREATER_EQUAL), VER_SERVICEPACKMAJOR, VER_GREATER_EQUAL);
		    
		    
		    Soft Declare Function VerSetConditionMask Lib "Kernel32" ( ConditionMask As UInt64, TypeMask As UInt32, Condition As Uint8 ) As UInt64
		    Soft Declare Function VerifyVersionInfoW Lib "Kernel32" ( lpVersionInformation As Ptr, dwTypeMask As UInt32, dwlConditionMask As UInt64 ) As Boolean
		    
		    Const VER_BUILDNUMBER = &h0000004 
		    Const VER_MAJORVERSION = &h0000002
		    Const VER_MINORVERSION = &h0000001
		    Const VER_PLATFORMID = &h0000008
		    Const VER_PRODUCT_TYPE = &h0000080 
		    Const VER_SERVICEPACKMAJOR = &h0000020 
		    Const VER_SERVICEPACKMINOR = &h0000010 
		    Const VER_SUITENAME = &h0000040 
		    
		    Const VER_EQUAL = 1 // The current value must be equal To the specified value.
		    Const VER_GREATER = 2 // The current value must be greater than the specified value.
		    Const VER_GREATER_EQUAL = 3 // The current value must be greater than Or equal To the specified value.
		    Const VER_LESS = 4 // The current value must be less than the specified value.
		    Const VER_LESS_EQUAL = 5 // The current value must be less than Or equal To the specified value.
		    
		    // If dwTypeBitMask Is VER_SUITENAME, this parameter can be one Of the following values.
		    // VER_AND           6 All product suites specified In the wSuiteMask member must be present In the current System.
		    // VER_OR            7 At least one Of the specified product suites must be present In the current System.
		    
		    Dim dwlConditionMask As UInt64
		    dwlConditionMask = VerSetConditionMask( VerSetConditionMask( VerSetConditionMask( 0, VER_MAJORVERSION, VER_GREATER_EQUAL), VER_MINORVERSION, VER_GREATER_EQUAL), VER_SERVICEPACKMAJOR, VER_GREATER_EQUAL)
		    
		    Dim mb As New MemoryBlock(284)
		    Dim osvi As Ptr
		    osvi = mb
		    
		    osvi.OSVERSIONINFOEXW.dwMajorVersion = wMajorVersion
		    osvi.OSVERSIONINFOEXW.dwMinorVersion = wMinorVersion
		    osvi.OSVERSIONINFOEXW.wServicePackMajor = wServicePackMajor
		    
		    Return VerifyVersionInfoW(osvi, VER_MAJORVERSION + VER_MINORVERSION + VER_SERVICEPACKMAJOR, dwlConditionMask) <> False
		  #Else
		    Return False
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub LaunchAppWithArguments(app as string, args() as String)
		  #If TargetMacOS
		    // if you DO NOT HHAVE or USE MBS then set useMBS to FALSE !
		    Const useMBS = false
		    
		    #If useMBS = True
		      Dim w As New NSWorkspaceMBS
		      
		      Dim file As FolderItem = GetFolderItem(app, FolderItem.PathTypeNative)
		      
		      Dim error As NSErrorMBS
		      Dim configuration As New Dictionary
		      Dim options As Integer
		      
		      configuration.Value(w.NSWorkspaceLaunchConfigurationArguments) = args
		      
		      // and hide all others
		      // options = w.NSWorkspaceLaunchAndHideOthers
		      options = w.NSWorkspaceLaunchAsync
		      
		      Dim r As NSRunningApplicationMBS = w.launchApplicationAtFile(file, options, configuration, error)
		      
		      If r = Nil Then
		        Break
		        MsgBox "Error: " + error.LocalizedDescription
		      Else
		        // MsgBox "Started: "+r.localizedName
		      End If
		    #EndIf
		    
		  #ElseIf TargetWin32
		    
		    Soft Declare Sub ShellExecuteA Lib "Shell32" ( hwnd As Integer, operation As CString, file As CString, params As CString, directory As CString, show As Integer )
		    Soft Declare Sub ShellExecuteW Lib "Shell32" ( hwnd As Integer, operation As WString, file As WString, params As WString, directory As WString, show As Integer )
		    
		    Dim params As String
		    params = Join( args, " " )
		    
		    Dim file As FolderItem = GetFolderItem(app, FolderItem.PathTypeNative)
		    
		    If System.IsFunctionAvailable( "ShellExecuteW", "Shell32" ) Then
		      ShellExecuteW( 0, "open", file.nativePath, params, "", 1 )
		    Else
		      ShellExecuteA( 0, "open", file.nativePath, params, "", 1 )
		    End If
		    
		  #Else
		    
		  #EndIf
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function LOBYTE(wValue as Uint16) As Uint8
		  Return wvalue And &h00FF
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function OSBugVersion() As integer
		  Initialize
		  
		  Return m_Bug
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function OSBuildVersion() As string
		  Initialize
		  
		  Return m_Build
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function OSMajorVersion() As integer
		  Initialize
		  
		  Return m_MajorVersion
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function OSMinorVersion() As integer
		  Initialize
		  
		  Return m_MinorVersion
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunUnitTests()
		  #If debugbuild 
		    
		    Initialize
		    
		    
		  #EndIf
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_Bug As integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_Build As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_cputype As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_Initialized As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_MacAppNapToken As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_MajorVersion As integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_MinorVersion As integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_SmallSystemZeroSize As single
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_SystemZeroSize As Single
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_Windows_previous_thread_state As Uint32
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If m_Initialized = False Then
			    Initialize
			  End If
			  
			  return m_SmallSystemZeroSize
			End Get
		#tag EndGetter
		Protected SmallSystemZeroSize As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If m_Initialized = False Then
			    Initialize
			  End If
			  
			  Return m_SystemZeroSize
			End Get
		#tag EndGetter
		Protected SystemZeroSize As Single
	#tag EndComputedProperty


	#tag Structure, Name = OSVersionInfo, Flags = &h1, Attributes = \"StructureAlignment \x3D 1"
		major as integer
		  minor as integer
		bug as integer
	#tag EndStructure

	#tag Structure, Name = OSVERSIONINFOEXW, Flags = &h1
		dwOSVersionInfoSize as Uint32
		  dwMajorVersion as Uint32
		  dwMinorVersion as Uint32
		  dwBuildNumber as Uint32
		  dwPlatformId as Uint32
		  szCSDVersion(127) as Uint16
		  wServicePackMajor as Uint16
		  wServicePackMinor as Uint16
		  wSuiteMask as Uint16
		  wProductType as Uint8
		wReserved as Uint8
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
