#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Open()
		  Dim result As Integer 
		  result = macOS.IsProcessTranslated
		  
		  // unfortunately there is no way using introspection to find 
		  // modules, or their methods and classes
		  // and then run them 
		  
		  Diff.RunUnitTests
		  Preferences.RunUnitTests
		  Notifications.RunUnitTests
		  LanguageUtils.RunUnitTests
		  ArrayExtensions.RunUnitTests
		  StringExtensions.RunUnitTests
		  NumericExtensions.RunUnitTests
		  EndOfLineExtensions.RunUnitTests
		  ObjectExtensions.RunUnitTests
		  StringUtils.RunUnitTests
		  TextOutputStreamExtensions.RunUnitTests
		  FolderitemExtensions.RunUnitTests
		  Security.RunUnitTests
		  
		  
		  
		  #If targetMacOS Then
		    // --- This code snippet was made from the Ohanaware App Kit 2021 - ohanaware.com
		    // --- Basically, we grab the NSMenu instance of the windowMenu item, tell Apple's App Kit to use that for the Window menu.
		    
		    Declare Function NSClassFromString               Lib "Foundation"                          ( className As CFStringRef ) As Integer
		    Declare Function NSMenuitem_Submenu              Lib "AppKit" selector "submenu"           ( NSMenuitemInstance As Integer ) As Integer
		    Declare Sub      NSApplication_setWindowsMenu    Lib "AppKit" selector "setWindowsMenu:"   ( NSApplicationInstance As Integer, inNSMenuitem As Integer )
		    Declare Function NSApplication_sharedApplication Lib "AppKit" selector "sharedApplication" ( NSApplicationClass As Integer ) As Integer
		    
		    Dim mBar As MenuBar = Self.MenuBar
		    If mBar <> Nil Then
		      Dim mItem As MenuItem = mBar.FindItemWithText("Window")
		      If mItem <> Nil Then
		        Dim subMenuRef As Integer = NSMenuitem_Submenu( mItem.handle( menuitem.handleType.CocoaNSMenuItem ) )
		        
		        NSApplication_setWindowsMenu( NSApplication_sharedApplication( NSClassFromString( "NSApplication" ) ), subMenuRef )
		      End If
		      
		    End If
		  #EndIf
		  
		  MacOS.SetDockLabel("Fooey !")
		  
		End Sub
	#tag EndEvent


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant

	#tag Constant, Name = Untitled, Type = String, Dynamic = False, Default = \"\" kjahsd \" asd", Scope = Protected
	#tag EndConstant


End Class
#tag EndClass
