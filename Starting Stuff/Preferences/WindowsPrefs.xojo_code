#tag Class
Private Class WindowsPrefs
Inherits Preferences.BasePrefs
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(key as String) As Boolean
		  #Pragma unused key
		  
		  #If TargetWindows
		    // see if we can get the variant for this key
		    
		    #Pragma BreakOnExceptions False
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      Dim v As Variant = reg.Value(key)
		      
		      #Pragma BreakOnExceptions Default
		      
		      return v <> nil
		      
		    Catch rax As RegistryAccessErrorException
		      
		      #Pragma BreakOnExceptions Default
		      
		      Return False
		      
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadBoolean(key as String) As Boolean
		  #Pragma unused key
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      Dim b As Boolean = reg.Value(key).BooleanValue
		      
		      Return b
		      
		    Catch rax As RegistryAccessErrorException
		      Return False
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadColor(key As String) As Color
		  #Pragma unused key
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      Dim c As Color = reg.Value(key).ColorValue
		      
		      Return c
		      
		    Catch rax As RegistryAccessErrorException
		      
		      Return &c000000
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDate(key As String) As Date
		  #Pragma unused key
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      Dim d As Date = reg.Value(key).DateValue
		      
		      Return d
		      
		    Catch rax As RegistryAccessErrorException
		      Return nil
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDateTime(key As String) As DateTime
		  #Pragma unused key
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      Dim d As DateTime = reg.Value(key).DateTimeValue
		      
		      Return d
		      
		    Catch rax As RegistryAccessErrorException
		      Return nil
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDouble(key As String) As Double
		  #Pragma unused key
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      Dim d As Double = reg.Value(key).DoubleValue
		      
		      Return d
		      
		    Catch rax As RegistryAccessErrorException
		      Return 0.0
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadInteger(key As String) As Integer
		  #Pragma unused key
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      Dim i As Integer = reg.Value(key).IntegerValue
		      
		      Return i
		      
		    Catch rax As RegistryAccessErrorException
		      Return 0
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadString(key As String) As String
		  #Pragma unused key
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      Dim s As String = reg.Value(key).StringValue
		      
		      Return s
		      
		    Catch rax As RegistryAccessErrorException
		      Return ""
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadStringArray(key As String) As string()
		  #Pragma unused key
		  
		  #If TargetWindows
		    // read a multi-string
		    
		    Dim arr() As String
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      arr = Split(reg.Value(key), ChrB(0))
		      
		      If arr.ubound >= 0 Then
		        arr.remove arr.Ubound
		      End If
		      
		      Return arr
		      
		    Catch rax As RegistryAccessErrorException
		      Return arr
		    End Try
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key As String)
		  #Pragma unused key
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , False)
		      
		      If reg <> Nil Then
		        reg.Delete(key)
		      End If
		      
		    Catch rax As RegistryAccessErrorException
		      
		    End Try
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteBoolean(key as string, value as Boolean)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , True)
		      
		      reg.Value(key) = value
		      
		    Catch rax As RegistryAccessErrorException
		      
		    End Try
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteColor(key as string, value as Color)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , True)
		      
		      reg.Value(key) = value
		      
		    Catch rax As RegistryAccessErrorException
		      
		    End Try
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDate(key as string, value as datetime)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , True)
		      
		      reg.Value(key) = value
		      
		    Catch rax As RegistryAccessErrorException
		      
		    End Try
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDouble(key as string, value as Double)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , True)
		      
		      reg.Value(key) = value
		      
		    Catch rax As RegistryAccessErrorException
		      
		    End Try
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteInteger(key as string, value as integer)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , True)
		      
		      reg.Value(key) = value
		      
		    Catch rax As RegistryAccessErrorException
		      
		    End Try
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteString(key as string, value as String)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetWindows
		    // Get a registry key
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , True)
		      
		      reg.Value(key) = value
		      
		    Catch rax As RegistryAccessErrorException
		      
		    End Try
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteStringArray(key as string, arr() as string)
		  #Pragma unused key
		  #Pragma unused arr
		  
		  #If TargetWindows
		    // write a multi-string
		    
		    Try
		      Dim reg As New RegistryItem(kCurrentUserSoftwareKey + Preferences.kAppDesigner + "\" + App.Name , True)
		      
		      Dim value As String 
		      
		      For Each s As String In arr()
		        value = value + CType(s, WString)
		      Next s
		      
		      reg.Value(key) = CType(value, MemoryBlock)
		      
		    Catch rax As RegistryAccessErrorException
		      
		    End Try
		    
		  #EndIf
		End Sub
	#tag EndMethod


	#tag Constant, Name = kCurrentUserSoftwareKey, Type = String, Dynamic = False, Default = \"HKEY_CURRENT_USER\\Software\\", Scope = Protected
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
