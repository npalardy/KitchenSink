#tag Module
Protected Module Utils
	#tag Method, Flags = &h0
		Function UUID() As String
		  
		  // Tries to use declares to let the native system functions handle this.
		  // Otherwise, falls back to manual creation.
		  
		  Dim result As String
		  
		  Dim useDeclares As Boolean = True
		  
		  Try
		    
		    #If TargetMacOS
		      
		      Soft Declare Function NSClassFromString Lib "Cocoa" ( clsName As cfstringref ) As ptr
		      Soft Declare Function UUID Lib "Cocoa" selector "UUID" ( clsRef As ptr ) As ptr
		      Soft Declare Function UUIDString Lib "Cocoa" selector "UUIDString" ( obj_id As ptr ) As cfstringref
		      
		      Dim classPtr As Ptr = NSClassFromString( "NSUUID" ) 
		      If classPtr = Nil Then
		        useDeclares = False
		      Else
		        Dim NSUUID As ptr = UUID( classPtr )
		        
		        result = UUIDString( NSUUID )
		      End If
		      
		    #ElseIf TargetWindows
		      
		      Const kLibName = "rpcrt4"
		      
		      If Not System.IsFunctionAvailable( "UuidCreate", kLibName ) Then
		        useDeclares = False
		      Elseif Not System.IsFunctionAvailable( "UuidToStringA", kLibName ) Then
		        useDeclares = False
		      Else
		        Soft Declare Function UUIDCreate Lib kLibName alias "UuidCreate" ( ByRef uuid As WindowsUUID ) As Integer
		        Soft Declare Function UUIDToString Lib kLibName alias "UuidToStringA" ( ByRef inUUID As WindowsUUID, ByRef outString As CString ) As Integer
		        
		        Dim uuid As WindowsUUID
		        If UUIDCreate( uuid ) <> 0 Then
		          useDeclares = False
		        Else
		          Dim out As CString
		          If UUIDToString( uuid, out ) <> 0 Then
		            useDeclares = False
		          Else
		            result = out
		            result = result.DefineEncoding( Encodings.UTF8 )
		            result = result.Uppercase
		          End If
		          
		        End If
		      End If
		      
		    #ElseIf TargetLinux
		      
		      Const kLibName = "uuid"
		      
		      If Not System.IsFunctionAvailable( "uuid_generate", kLibName ) Then
		        useDeclares = False
		      Elseif Not System.IsFunctionAvailable( "uuid_unparse_upper", kLibName ) Then
		        useDeclares = False
		      Else
		        Soft Declare Sub UUIDGenerate Lib kLibName alias "uuid_generate" ( ByRef uuid As LinuxUUID )
		        Soft Declare Sub UUIDUnparse Lib kLibName alias "uuid_unparse_upper" ( ByRef uuid As LinuxUUID, ByRef out As LinuxUUIDString )
		        
		        Dim uuid As LinuxUUID
		        UUIDGenerate( uuid )
		        
		        Dim out As LinuxUUIDString
		        UUIDUnparse( uuid, out )
		        
		        result = out.Data
		        result = result.DefineEncoding( Encodings.UTF8 )
		      End If
		      
		    #Else
		      useDeclares = False
		    #EndIf
		    
		  Catch err As RuntimeException
		    useDeclares = False
		    If err IsA EndException Or err IsA ThreadEndException Then
		      Raise err
		    End If
		  End Try
		  
		  If Not useDeclares Then
		    //
		    // Fallback to manual creation
		    //
		    // From http://www.cryptosys.net/pki/uuid-rfc4122.html
		    //
		    // Generate 16 random bytes (=128 bits)
		    // Adjust certain bits according to RFC 4122 section 4.4 as follows:
		    // set the four most significant bits of the 7th byte to 0100'B, so the high nibble is '4'
		    // set the two most significant bits of the 9th byte to 10'B, so the high nibble will be one of '8', '9', 'A', or 'B'.
		    // Convert the adjusted bytes to 32 hexadecimal digits
		    // Add four hyphen '-' characters to obtain blocks of 8, 4, 4, 4 and 12 hex digits
		    // Output the resulting 36-character string "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
		    //
		    
		    #Pragma BackgroundTasks False
		    #Pragma BoundsChecking False
		    #Pragma NilObjectChecking False
		    
		    Dim Logger As debug.logger = CurrentMethodName
		    
		    Dim randomBytes As MemoryBlock = Crypto.GenerateRandomBytes( 16 )
		    randomBytes.LittleEndian = False
		    Dim p As Ptr = randomBytes
		    
		    //
		    // Adjust seventh byte
		    //
		    Dim value As Byte = p.Byte( 6 )
		    value = value And CType( &b00001111, Byte ) // Turn off the first four bits
		    value = value Or CType( &b01000000, Byte ) // Turn on the second bit
		    p.Byte(6) = value
		    
		    //
		    // Adjust ninth byte
		    //
		    value = p.Byte( 8 )
		    value = value And CType( &b00111111, Byte ) // Turn off the first two bits
		    value = value Or CType( &b10000000, Byte ) // Turn on the first bit
		    p.Byte( 8 ) = value
		    
		    result = EncodeHex( randomBytes )
		    result = result.LeftB( 8 ) + "-" + result.MidB( 9, 4 ) + "-" + result.MidB( 13, 4 ) + "-" + result.MidB( 17, 4 ) + _
		    "-" + result.RightB( 12 )
		  End If
		  
		  Return result
		  
		  
		End Function
	#tag EndMethod


	#tag Structure, Name = LinuxUUID, Flags = &h21
		Bytes1 As String * 4
		  Bytes2 As String * 2
		  Bytes3 As String * 2
		  Bytes4 As String * 2
		Bytes5 As String * 6
	#tag EndStructure

	#tag Structure, Name = LinuxUUIDString, Flags = &h21
		Data As String * 36
		TrailingNull As String * 1
	#tag EndStructure

	#tag Structure, Name = WindowsUUID, Flags = &h21
		Data1 As UInt32
		  Data2 As UInt16
		  Data3 As UInt16
		Data4 As String * 8
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
