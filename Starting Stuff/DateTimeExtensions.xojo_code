#tag Module
Protected Module DateTimeExtensions
	#tag Method, Flags = &h0
		Function ISO8601DateTimeStr(d as dateTime) As string
		  
		  Return d.ISO8601DateTimeStr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ISO8601DateTimeStr(extends d as DateTime) As string
		  // formats a date as YYYY-MM-DD HH:MM:SS [+/-]hh:mm
		  // hh is HOURS offset from GMT
		  // mm is minutes offset from GMT
		  
		  Dim s As String 
		  
		  Dim hours As Integer
		  Dim mins As Integer
		  
		  hours = d.Timezone.SecondsFromGMT / (60 * 60)
		  mins = (d.Timezone.SecondsFromGMT - (hours * 60 * 60)) \ 60
		  
		  hours = Abs(hours)
		  mins = Abs(mins)
		  
		  s = s + d.SQLDateTime
		  s = s +  " " + If(d.Timezone.SecondsFromGMT < 0, "-" , "+") + Format(hours,"00") + ":" + Format(mins,"00")
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunUnitTests()
		  #If DebugBuild
		    
		    Dim resetDateTime As DateTime
		    Dim s As String
		    
		    
		    // 2023-11-15 16:35:0 -07:00
		    resetDateTime = New datetime(2023, 11, 15, 16, 35, 0, 0, New Timezone(-25200) )
		    s = ISO8601DateTimeStr(resetDateTime)
		    
		    If s <> "2023-11-15 16:35:00 -07:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    // 2023-11-15 16:35:0 +00:00
		    resetDateTime = New datetime(2023, 11, 15, 16, 35, 0, 0, New Timezone(0) )
		    s = ISO8601DateTimeStr(resetDateTime)
		    If s <> "2023-11-15 16:35:00 +00:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    // 2023-11-15 16:35:0 +07:00
		    resetDateTime = New datetime(2023, 11, 15, 16, 35, 0, 0, New Timezone(25200) )
		    s = ISO8601DateTimeStr(resetDateTime)
		    
		    If s <> "2023-11-15 16:35:00 +07:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod


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
