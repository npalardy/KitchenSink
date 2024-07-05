#tag Class
Private Class LinuxPrefs
Inherits Preferences.BasePrefs
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  init
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertBooleanArray(boolArray as Variant) As JSONItem
		  Dim b() As Boolean 
		  b = boolArray
		  
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertColorArray(colorArray as Variant) As JSONItem
		  Dim c() As Color 
		  
		  c = colorArray
		  
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertDateArray(dateArray as Variant) As JSONItem
		  Dim d() As Date 
		  d = dateArray
		  
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertDoubleArray(doubleArray as Variant) As JSONItem
		  Dim d() As Double 
		  d = doubleArray
		  
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertInt32Array(int32Array as Variant) As JSONItem
		  Dim i() As Int32 
		  i = int32Array
		  
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertInt64Array(int64Array as Variant) As JSONItem
		  Dim i() As Int64
		  i = int64Array
		  
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertStringArray(stringArray as Variant) As JSONItem
		  Dim sArray() As String = stringArray
		  
		  Dim j As New jsonItem
		  
		  Break
		  
		  For Each s As String In sArray
		    j.add s
		  Next
		  
		  Return j
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(key as String) As Boolean
		  #Pragma unused key
		  
		  #If TargetLinux
		    Init
		    
		    Return mPrefsDict.HasKey( key )
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Init()
		  #If TargetLinux
		    Try
		      If mPrefsDict is nil then
		        mPrefsDict = New dictionary
		      End If
		      
		      mPrefsFile = SpecialFolder.UserHome.Child("." + App.Name + ".settings")
		      
		      If mPrefsFile <> Nil And mPrefsFile.IsFolder = False And mPrefsFile.Exists = True Then
		        // read in the json we use
		        // and then we'll keep thing in sync
		        
		        Dim Input As TextInputStream = TextInputStream.Open( mPrefsFile )
		        
		        Input.Encoding = Encodings.UTF8
		        
		        Dim lJson As JSONItem = New JSONItem(Input.ReadAll)
		        
		      End If
		      
		    Catch noe As NilObjectException
		      mPrefsFile = Nil
		      mFileNotFound = True
		    Catch iox As IOException
		      mPrefsFile = Nil
		      mFileNotFound = True
		    End Try
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadBoolean(key as String) As Boolean
		  #Pragma unused key
		  
		  #If TargetLinux
		    
		    Dim v As Variant = mPrefsDict.Lookup( key, False )
		    
		    Return v.BooleanValue
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadColor(key As String) As Color
		  #Pragma unused key
		  
		  #If TargetLinux
		    
		    // colors dont exist in JSON so they have been converted to int32's
		    // we need to convert them back
		    Dim v As Variant = mPrefsDict.Lookup( key, 0 )
		    
		    Return Color(v.Int32Value)
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDate(key As String) As Date
		  #Pragma unused key
		  
		  #If TargetLinux
		    Dim d As date
		    
		    Dim v As Variant = mPrefsDict.Lookup( key, Nil )
		    
		    If (v Is Nil) = False Then
		      d = New Date
		      d.TotalSeconds = v.DoubleValue
		    End If
		    
		    Return d
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDateTime(key As String) As DateTime
		  #Pragma unused key
		  
		  #If TargetLinux
		    Dim d As datetime
		    
		    Dim v As Variant = mPrefsDict.Lookup( key, Nil )
		    
		    If (v Is Nil) = False Then
		      d = DateTime.FromString(v.StringValue)
		    End If
		    
		    Return d
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadDouble(key As String) As Double
		  #Pragma unused key
		  
		  #If TargetLinux
		    
		    Dim v As Variant = mPrefsDict.Lookup( key, 0 )
		    
		    Return v.DoubleValue
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadInteger(key As String) As Integer
		  #Pragma unused key
		  
		  #If TargetLinux
		    
		    Dim v As Variant = mPrefsDict.Lookup( key, 0 )
		    
		    Return v.IntegerValue
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadString(key As String) As String
		  #Pragma unused key
		  
		  #If TargetLinux
		    
		    Dim v As Variant = mPrefsDict.Lookup( key, "" )
		    
		    Return v.StringValue
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadStringArray(key As String) As string()
		  #Pragma unused key
		  
		  #If TargetLinux
		    
		    Dim Default() As String
		    
		    Dim v As Variant = mPrefsDict.Lookup( key, Nil )
		    
		    If v <> Nil Then
		      default = v
		    End If
		    
		    Return Default
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key As String)
		  #Pragma unused key
		  
		  #If TargetLinux
		    
		    mPrefsDict.Remove( key )
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Synchronize()
		  #If TargetLinux
		    
		    Dim s As String
		    Dim j As New JSONItem 
		    
		    For Each key As String In mPrefsDict.Keys
		      
		      Dim value As Variant = mPrefsDict.Value(key)
		      
		      If value.IsArray Then
		        Break
		        
		        
		        Select Case value.ArrayElementType
		          
		        Case Variant.TypeArray
		          Break
		        Case Variant.TypeBoolean
		          j.value(key) = ConvertBooleanArray( value )
		        Case Variant.TypeColor
		          j.value(key) = ConvertColorArray( value )
		        Case Variant.TypeDate
		          j.value(key) = ConvertDateArray( value )
		        Case Variant.TypeDouble
		          j.value(key) = ConvertDoubleArray( value )
		        Case Variant.TypeInt32
		          j.value(key) = ConvertInt32Array( value )
		        Case Variant.TypeInt64
		          j.value(key) = ConvertInt64Array( value )
		        Case Variant.TypeObject
		          Break
		        Case Variant.TypeString
		          j.value(key) = ConvertStringArray( value )
		        Else
		          Break
		        End Select
		        
		      Else
		        
		        Select Case value.Type
		        Case Variant.TypeArray
		          Break
		        Case Variant.TypeBoolean
		          j.value(key) = value
		        Case Variant.TypeColor
		          j.value(key) = value
		        Case Variant.TypeDate
		          j.value(key) = value
		        Case Variant.TypeDouble
		          j.value(key) = value
		        Case Variant.TypeInt32
		          j.value(key) = value
		        Case Variant.TypeInt64
		          j.value(key) = value
		        Case Variant.TypeObject
		          Break
		        Case Variant.TypeString
		          j.value(key) = value
		        Else
		          Break
		        End Select
		      End If
		    Next
		    
		    s = j.ToString
		    
		    Dim outputStream As TextOutputStream 
		    If mPrefsFile Is Nil Then
		      Break
		    Else
		      outputStream = TextOutputStream.Create( mPrefsFile )
		    End If
		    
		    outputStream.Write j.ToString
		    
		    outputStream = Nil
		    
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteBoolean(key as string, value as Boolean)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetLinux
		    
		    mPrefsDict.value( key ) = value
		    
		    Synchronize
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteColor(key as string, value as Color)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetLinux
		    
		    mPrefsDict.value( key ) = Int32(value)
		    
		    Synchronize
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDate(key as string, value as date)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetLinux
		    
		    mPrefsDict.value( key ) = value.TotalSeconds
		    
		    Synchronize
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDateTime(key as string, value as dateTime)
		  
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetLinux
		    
		    mPrefsDict.value( key ) = value.SQLDateTime
		    
		    Synchronize
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteDouble(key as string, value as Double)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetLinux
		    
		    mPrefsDict.value( key ) = value
		    
		    Synchronize
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteInteger(key as string, value as integer)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetLinux
		    
		    mPrefsDict.value( key ) = value
		    
		    Synchronize
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteString(key as string, value as String)
		  #Pragma unused key
		  #Pragma unused value
		  
		  #If TargetLinux
		    
		    mPrefsDict.value( key ) = value
		    
		    Synchronize
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteStringArray(key as string, arr() as string)
		  #Pragma unused key
		  #Pragma unused arr
		  
		  #If TargetLinux
		    
		    mPrefsDict.value( key ) = arr
		    
		    Synchronize
		    
		  #endif
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mFileNotFound As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPrefsDict As dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPrefsFile As Folderitem
	#tag EndProperty


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
