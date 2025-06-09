#tag Module
Protected Module DateTimeExtensions
	#tag Method, Flags = &h0
		Attributes( Deprecated )  Function ISO8601DateTimeStr(d as dateTime) As string
		  
		  Return d.ISO8601DateTimeStr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Deprecated )  Function ISO8601DateTimeStr(extends d as DateTime) As string
		  // formats a date as yyyy-MM-DD HH:MM:SS [+/-]hh:mm
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

	#tag Method, Flags = &h1
		Protected Function ISO8601DateTimeString(d as datetime) As string
		  // returns a string like "2017-03-22T16:28:08±hh:mm"
		  Dim tmp() As String
		  
		  tmp.append d.Year.ToString(Nil, "0000")
		  tmp.append "-"
		  tmp.append d.Month.ToString(Nil, "00")
		  tmp.append "-"
		  tmp.append d.Day.ToString(Nil, "00")
		  tmp.append "T"
		  tmp.append d.Hour.ToString(Nil, "00")
		  tmp.append ":"
		  tmp.append d.Minute.ToString(Nil, "00")
		  tmp.append ":"
		  tmp.append d.Second.ToString(Nil, "00")
		  
		  dim tz as TimeZone = d.Timezone
		  If tz Is Nil Or tz.SecondsFromGMT = 0 Then
		    tmp.append "Z"
		  Else
		    Dim Sign As String
		    If tz.SecondsFromGMT >= 0 Then
		      tmp.append "+"
		    Else
		      tmp.append "-"
		    End If
		    Dim totalSeconds As Integer = Abs(tz.SecondsFromGMT)
		    Dim gmtOffsetHours As Integer = totalSeconds / 3600
		    Dim gmtOffsetMinutes As Integer = (totalSeconds - (gmtOffsetHours * 3600)) / 60
		    
		    
		    tmp.append gmtOffsetHours.ToString(Nil, "#0")
		    tmp.append ":"
		    tmp.append gmtOffsetMinutes.ToString(Nil, "#0")
		  End If
		  
		  Return Join(tmp,"")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ISO8601DateTimeString(extends d as datetime) As string
		  // returns a string like "2017-03-22T16:28:08±hh:mm"
		  Dim tmp() As String
		  
		  tmp.append d.Year.ToString(Nil, "0000")
		  tmp.append "-"
		  tmp.append d.Month.ToString(Nil, "00")
		  tmp.append "-"
		  tmp.append d.Day.ToString(Nil, "00")
		  tmp.append "T"
		  tmp.append d.Hour.ToString(Nil, "00")
		  tmp.append ":"
		  tmp.append d.Minute.ToString(Nil, "00")
		  tmp.append ":"
		  tmp.append d.Second.ToString(Nil, "00")
		  
		  dim tz as TimeZone = d.Timezone
		  If tz Is Nil Or tz.SecondsFromGMT = 0 Then
		    tmp.append "Z"
		  Else
		    Dim Sign As String
		    If tz.SecondsFromGMT >= 0 Then
		      tmp.append "+"
		    Else
		      tmp.append "-"
		    End If
		    Dim totalSeconds As Integer = Abs(tz.SecondsFromGMT)
		    Dim gmtOffsetHours As Integer = totalSeconds / 3600
		    Dim gmtOffsetMinutes As Integer = (totalSeconds - (gmtOffsetHours * 3600)) / 60
		    
		    
		    tmp.append gmtOffsetHours.ToString(Nil, "#0")
		    tmp.append ":"
		    tmp.append gmtOffsetMinutes.ToString(Nil, "#0")
		  End If
		  
		  Return Join(tmp,"")
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
		    
		    
		    // 2023-11-15 16:35:0 -07:00
		    resetDateTime = New datetime(2023, 11, 15, 16, 35, 0, 0, New Timezone(-25200) )
		    s = resetDateTime.ToISO8601
		    If s <> "2023-11-15 16:35:00 -07:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    // 2023-11-15 16:35:0 +00:00
		    resetDateTime = New datetime(2023, 11, 15, 16, 35, 0, 0, New Timezone(0) )
		    s = resetDateTime.ToISO8601
		    If s <> "2023-11-15 16:35:00 +00:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    // 2023-11-15 16:35:0 +07:00
		    resetDateTime = New datetime(2023, 11, 15, 16, 35, 0, 0, New Timezone(25200) )
		    s = resetDateTime.ToISO8601
		    If s <> "2023-11-15 16:35:00 +07:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    
		    // 2024-12-31
		    TestDateTimeToISO8601DateStr
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestDateTimeToISO8601DateStr()
		  #If DebugBuild
		    
		    If True Then
		      Dim d As New datetime(2000,1,7,14,45,15,0,New timezone(0))
		      
		      Dim s As String =  d.ISO8601DateTimeString
		      
		      If s <> "2000-01-07T14:45:15Z" Then 
		        Break
		      End If
		      
		      s =  ISO8601DateTimeString(d)
		      
		      If s <> "2000-01-07T14:45:15Z" Then 
		        Break
		      End If
		      
		    End If
		    
		    
		    
		    If True Then
		      Dim d As New datetime(2000,1,7,14,45,15,0,New timezone(5400))
		      
		      Dim s As String =  d.ISO8601DateTimeString
		      
		      If s <> "2000-01-07T14:45:15+1:30" Then
		        Break
		      End If
		      
		      s =  ISO8601DateTimeString(d)
		      
		      If s <> "2000-01-07T14:45:15+1:30" Then
		        Break
		      End If
		      
		    End If
		    
		    
		    
		    If True Then
		      Dim d As New datetime(2000,1,7,14,45,15,0,New timezone(-5400))
		      
		      Dim s As String =  d.ISO8601DateTimeString
		      
		      If s <> "2000-01-07T14:45:15-1:30" Then
		        Break
		      End If
		      
		      s =  ISO8601DateTimeString(d)
		      If s <> "2000-01-07T14:45:15-1:30" Then
		        Break
		      End If
		      
		    End If
		    
		    
		    
		    If True Then
		      Dim d As New datetime(2000,1,7,4,5,1,0,New timezone(0))
		      
		      Dim s As String =  d.ISO8601DateTimeString
		      
		      If s <> "2000-01-07T04:05:01Z" Then 
		        Break
		      End If
		      
		      s =  ISO8601DateTimeString(d)
		      If s <> "2000-01-07T04:05:01Z" Then 
		        Break
		      End If
		      
		    End If
		    
		    
		    
		    If True Then
		      Dim d As New datetime(2000,1,7,4,5,1,0,New timezone(5400))
		      
		      Dim s As String =  d.ISO8601DateTimeString
		      
		      If s <> "2000-01-07T04:05:01+1:30" Then
		        Break
		      End If
		      
		      s =  ISO8601DateTimeString(d)
		      If s <> "2000-01-07T04:05:01+1:30" Then
		        Break
		      End If
		      
		    End If
		    
		    
		    
		    If True Then
		      Dim d As New datetime(2000,1,7,4,5,1,0,New timezone(-5400))
		      
		      Dim s As String =  d.ISO8601DateTimeString
		      
		      If s <> "2000-01-07T04:05:01-1:30" Then
		        Break
		      End If
		      
		      s =  ISO8601DateTimeString(d)
		      If s <> "2000-01-07T04:05:01-1:30" Then
		        Break
		      End If
		      
		    End If
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Deprecated = "ISO8601DateTimeString" )  Function ToISO8601(extends d as datetime) As string
		  Return DateTimeExtensions.ISO8601DateTimeStr(d)
		  
		End Function
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
