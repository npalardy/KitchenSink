#tag Module
Protected Module Preferences
	#tag Method, Flags = &h1
		Protected Sub Finalize()
		  // Notifications.RemoveSubscriber(m_NotificationReceiver)
		  
		  If m_NotificationReceiver <> nil then
		    RemoveHandler m_NotificationReceiver.Notified, AddressOf NotificationHandler
		  End If
		  
		  m_NotificationReceiver = Nil
		  
		  m_PrefsImplementation = Nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default as boolean) As boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default as Color) As Color
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default as Date) As Date
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default as DateTime) As DateTime
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default as Double) As Double
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default as Int32) As Int32
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default as Int64) As Int64
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default() as string) As String()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Get(key as String, default as String) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(key as String) As Boolean
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  Return m_PrefsImplementation.HasKey(key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitPrefsInstance()
		  
		  If m_PrefsImplementation Is Nil Then
		    
		    #If TargetMacOS
		      m_PrefsImplementation = New MacOSPrefs 
		    #ElseIf TargetWindows
		      m_PrefsImplementation = New WindowsPrefs 
		    #ElseIf TargetLinux
		      m_PrefsImplementation = New LinuxPrefs(  ) 
		    #EndIf
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub NotificationHandler(instance as NotificationReceiver, message as string, payload as variant)
		  #Pragma unused instance
		  #Pragma unused message
		  #pragma unused payload 
		  
		  // ok so we got Notified 
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadBoolean(key as String) As Boolean
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadBoolean(key)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadBoolean(key as String, default as boolean) As Boolean
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadBoolean(key)
		  Else
		    return default
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadColor(key As String) As Color
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadColor(key)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadColor(key as String, default as color) As Color
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadColor(key)
		  Else
		    Return default
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDate(key As String) As Date
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadDate(key)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDate(key as String, default as date) As Date
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadDate(key)
		  Else
		    return default
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDateTime(key As String) As DateTime
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadDateTime(key)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDateTime(key as String, default as DateTime) As DateTime
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadDateTime(key)
		  Else
		    return default
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDouble(key As String) As Double
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadDouble(key)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDouble(key as String, default as double) As Double
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadDouble(key)
		  Else
		    Return default
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadInteger(key As String) As Integer
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadInteger(key)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadInteger(key as String, default as integer) As Integer
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadInteger(key)
		  Else
		    Return default
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadString(key As String) As String
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadString(key)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadString(key as String, default as string) As String
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadString(key)
		  Else
		    Return default
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadStringArray(key As String) As string()
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadStringArray(key)
		  End If
		  
		  Dim empty() As astring
		  Return empty
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadStringArray(key as String, default() as string) As string()
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  If m_PrefsImplementation.HasKey(key) Then
		    Return m_PrefsImplementation.ReadStringArray(key)
		  Else
		    Return default
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key As String)
		  #Pragma unused key
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.Remove(key)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  
		  #If debugbuild
		    Dim Logger As debug.logger = CurrentMethodName
		    
		    InitPrefsInstance
		    
		    If True Then
		      Dim key As String = "testBoolean"
		      Dim initial As Boolean = True
		      m_PrefsImplementation.WriteBoolean(key, initial)
		      Dim result As Boolean = m_PrefsImplementation.ReadBoolean(key)
		      debug.Assert result = initial, CurrentMethodName + " " + key + " did not match"
		      If m_PrefsImplementation.HasKey(key) Then
		        m_PrefsImplementation.Remove(key)
		      Else
		        Break
		      End If
		    End If
		    
		    If True Then
		      Dim key As String = "testColor"
		      Dim initial As Color = &c12345678
		      m_PrefsImplementation.WriteColor(key, initial)
		      Dim result As Color = m_PrefsImplementation.ReadColor(key)
		      debug.Assert result = initial, CurrentMethodName  + " " + key + " did not match"
		      If m_PrefsImplementation.HasKey(key) Then
		        m_PrefsImplementation.Remove(key)
		      Else
		        Break
		      End If
		    End If
		    
		    If True Then
		      Dim key As String = "testDate"
		      Dim initial As date = New Date(2033, 01, 02, 03, 04, 05, 06)
		      m_PrefsImplementation.WriteDate(key, initial )
		      Dim result As Date = m_PrefsImplementation.ReadDate(key)
		      // object comparison so have to compare total seconds or something else
		      debug.Assert result.TotalSeconds = initial.TotalSeconds, CurrentMethodName  + " " + key + " did not match wrote " + initial.SQLDateTime + " got " + result.SQLDateTime
		      If m_PrefsImplementation.HasKey(key) Then
		        m_PrefsImplementation.Remove(key)
		      Else
		        Break
		      End If
		    End If
		    
		    If True Then
		      Dim key As String = "testDateTime"
		      Dim initial As DateTime = New DateTime(2033, 01, 02, 03, 04, 05, 06)
		      m_PrefsImplementation.WriteDateTime(key, initial )
		      Dim result As DateTime = m_PrefsImplementation.ReadDateTime(key)
		      // object comparison so have to compare total seconds or something else
		      debug.Assert result.SecondsFrom1970 = initial.SecondsFrom1970, CurrentMethodName  + " " + key + " did not match wrote " + initial.SQLDateTime + " got " + result.SQLDateTime
		      If m_PrefsImplementation.HasKey(key) Then
		        m_PrefsImplementation.Remove(key)
		      Else
		        Break
		      End If
		    End If
		    
		    If True Then
		      Dim key As String = "testDouble"
		      Dim initial As Double = 12.345
		      m_PrefsImplementation.WriteDouble(key, initial )
		      Dim result As Double = m_PrefsImplementation.ReadDouble(key)
		      debug.Assert result = initial, CurrentMethodName  + " " + key + " did not match"
		      If m_PrefsImplementation.HasKey(key) Then
		        m_PrefsImplementation.Remove(key)
		      Else
		        Break
		      End If
		    End If
		    
		    If True Then
		      Dim key As String = "testInteger"
		      Dim initial As Integer = 838381
		      m_PrefsImplementation.WriteInteger(key, initial )
		      Dim result As Integer = m_PrefsImplementation.ReadInteger(key)
		      debug.Assert result = initial, CurrentMethodName  + " " + key + " did not match"
		      If m_PrefsImplementation.HasKey(key) Then
		        m_PrefsImplementation.Remove(key)
		      Else
		        Break
		      End If
		    End If
		    
		    If True Then
		      Dim key As String = "testString"
		      Dim initial As String = "this is a test of the emergncy ... never mind" 
		      m_PrefsImplementation.WriteString(key, initial )
		      Dim result As String = m_PrefsImplementation.ReadString(key)
		      debug.Assert result = initial, CurrentMethodName  + " " + key + " did not match"
		      If m_PrefsImplementation.HasKey(key) Then
		        m_PrefsImplementation.Remove(key)
		      Else
		        Break
		      End If
		    End If
		    
		    If True Then
		      Dim key As String = "testStringArray"
		      Dim initial() As String = Array("1", "2", "3") 
		      m_PrefsImplementation.WriteStringArray(key, initial )
		      Dim result() As String = m_PrefsImplementation.ReadStringArray(key)
		      // in this case we need to compare ARRAYS
		      debug.Assert result.Equals(initial), CurrentMethodName  + " " + key + " did not match"
		      If m_PrefsImplementation.HasKey(key) Then
		        m_PrefsImplementation.Remove(key)
		      Else
		        Break
		      End If
		    End If
		    
		    If True Then
		      Dim key As String = "FOOBAR"
		      
		      debug.Assert  m_PrefsImplementation.HasKey(key) = false, CurrentMethodName + "found " + key + " but should not have"
		      
		    End If
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, value as Boolean)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteBoolean(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, value as Color)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteColor(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, value as date)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteDate(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, value as DateTime)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteDateTime(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, value as Double)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteDouble(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, value as int32)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteInteger(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, value as int64)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteInteger(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, arr() as string)
		  #Pragma unused key
		  #Pragma unused arr
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteStringArray(key, arr)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(key as string, value as String)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteString(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteBoolean(key as string, value as Boolean)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteBoolean(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDate(key as string, value as date)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteDate(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDateTime(key as string, value as DateTime)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteDateTime(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDouble(key as string, value as Double)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteDouble(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteInteger(key as string, value as integer)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteInteger(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteString(key as string, value as String)
		  #Pragma unused key
		  #Pragma unused value
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteString(key, value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteStringArray(key as string, arr() as string)
		  #Pragma unused key
		  #Pragma unused arr
		  
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteStringArray(key, arr)
		End Sub
	#tag EndMethod


	#tag Note, Name = Using this module
		Make sure, for Windows, you set the Constant kAppDesigner to your companies name or something
		You cant, unfortunately, use another constant to set this :(
		
		Add PROPERTIES to this module for your usage
		
		Those properties should just call into the vrious methods on m_PrefsImplementation
		to read/write the preference to the proper OS repository
		
		Stylistically each GET or SET should look like
		
		Protected Property <PropertyName> as <Type>
		Get
		  InitPrefsInstance
		  
		  If hasKey("PropertyName") Then
		    Return m_PrefsImplementation.ReadBoolen("PropertyName")
		  Else
		    Return true
		  End If
		  
		End Get
		
		Set
		  InitPrefsInstance
		  
		  m_PrefsImplementation.WriteBoolean("PropertyName", value)
		  
		End Set
		
		End Property
		
		would be nice to use introspection etc but since this is a module there is no option to do this
		
		
		You can set the Preferences module up to notice things like macOS theme chnages etc
		See InitPrefsInstance where a notification receiver can be created, and then a handler for it set up 
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private m_NotificationReceiver As NotificationReceiver
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_PrefsImplementation As Preferences.BasePrefs
	#tag EndProperty


	#tag Constant, Name = kAppDesigner, Type = String, Dynamic = False, Default = \"kAppDesigner", Scope = Protected
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
End Module
#tag EndModule
