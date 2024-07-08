#tag Class
Private Class MacOSPrefs
Inherits Preferences.BasePrefs
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Synchronize
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(key as String) As Boolean
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function stringForKey Lib FoundationLib Selector "stringForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As Ptr
		    Declare Function objectForKey Lib FoundationLib Selector "objectForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As Ptr
		    
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    Dim sPtr As Ptr = stringForKey(standardUserDefaultsPtr, key)
		    Dim oPtr As Ptr = objectForKey(standardUserDefaultsPtr, key)
		    
		    Return (sPtr <> Nil) or (oPtr <> nil)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadBoolean(key as String) As Boolean
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function boolForKey Lib FoundationLib Selector "boolForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As Byte
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    Return (1 = boolForKey(standardUserDefaultsPtr, key))
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadColor(key As String) As Color
		  
		  Dim i As Int32 = ReadInteger(key)
		  
		  Return Color(i)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDate(key As String) As Date
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function alloc Lib FoundationLib Selector "alloc" (NSClass As Ptr) As Ptr
		    Declare Function init Lib FoundationLib Selector "init" (NSClass As Ptr) As Ptr
		    Declare Function objectForKey Lib FoundationLib Selector "objectForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Function stringFromDate Lib FoundationLib Selector "stringFromDate:" (NSDateFormatter As Ptr, NSDate As Ptr) As CFStringRef 
		    Declare Function systemTimeZone Lib FoundationLib Selector "systemTimeZone" (NSTimeZone As Ptr) As Ptr
		    Declare Sub setDateFormat Lib FoundationLib Selector "setDateFormat:" (NSDateFormatter As Ptr, Format As CFStringRef)
		    Declare Sub setTimeZone Lib FoundationLib Selector "setTimeZone:" (NSDateFormatter As Ptr, NSTimeZone As Ptr)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults")) 
		    Static dateFormatterClassPtr As Ptr = NSClassFromString("NSDateFormatter")
		    Static timeZoneClassPtr As Ptr = NSClassFromString("NSTimeZone")
		    Static systemTimeZonePtr As Ptr = systemTimeZone(timeZoneClassPtr)
		    
		    Dim dataFormatterPtr As Ptr = init(alloc(dateFormatterClassPtr)) 
		    setDateFormat(dataFormatterPtr, "yyyy-MM-dd HH:mm:ss") 
		    setTimeZone(dataFormatterPtr, systemTimeZonePtr)
		    
		    Dim datePtr As Ptr = objectForKey(standardUserDefaultsPtr, key)
		    Dim dateString As String = stringFromDate(dataFormatterPtr, datePtr)
		    
		    Dim d As New Date()
		    d.SQLDateTime = dateString
		    
		    Return d
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDateTime(key As String) As DateTime
		  
		  // Calling the overridden superclass method.
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function alloc Lib FoundationLib Selector "alloc" (NSClass As Ptr) As Ptr
		    Declare Function init Lib FoundationLib Selector "init" (NSClass As Ptr) As Ptr
		    Declare Function objectForKey Lib FoundationLib Selector "objectForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Function stringFromDate Lib FoundationLib Selector "stringFromDate:" (NSDateFormatter As Ptr, NSDate As Ptr) As CFStringRef 
		    Declare Function systemTimeZone Lib FoundationLib Selector "systemTimeZone" (NSTimeZone As Ptr) As Ptr
		    Declare Sub setDateFormat Lib FoundationLib Selector "setDateFormat:" (NSDateFormatter As Ptr, Format As CFStringRef)
		    Declare Sub setTimeZone Lib FoundationLib Selector "setTimeZone:" (NSDateFormatter As Ptr, NSTimeZone As Ptr)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults")) 
		    Static dateFormatterClassPtr As Ptr = NSClassFromString("NSDateFormatter")
		    Static timeZoneClassPtr As Ptr = NSClassFromString("NSTimeZone")
		    Static systemTimeZonePtr As Ptr = systemTimeZone(timeZoneClassPtr)
		    
		    Dim dataFormatterPtr As Ptr = init(alloc(dateFormatterClassPtr)) 
		    setDateFormat(dataFormatterPtr, "yyyy-MM-dd HH:mm:ss") 
		    setTimeZone(dataFormatterPtr, systemTimeZonePtr)
		    
		    Dim datePtr As Ptr = objectForKey(standardUserDefaultsPtr, key)
		    Dim dateString As String = stringFromDate(dataFormatterPtr, datePtr)
		    
		    Dim d As DateTime = DateTime.FromString(dateString)
		    
		    Return d
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDouble(key As String) As Double
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function doubleForKey Lib FoundationLib Selector "doubleForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As Double
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    Return doubleForKey(standardUserDefaultsPtr, key)
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadInteger(key As String) As Integer
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function integerForKey Lib FoundationLib Selector "integerForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As Int32
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    Return integerForKey(standardUserDefaultsPtr, key)
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadString(key As String) As String
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Function stringForKey Lib FoundationLib Selector "stringForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As CFStringRef
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    Return stringForKey(standardUserDefaultsPtr, key)
		    
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadStringArray(key As String) As string()
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function count Lib FoundationLib Selector "count" (NSArray As Ptr) As UInt32
		    Declare Function objectAtIndex Lib FoundationLib Selector "objectAtIndex:" (NSArray As Ptr, index As UInt32) As CFStringRef
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Function stringArrayForKey Lib FoundationLib Selector "stringArrayForKey:" (NSUserDefaults As Ptr, key As CFStringRef) As Ptr
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    Dim stringArrayPtr As Ptr = stringArrayForKey(standardUserDefaultsPtr, key) 
		    Dim count As Integer = count(stringArrayPtr)
		    Dim arr() As String
		    
		    For i As Integer = 0 To count - 1
		      arr.Append(objectAtIndex(stringArrayPtr, i))
		    Next
		    
		    Return arr
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key As String)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Sub removeObjectForKey Lib FoundationLib Selector "removeObjectForKey:" (NSUserDefaults As Ptr, name As CFStringRef)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    removeObjectForKey(standardUserDefaultsPtr, key)
		    
		    Synchronize
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Synchronize()
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Function synchronize Lib FoundationLib Selector "synchronize" (NSUserDefaults As Ptr) As Byte
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    If synchronize(standardUserDefaultsPtr) = 0 Then
		      Raise New RuntimeException   // RuntimeException could be subclassed an deliver more details
		    End
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteBoolean(key as string, value as Boolean)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Sub setBool Lib FoundationLib Selector "setBool:forKey:" (NSUserDefaults As Ptr, value As Byte, key As CFStringRef) 
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    setBool(standardUserDefaultsPtr, If(value, 1, 0), key)
		    
		    Synchronize
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteColor(key as string, value as Color)
		  Dim i As Int32 = Int32(value)
		  
		  WriteInteger(key, i)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDate(key as string, value as date)
		  
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function alloc Lib FoundationLib Selector "alloc" (NSClass As Ptr) As Ptr
		    Declare Function dateFromString Lib FoundationLib Selector "dateFromString:" (NSDateFormatter As Ptr, aString As CFStringRef) As Ptr
		    Declare Function init Lib FoundationLib Selector "init" (NSClass As Ptr) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Function systemTimeZone Lib FoundationLib Selector "systemTimeZone" (NSTimeZone As Ptr) As Ptr
		    Declare Sub setDateFormat Lib FoundationLib Selector "setDateFormat:" (NSDateFormatter As Ptr, Format As CFStringRef)
		    Declare Sub setObject Lib FoundationLib Selector "setObject:forKey:" (NSUserDefaults As Ptr, NSDate As Ptr, key As CFStringRef)
		    Declare Sub setTimeZone Lib FoundationLib Selector "setTimeZone:" (NSDateFormatter As Ptr, NSTimeZone As Ptr)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    Static dateFormatterClassPtr As Ptr = NSClassFromString("NSDateFormatter")
		    Static timeZoneClassPtr As Ptr = NSClassFromString("NSTimeZone")
		    Static systemTimeZonePtr As Ptr = systemTimeZone(timeZoneClassPtr)
		    
		    Dim dataFormatterPtr As Ptr = init(alloc(dateFormatterClassPtr))
		    setDateFormat(dataFormatterPtr, "yyyy-MM-dd HH:mm:ss") 
		    setTimeZone(dataFormatterPtr, systemTimeZonePtr)
		    
		    Dim datePtr As Ptr = dateFromString(dataFormatterPtr, value.SQLDateTime)
		    setObject(standardUserDefaultsPtr, datePtr, key)
		    
		    Synchronize
		    
		  #EndIf
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDateTime(key as string, value as dateTime)
		  
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function alloc Lib FoundationLib Selector "alloc" (NSClass As Ptr) As Ptr
		    Declare Function dateFromString Lib FoundationLib Selector "dateFromString:" (NSDateFormatter As Ptr, aString As CFStringRef) As Ptr
		    Declare Function init Lib FoundationLib Selector "init" (NSClass As Ptr) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Function systemTimeZone Lib FoundationLib Selector "systemTimeZone" (NSTimeZone As Ptr) As Ptr
		    Declare Sub setDateFormat Lib FoundationLib Selector "setDateFormat:" (NSDateFormatter As Ptr, Format As CFStringRef)
		    Declare Sub setObject Lib FoundationLib Selector "setObject:forKey:" (NSUserDefaults As Ptr, NSDate As Ptr, key As CFStringRef)
		    Declare Sub setTimeZone Lib FoundationLib Selector "setTimeZone:" (NSDateFormatter As Ptr, NSTimeZone As Ptr)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    Static dateFormatterClassPtr As Ptr = NSClassFromString("NSDateFormatter")
		    Static timeZoneClassPtr As Ptr = NSClassFromString("NSTimeZone")
		    Static systemTimeZonePtr As Ptr = systemTimeZone(timeZoneClassPtr)
		    
		    Dim dataFormatterPtr As Ptr = init(alloc(dateFormatterClassPtr))
		    setDateFormat(dataFormatterPtr, "yyyy-MM-dd HH:mm:ss") 
		    setTimeZone(dataFormatterPtr, systemTimeZonePtr)
		    
		    Dim datePtr As Ptr = dateFromString(dataFormatterPtr, value.SQLDateTime)
		    setObject(standardUserDefaultsPtr, datePtr, key)
		    
		    Synchronize
		    
		  #EndIf
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDouble(key as string, value as Double)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Sub setDouble Lib FoundationLib Selector "setDouble:forKey:" (NSUserDefaults As Ptr, value As Double, key As CFStringRef)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    setDouble(standardUserDefaultsPtr, value, key)
		    
		    Synchronize
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteInteger(key as string, value as integer)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Sub setInteger Lib FoundationLib Selector "setInteger:forKey:" (NSUserDefaults As Ptr, value As Int32, key As CFStringRef)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    setInteger(standardUserDefaultsPtr, value, key)
		    
		    Synchronize
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteString(key as string, value as String)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Sub setObject Lib FoundationLib Selector "setObject:forKey:" (NSUserDefaults As Ptr, value As CFStringRef, key As CFStringRef)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    
		    setObject(standardUserDefaultsPtr, value, key)
		    
		    Synchronize
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteStringArray(key as string, arr() as string)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib FoundationLib (aClassName As CFStringRef) As Ptr
		    Declare Function alloc Lib FoundationLib Selector "alloc" (NSClass As Ptr) As Ptr
		    Declare Function init Lib FoundationLib Selector "init" (NSClass As Ptr) As Ptr
		    Declare Function standardUserDefaults Lib FoundationLib Selector "standardUserDefaults" (NSUserDefaultsClass As Ptr) As Ptr
		    Declare Sub addObject Lib FoundationLib Selector "addObject:" (NSMutableArrayClass As Ptr, anObject As CFStringRef)
		    Declare Sub setObject Lib FoundationLib Selector "setObject:forKey:" (NSUserDefaults As Ptr, NSArray As Ptr, key As CFStringRef)
		    
		    Static standardUserDefaultsPtr As Ptr = standardUserDefaults(NSClassFromString("NSUserDefaults"))
		    Static mutableArrayClassPtr As Ptr = NSClassFromString("NSMutableArray")
		    
		    Dim mutableArrayPtr As Ptr = init(alloc(mutableArrayClassPtr))
		    
		    For i As Integer = 0 To arr.Ubound
		      addObject(mutableArrayPtr, arr(i))
		    Next
		    
		    setObject(standardUserDefaultsPtr, mutableArrayPtr, key)
		    
		    Synchronize
		    
		  #EndIf
		End Sub
	#tag EndMethod


	#tag Constant, Name = FoundationLib, Type = String, Dynamic = False, Default = \"Foundation", Scope = Protected
	#tag EndConstant


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
End Class
#tag EndClass
