#tag Module
Protected Module ApplicationExtensions
	#tag Method, Flags = &h0
		Sub Appearance(extends appInstance as Application, assigns preferredAppearance as Appearance)
		  #Pragma unused appInstance
		  #Pragma unused preferredAppearance
		  
		  #If targetmacOS
		    Declare Function NSClassFromString Lib "AppKit" (inClassName As CFStringRef) As Integer
		    Declare Sub setAppearance Lib "AppKit" Selector "setAppearance:" (NSApplicationInstance As Integer, NSAppearanceInstance As Integer)
		    Declare Function sharedApplication Lib "AppKit" Selector "sharedApplication" (classRef As Integer) As Integer
		    Declare Function NSAppearanceNamed Lib "AppKit" Selector "appearanceNamed:" (NSAppearanceClass As Integer, name As CFStringRef) As Integer
		    
		    Select Case preferredAppearance
		      
		    Case Appearance.SystemDefault
		      setAppearance(sharedApplication(NSClassFromString("NSApplication")), 0 )
		      
		    Case Appearance.DarkAqua
		      setAppearance(sharedApplication(NSClassFromString("NSApplication")), NSAppearanceNamed(NSClassFromString("NSAppearance"), "NSAppearanceNameDarkAqua"))
		      // NSAppearanceNameDarkAqua 
		      // The standard dark System appearance.
		      
		    Case Appearance.VibrantLight
		      setAppearance(sharedApplication(NSClassFromString("NSApplication")), NSAppearanceNamed(NSClassFromString("NSAppearance"), "NSAppearanceNameVibrantLight"))
		      // NSAppearanceNameVibrantLight
		      // The light vibrant appearance, available only In visual effect views.
		      
		    Case Appearance.VibrantDark
		      setAppearance(sharedApplication(NSClassFromString("NSApplication")), NSAppearanceNamed(NSClassFromString("NSAppearance"), "NSAppearanceNameVibrantDark"))
		      // NSAppearanceNameVibrantDark
		      // A dark vibrant appearance, available only In visual effect views.
		      
		    Case Appearance.HighContrastAqua
		      setAppearance(sharedApplication(NSClassFromString("NSApplication")), NSAppearanceNamed(NSClassFromString("NSAppearance"), "NSAppearanceNameAccessibilityHighContrastAqua"))
		      // NSAppearanceNameAccessibilityHighContrastAqua
		      // A high-contrast version Of the standard light System appearance.
		      
		    Case Appearance.HighContrastDarkAqua
		      setAppearance(sharedApplication(NSClassFromString("NSApplication")), NSAppearanceNamed(NSClassFromString("NSAppearance"), "NSAppearanceNameAccessibilityHighContrastDarkAqua"))
		      // NSAppearanceNameAccessibilityHighContrastDarkAqua
		      // A high-contrast version Of the standard dark System appearance.
		      
		    Case Appearance.HighContrastVibrantLight
		      setAppearance(sharedApplication(NSClassFromString("NSApplication")), NSAppearanceNamed(NSClassFromString("NSAppearance"), "NSAppearanceNameAccessibilityHighContrastVibrantLight"))
		      // NSAppearanceNameAccessibilityHighContrastVibrantLight
		      // A high-contrast version Of the light vibrant appearance.
		      
		    Case Appearance.HighContrastVibrantDark
		      setAppearance(sharedApplication(NSClassFromString("NSApplication")), NSAppearanceNamed(NSClassFromString("NSAppearance"), "NSAppearanceNameAccessibilityHighContrastVibrantDark"))
		      // NSAppearanceNameAccessibilityHighContrastVibrantDark
		      // A high-contrast version Of the dark vibrant appearance.
		      
		    End Select
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BundleID() As string
		  Dim appId As String
		  #If TargetMacOS
		    Declare Function mainBundle Lib "AppKit" selector "mainBundle"(NSBundleClass As Ptr) As Ptr
		    Declare Function NSClassFromString Lib "AppKit"(className As CFStringRef) As Ptr
		    Declare Function getValue Lib "AppKit" selector "bundleIdentifier"(NSBundleRef As Ptr) As CFStringRef
		    appId = getValue(mainBundle(NSClassFromString("NSBundle")))
		  #Else
		    break
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Icon(extends appInstance as Application) As Picture
		  #Pragma unused appInstance
		  
		  #If TargetMacOS
		    // get 
		    break
		  #ElseIf TargetWindows
		    Break
		  #ElseIf TargetLinux
		    Break
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name(extends appInstance as Application) As String
		  #Pragma unused appInstance
		  
		  #If TargetMacOS
		    
		    Dim f As Folderitem = app.ExecutableFile
		    f = f.Parent
		    f = f.Parent
		    f = f.parent
		    
		    Dim nameString As String = f.DisplayName
		    
		    #If DebugBuild
		      If nameString.Right(Len(".debug.app")) = ".debug.app" Then
		        nameString = nameString.Left(nameString.Len - Len(".debug.app"))
		      End If
		    #EndIf
		    
		    If nameString.Right(Len(".app")) = ".app" Then
		      nameString = nameString.Left(nameString.Len - Len(".app"))
		    End If
		    
		    Return nameString
		    
		    // get name from bundle
		    // Declare Function mainBundle Lib "AppKit" selector "mainBundle"(NSBundleClass As Ptr) As Ptr
		    // Declare Function NSClassFromString Lib "AppKit"(className As CFStringRef) As Ptr
		    // Declare Function localizedStringForKey Lib "AppKit" selector "localizedStringForKey:value:table:"(NSBundleRef As Ptr, key As CFStringRef, defaultvalue As CFStringRef, table As CFStringRef) As CFStringRef
		    // 
		    // Dim tableNameRef As CFStringRef
		    // Dim valueRef As CFStringRef
		    // 
		    // Dim classPtr As Ptr = NSClassFromString("NSBundle")
		    // Dim mainBundlePtr As Ptr = mainBundle(classPtr)
		    // Dim s As String = localizedStringForKey(mainBundlePtr, "CFBundleName", valueRef, tableNameRef)
		    // 
		    // Return s
		    
		  #ElseIf TargetWindows
		    Dim f As Folderitem = app.ExecutableFile
		    
		    Dim nameString As String = f.DisplayName
		    
		    If nameString.Right(4) = ".exe" Then
		      nameString = nameString.Left(nameString.Len - 4)
		    End If
		    
		    Return nameString
		    
		  #ElseIf TargetLinux
		    Break
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ResourcesFolder(extends appInstance as Application) As FolderItem
		  #If TargetMacOS
		    Dim exeFile As Folderitem = appInstance.ExecutableFile
		    Dim resFolder As FolderItem = exeFile.parent.parent.child("Resources")
		    Return resFolder
		    
		  #ElseIf TargetWindows
		    return SpecialFolder.Resources
		    
		  #Else
		    Debug.assert False, CurrentMethodName + " someone forgot to add resources dir to App for this target"
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ThemesFolder(extends appInstance as Application) As Folderitem
		  Dim themeFolder As Folderitem
		  
		  Try
		    themeFolder = SpecialFolder.ApplicationData
		  Catch noe As NilObjectException
		    Break // we're in serious shit here if this happens !
		    Return nil
		  End Try
		  
		  Try
		    themeFolder = themeFolder.Child(appInstance.Name) 
		    If themeFolder Is Nil Then
		      Break // we're in serious shit here if this happens !
		      Return nil
		    Elseif themeFolder.Exists = False Then
		      themeFolder.CreateAsFolder
		    End If
		  Catch noe As NilObjectException
		    Break 
		    Return nil
		  End Try
		  
		  Try
		    themeFolder = themeFolder.Child("Themes")
		    If themeFolder Is Nil Then
		      Break // we're in serious shit here if this happens !
		      Return nil
		    Elseif themeFolder.Exists = False Then
		      themeFolder.CreateAsFolder
		    End If
		  Catch noe As NilObjectException
		    Break 
		    Return Nil
		  End Try
		  
		  Return themeFolder
		End Function
	#tag EndMethod


	#tag Constant, Name = FoundationLib, Type = String, Dynamic = False, Default = \"Foundation", Scope = Private
	#tag EndConstant


	#tag Enum, Name = Appearance, Type = Integer, Flags = &h0
		SystemDefault 
		  DarkAqua
		  VibrantLight
		  VibrantDark
		  HighContrastAqua
		  HighContrastDarkAqua
		  HighContrastVibrantLight
		HighContrastVibrantDark
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
