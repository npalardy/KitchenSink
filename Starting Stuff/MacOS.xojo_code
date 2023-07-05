#tag Module
Protected Module MacOS
	#tag Method, Flags = &h1
		Protected Function ApplicationIsRunning(bundleID As String) As Boolean
		  // Usage:
		  // 
		  // Dim isPhotoshopRunning As Boolean = ApplicationIsRunning("com.adobe.photoshop")
		  // 
		  // Dim isFinderRunning As Boolean = ApplicationIsRunning("com.apple.finder")
		  // 
		  // Dim isExcelRunning As Boolean = ApplicationIsRunning("com.microsoft.excel")
		  #If TargetMacOS
		    
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    Declare Function getCount Lib "Foundation" Selector "count" (obj As ptr) As Integer
		    Declare Function runningApplicationsWithBundleIdentifier Lib "Foundation" Selector "runningApplicationsWithBundleIdentifier:" ( cls As ptr , bundleIdentifier As CFStringRef ) As Ptr
		    
		    Dim NSRunningApplication As ptr = NSClassFromString("NSRunningApplication")
		    Dim runningApps As ptr = runningApplicationsWithBundleIdentifier(NSRunningApplication, bundleID)
		    
		    Dim c As Integer = getCount(runningApps)
		    
		    Return c > 0
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub CrashOnMacOSException()
		  #If TargetMacOS
		    
		    Const FoundationLib = "Foundation"
		    
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults"(NSUserDefaultsClass As Ptr) As Ptr
		    Declare Function NSClassFromString Lib FoundationLib(ClassName As CFStringRef) As Ptr
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    
		    Declare Sub setBool Lib FoundationLib Selector "setBool:forKey:"(NSUserDefaults As Ptr, value As Boolean, Key As CFStringRef)
		    setBool(standardUserDefaultsPtr, True, "NSApplicationCrashOnExceptions")
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub CreateAliasAt(Extends f as FolderItem, aliasFile as FolderItem)
		  #if TargetMacOS
		    If f Is Nil then
		      Return
		    End if
		    If aliasFile Is Nil or aliasFile.Parent Is Nil then
		      Return
		    End if
		    
		    dim ae As AppleEvent = NewAppleEvent("core", "crel", "MACS")
		    If ae Is Nil then
		      Return
		    End if
		    ae.MacTypeParam("kocl") = "alia"
		    ae.FolderItemParam("insh") = aliasFile.Parent
		    ae.FolderItemParam("to  ") = f
		    dim aer as new AppleEventRecord
		    aer.StringParam("pnam") = aliasFile.name
		    ae.RecordParam("prdt") = aer
		    Call ae.Send
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FindFilesByBundleID(psBundleID As String) As FolderItem()
		  Dim oResults() As FolderItem
		  
		  If (psBundleID = "") Then 
		    Return oResults
		  End If
		  
		  #If TargetMacOS Then
		    //https://developer.apple.com/documentation/coreservices/1449290-lscopyapplicationurlsforbundleid?language=objc
		    
		    Declare Function LSCopyApplicationURLsForBundleIdentifier Lib "Foundation" (inBundleIdentifier As CFStringRef, outError As Ptr) As Ptr
		    Declare Function NSArrayCount Lib "Foundation" Selector "count" (ptrToNSArray As Ptr) As UInteger
		    Declare Function NSArrayObjectAtIndex Lib "Foundation" Selector "objectAtIndex:" (ptrToNSArray As Ptr, index As UInteger) As Ptr
		    Declare Function CFURLCopyFileSystemPath Lib "Foundation" (anURL As Ptr, pathStyle As Int32) As CFStringRef
		    
		    Const kCFURLPOSIXPathStyle = 0
		    Const kCFURLHFSPathStyle = 1
		    
		    Dim ptrToArray As Ptr = LSCopyApplicationURLsForBundleIdentifier(psBundleID, Nil)
		    If (ptrToArray = Nil) Then Return Nil
		    
		    Dim iResultCount As UInteger = NSArrayCount(ptrToArray)
		    If (iResultCount < 1) Then Return Nil
		    
		    For i As Integer = 0 To iResultCount - 1
		      Dim ptrToNSURL As Ptr = NSArrayObjectAtIndex(ptrToArray, i)
		      If (ptrToNSURL = Nil) Then Continue
		      
		      Dim sNativePath As String = CFURLCopyFileSystemPath(ptrToNSURL, kCFURLPOSIXPathStyle)
		      
		      Try
		        Dim oResult As New FolderItem(sNativePath, FolderItem.PathTypeNative)
		        oResults.Append(oResult)
		      Catch UnsupportedFormatException
		        'ignore
		      End Try
		    Next
		    
		    If (oResults.Ubound >= 0) Then 
		      Return oResults
		    End If
		    Return oResults
		  #EndIf
		  
		  Return oResults
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsProcessTranslated() As integer
		  // The example function returns the value 0 for a native process, 1 for a translated process, and -1 when an error occurs.
		  
		  #If TargetMacOS
		    
		    // from Apples errno.h header
		    //    Const #define ENOENT          2               /* No such file Or directory */
		    Const ENOENT = 2
		    
		    // from https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment#Determine-Whether-Your-App-Is-Running-as-a-Translated-Binary
		    
		    // https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/sysctlbyname.3.html
		    // int sysctlbyname(Const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen)
		    
		    Declare Function sysctlbyname Lib "System" ( name As CString, ByRef oldp As Int32, ByRef oldlenp As UInt64, newp As Ptr, newlen As Ptr) As Int32
		    
		    Declare Function libcErrorCode Lib "System" alias "__error" () As Ptr
		    
		    Dim ret As Int32 = 0 //             int ret = 0;
		    Dim size As UInt64 = 4 //           size_t size = sizeof(ret);
		    
		    // If (sysctlbyname("sysctl.proc_translated", &ret, &size, NULL, 0) == -1) 
		    Dim returnValue As Int32 = sysctlbyname("sysctl.proc_translated", ret, size, Nil, Nil)
		    
		    If returnValue = -1 Then
		      
		      // oh YAY thanks for the std c lib runtime having a few globals !
		      // errno.h lists errno as
		      // __BEGIN_DECLS
		      // extern int * __error(void);
		      // #define errno (*__error())
		      // __END_DECLS
		      
		      Dim mb As MemoryBlock 
		      mb = libcErrorCode()
		      If mb Is Nil Then
		        //something bad has happened
		        Return -1
		      End If
		      Dim errorNo As Integer = mb.Int32Value(0)
		      
		      // {
		      //     If (errno == ENOENT)
		      //       Return 0;
		      //     Return -1;
		      // }
		      
		      If errorNo = ENOENT Then
		        Return 0
		      End If
		      Return -1
		    End If
		    
		    // Return ret;
		    
		    Return returnValue
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsRosetta() As boolean
		  #if TargetMacOS
		    
		    Soft Declare Function sysctl Lib "System.framework" (p1 as Ptr, p2 as Integer, p3 as Ptr, ByRef p4 as Integer, p5 as Integer, p6 as Integer) as Integer
		    
		    if System.IsFunctionAvailable("sysctl", "System.framework") = false then
		      return false
		    end if
		    
		    Const CTL_HW = 6
		    Const HW_MODEL = 2
		    Const Null = 0
		    
		    dim mib as new MemoryBlock(8)
		    mib.Long(0) = CTL_HW
		    mib.Long(4) = HW_MODEL
		    
		    dim model as new MemoryBlock(32)
		    dim len as Integer = model.Size
		    
		    dim theResult as Integer = sysctl(mib, 2, model, len, Null, 0)
		    Return (theResult = 0) and (StrComp(model.StringValue(0,len), "PowerMac" + Chr(0), 0) = 0)
		    
		  #endif
		  
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function isValidBundleID(bundleIDStr as string) As boolean
		  // per https://help.apple.com/xcode/mac/current/#/dev9b66ae7df
		  // A bundle ID uniquely identifies a single app throughout the system. 
		  // The bundle ID string must contain only alphanumeric characters (A-Z, a-z, 0-9), hyphen (-), and period (.). 
		  // The string should be in reverse-DNS format. 
		  // Bundle IDs are case sensitive.
		  
		  If bundleIDStr.Trim() = "" Then
		    Return False
		  End If
		  
		  Dim chars() As String = bundleIDStr.Split("")
		  
		  For i As Integer = 0 To chars.LastIndex
		    
		    Select Case True
		      
		    Case StringUtils.Contains("abcdefghijklmnopqrstuvwxyz", chars(i)) 
		      
		    Case StringUtils.Contains("ABCDEFGHIJKLMNOPQRSTUVWXYZ", chars(i)) 
		      
		    Case StringUtils.Contains("0123456789", chars(i)) 
		      
		    Case chars(i) = "."
		      
		    Case chars(i) = "-"
		      
		    Else
		      Return False
		    End Select
		    
		  Next
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function MachineName() As String
		  #If targetMacOS
		    Const CocoaLib As String = "Cocoa.framework"
		    
		    Const NSClassName As String = "NSProcessInfo"
		    
		    Declare Function defaultCenter Lib CocoaLib Selector "processInfo" (class_id As Ptr) As Ptr
		    Declare Function NSClassFromString Lib CocoaLib (aClassName As CFStringRef) As Ptr
		    Declare Function hostName Lib CocoaLib Selector "hostName" (obj_id As Ptr) As CFStringRef
		    
		    Dim p As Ptr = defaultCenter(NSClassFromString(NSClassName))
		    
		    Return hostName(p)
		    
		  #EndIf
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RevealInFinder(f as FolderItem)
		  #if TargetMacOS
		    
		    If f is nil or not f.Exists then
		      Return
		    End if
		    
		    dim a as AppleEvent = NewAppleEvent("misc", "slct", "MACS")
		    a.FolderItemParam("----") = f
		    If a.send then
		      a = NewAppleEvent("misc", "actv", "MACS")
		      If a.send then
		        //success
		      Else
		        //activate failed
		      End if
		    Else
		      //select failed
		    End if
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetDockLabel(label as string)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" (ClassName As CFStringRef) As Ptr
		    Declare Function sharedApplication Lib "AppKit" Selector "sharedApplication" (classRef As Ptr) As Ptr
		    Declare Function getDockTile Lib "AppKit" Selector "dockTile" (NSApplicationInstance As Ptr) As Ptr
		    Declare Sub setBadgeLabel Lib "AppKit" Selector "setBadgeLabel:" (NSDockTileInstance As Ptr, NSStringValue As CFStringRef)
		    Declare Sub setShowsApplicationBadge Lib "AppKit" Selector "setShowsApplicationBadge:" (id As Ptr, value As Boolean)
		    
		    Var oSharedApplication As Ptr = sharedApplication(NSClassFromString("NSApplication"))
		    Var oDockTile As Ptr = getDockTile(oSharedApplication)
		    
		    setBadgeLabel(oDockTile, label)
		    setShowsApplicationBadge(oDockTile, True)
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function UserName(shortName as Boolean) As String
		  #if TargetMacOS
		    const CarbonFramework = "Carbon.framework"
		    
		    dim SystemVersion as Integer
		    dim SystemOSX as Boolean = System.Gestalt("sysv", SystemVersion) and (SystemVersion >= &h1000)
		    If SystemOSX then
		      soft declare Function CSCopyUserName Lib CarbonFramework (useShortName as Boolean) as CFStringRef
		      
		      return CSCopyUserName(shortName)
		    Else
		      // dim m as new MemoryBlock(32)
		      // m.StringValue(0, 32) = app.ResourceFork.GetResource("STR ", -16413)
		      // Return DefineEncoding(m.PString(0), Encodings.SystemDefault)
		    End if
		  #endif
		End Function
	#tag EndMethod


	#tag Note, Name = About a platform specific module like this
		
		// any methods in here need to often be wrapped in #IF TargetMacOS UNLESS they are portable
		
	#tag EndNote


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
