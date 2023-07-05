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

	#tag Method, Flags = &h21
		Private Function HasKeyX(key as String) As boolean
		  InitPrefsInstance
		  
		  return m_PrefsImplementation.hasKey(key)
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
		      // object comparison so have to compare total sedons or something else
		      debug.Assert result.TotalSeconds = initial.TotalSeconds, CurrentMethodName  + " " + key + " did not match wrote " + initial.SQLDateTime + " got " + result.SQLDateTime
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
