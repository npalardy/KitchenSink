#tag Module
Protected Module StringExtensions
	#tag Method, Flags = &h0
		Function CompareVerionsCodes(extends selfString as string, otherVersionString as string) As integer
		  Const kSelfLessThanOther = -1
		  Const kSelfEqualOther = 0
		  Const kSelfGreaterThanOther = 1
		  
		  // consistent with operator_compare 
		  // Operator_Compare returns an integer whose meaning is as follows: 
		  //  < 0 means that selfString is less than otherVersionString
		  //  0 means that selfString is equal to otherVersionString
		  // and > 0 means that selfString is greater than otherVersionString
		  
		  // may raise UnsupportedOperationException if version string are not digts & decimal points only
		  
		  // version codes should be
		  //   non-empty
		  //   composed ONLY of digits & periods
		  
		  Dim selfCodes() As String = selfString.Split(".")
		  Dim otherVersionCode() As String = otherVersionString.Split(".") 
		  
		  For i As Integer = 0 To selfcodes.Ubound
		    If selfCodes(i).IsInteger = False Then
		      #Pragma BreakOnExceptions False
		      Dim tmp As New UnsupportedOperationException
		      tmp.Message = "version comparison strings should only use digits and decimal points"
		      Raise tmp
		    End If
		  Next
		  For i As Integer = 0 To otherVersionCode.Ubound
		    If otherVersionCode(i).IsInteger = False Then
		      #Pragma BreakOnExceptions False
		      Dim tmp As New UnsupportedOperationException
		      tmp.Message = "version comparison strings should only use digits and decimal points"
		      Raise tmp
		    End If
		  Next
		  
		  // if the min is < 0 then we have something is blank and the other is not
		  // so "blank" is less than the other
		  If selfcodes.UBound < 0 And otherVersionCode.Ubound >= 0 Then
		    Return kSElfLessThanOther
		  End If
		  If selfcodes.UBound >= 0 And otherVersionCode.Ubound < 0 Then
		    Return kSelfGreaterThanOther
		  End If
		  
		  Dim minIndex As Integer = min(selfCodes.Ubound, otherVersionCode.Ubound)
		  
		  For i As Integer = 0 To minIndex
		    If Val(selfCodes(0)) < Val(otherVersionCode(0)) Then
		      Return kSelfLessThanOther
		    Elseif Val(selfCodes(0)) > Val(otherVersionCode(0)) Then
		      Return kSelfGreaterThanOther
		    Else
		      // still equal
		      // remove these parts
		      selfCodes.Remove 0
		      otherVersionCode.remove 0
		    End If
		    
		  Next
		  
		  // ok ran out of parts
		  // one of the arrays _should_ be empty by now (or they had the exact same # of exact same parts)
		  // and we know they are all nueric so the one that has more parts is "greater"
		  If selfCodes.Ubound >= 0 Then
		    Return kSelfGreaterThanOther
		  Elseif otherVersionCode.ubound >= 0 Then
		    Return kSelfLessThanOther
		  Else
		    Return kSelfEqualOther
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CompareVerionsCodes(selfString as string, otherVersionString as string) As integer
		  Return selfString.CompareVerionsCodes(otherVersionString)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDigit(extends candidate as string) As Boolean
		  // we're checking single digits
		  If Len(candidate) <> 1 Then
		    Return False
		  End If
		  
		  Return InStr("0123456789", candidate) > 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDigit(candidate as string) As Boolean
		  Return candidate.IsDigit
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsInteger(extends s as string) As boolean
		  If s.Trim = "" Then
		    Return False
		  End If
		  
		  Dim chars() As String = s.Split("")
		  
		  For i As Integer = 0 To chars.ubound
		    If chars(i).IsDigit = False Then
		      Return False
		    End If
		  Next
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsInteger(s as string) As boolean
		  Return s.IsInteger
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LineCount(extends s as String) As integer
		  
		  Dim lines() As String = Split( ReplaceLineEndings( s, EndOfLine ), EndOfLine )
		  
		  Return lines.Ubound + 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LineCount(s as String) As integer
		  return s.LineCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Matches(extends s as string, expression as string) As StringExtensions.MatchPositions
		  
		  Dim rx As New RegEx
		  Dim match As RegExMatch
		  
		  rx.SearchPattern = expression
		  
		  match = rx.Search( s )
		  
		  If match Is Nil Then
		    Return StringExtensions.MatchPositions.NoMatch
		  End If
		  
		  If match.SubExpressionCount > 1 Then
		    Return StringExtensions.MatchPositions.Multiple
		  End If
		  
		  If match.SubExpressionStartB(0) = 0 Then
		    Return StringExtensions.MatchPositions.AtStart
		  End If
		  If match.SubExpressionString(0) = s.LeftBytes( match.SubExpressionString(0).Bytes ) Then
		    Return StringExtensions.MatchPositions.AtEnd
		  End If
		  
		  Return StringExtensions.MatchPositions.InBetween
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Matches(s as string, expression as string) As StringExtensions.MatchPositions
		  
		  
		  Return s.Matches(expression)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParamStr(extends baseString as string, replacements() as string) As string
		  // takes a string like 
		  // foo %1 %2 and %3
		  // and will replace the %1 with the first param, %2 with the second, and so on
		  // you can use the same %N marker as many times as you want
		  
		  Dim workingCopy As String = baseString
		  Dim r As New Random
		  
		  Dim marker As String = ChrB(0)
		  
		  Dim reconsiderMarkers As Boolean
		  
		  Do
		    reconsiderMarkers  = False
		    
		    For n As Integer = 0 To replacements.ubound
		      If replacements(n).InStr( marker ) > 0 Then
		        reconsiderMarkers = True
		        Exit For
		      End If
		    Next
		    
		    If reconsiderMarkers Then
		      marker = marker + Encodings.UTF8.Chr(r.InRange(0,10))
		    End If
		    
		  Loop Until reconsiderMarkers = False
		  
		  
		  For n As Integer = 0 To replacements.ubound
		    // ok we need to avoid the case where you replace 
		    // %1 with %2 and then replace %2 with something else
		    // and the %2 we inserted as a replacement for %1 is replaced by something else
		    // or do we care about this ?
		    
		    // so first we replace all the %N markers with chrb(0)+N+chrb(0)
		    // yes this still could be subverted IF a person knew the innards
		    
		    workingCopy = workingCopy.ReplaceAll("%"+Str(n+1), marker + Str(n+1) + marker )
		    
		  Next
		  
		  For n As Integer = 0 To replacements.ubound
		    
		    workingCopy = workingCopy.ReplaceAll( marker + Str(n+1) + marker , replacements(n) )
		    
		  Next
		  
		  workingCopy = DefineEncoding(workingCopy, baseString.Encoding)
		  
		  Return workingCopy
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParamStr(extends baseString as string, ParamArray replacements as string) As string
		  Return baseString.ParamStr(replacements)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParamStr(baseString as string, ParamArray replacements as string) As string
		  Return baseString.ParamStr(replacements)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  // should work
		  If True Then
		    dim pattern as string = "%1"
		    
		    dim result as string = pattern.ParamStr("foo")
		    
		    Debug.assert result = "foo", CurrentMethodName + " did not get the result expected"
		    Debug.assert result.Encoding = pattern.Encoding, CurrentMethodName + " did not get the same encoding"
		    
		  End If
		  
		  // should work
		  If True Then
		    Dim pattern As String = "%1%2"
		    
		    Dim result As String = pattern.ParamStr("%2", "bar")
		    
		    Debug.assert result = "%2bar", CurrentMethodName + " did not get the result expected"
		    Debug.assert result.Encoding = pattern.Encoding, CurrentMethodName + " did not get the same encoding"
		    
		  End If
		  
		  // should work
		  If True Then
		    Dim pattern As String = "%1%2"
		    
		    Dim result As String = pattern.ParamStr(Chr(0), Chr(0)+Chr(1)+"bar")
		    
		    Debug.assert result = Chr(0)+Chr(0)+Chr(1)+"bar", CurrentMethodName + " did not get the result expected"
		    Debug.assert result.Encoding = pattern.Encoding, CurrentMethodName + " did not get the same encoding"
		    
		  End If
		  
		  // should work
		  If True Then
		    Dim pattern As String = "%1%2"
		    
		    Dim result As String = pattern.ParamStr("%2","%3")
		    
		    Debug.assert result = "%2%3", CurrentMethodName + " did not get the result expected"
		    Debug.assert result.Encoding = pattern.Encoding, CurrentMethodName + " did not get the same encoding"
		    
		  End If
		  
		  /// ========================
		  // should work
		  If True Then
		    Dim versionOne As String
		    Dim versionTwo As String = "1"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      // version 1 should be < version 2
		      Debug.assert result < 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      Debug.assert False , CurrentMethodName + " got unexpected exception"
		    End Try
		    
		  End If
		  
		  If True Then
		    Dim versionOne As String = "1"
		    Dim versionTwo As String 
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      // version 1 should be > version 2
		      Debug.assert result > 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      Debug.assert False , CurrentMethodName + " got unexpected exception"
		    End Try
		    
		  End If
		  
		  // should raise an exception
		  If True Then
		    Dim versionOne As String = "a"
		    Dim versionTwo As String = "1"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      
		      debug.assert False, CurrentMethodName + " expected to get an exceptio but didnt"
		      // version 1 should be < version 2
		      Debug.assert result < 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      // this is correct as versionOne is not conformant to the digits.digits.digits form
		    End Try
		    
		  End If
		  
		  // should raise an exception
		  If True Then
		    Dim versionOne As String = "1"
		    Dim versionTwo As String = "a"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      
		      debug.assert False, CurrentMethodName + " expected to get an exceptio but didnt"
		      // version 1 should be < version 2
		      Debug.assert result < 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      // this is correct as versionOne is not conformant to the digits.digits.digits form
		    End Try
		    
		  End If
		  
		  // should work
		  If True Then
		    Dim versionOne As String = "1.1.1"
		    Dim versionTwo As String = "1.1.1"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      // version 1 should be = version 2
		      Debug.assert result = 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      Debug.assert False , CurrentMethodName + " got unexpected exception"
		    End Try
		    
		    
		  End If
		  
		  // should work
		  If True Then
		    Dim versionOne As String = "1.1"
		    Dim versionTwo As String = "1"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      // version 1 should be > version 2
		      Debug.assert result = 1, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      Debug.assert False , CurrentMethodName + " got unexpected exception"
		    End Try
		    
		  End If
		  
		  // should work
		  If True Then
		    Dim versionOne As String = "1"
		    Dim versionTwo As String = "1.1"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      // version 1 should be < version 2
		      Debug.assert result < 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      Debug.assert False , CurrentMethodName + " got unexpected exception"
		    End Try
		    
		  End If
		  
		  // should work
		  If True Then
		    Dim versionOne As String = "1.1"
		    Dim versionTwo As String = "1.2"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      // version 1 should be < version 2
		      Debug.assert result < 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      Debug.assert False , CurrentMethodName + " got unexpected exception"
		    End Try
		    
		  End If
		  
		  // should work
		  If True Then
		    Dim versionOne As String = "1.2"
		    Dim versionTwo As String = "1.1"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      // version 1 should be > version 2
		      Debug.assert result > 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      Debug.assert False , CurrentMethodName + " got unexpected exception"
		    End Try
		    
		  End If
		  
		  // should work regardless of the length of the string (thanks Sun !)
		  If True Then
		    Dim versionOne As String = "1.1.1.1.1.1.1.1"
		    Dim versionTwo As String = "1.1.1.1.1.1.1.1"
		    
		    Dim result As Integer 
		    Try
		      result = versionOne.CompareVerionsCodes(versionTwo)
		      // version 1 should be = version 2
		      Debug.assert result = 0, CurrentMethodName + " did not get the result expected"
		      
		    Catch uso As UnsupportedOperationException
		      Debug.assert false , CurrentMethodName + " got unexpected exception"
		    End Try
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToArray(extends s as string) As string()
		  
		  Return Split( ReplaceLineEndings( s, EndOfLine) , EndOfLine) 
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToArray(s as string) As string()
		  
		  Return Split( ReplaceLineEndings( s, EndOfLine) , EndOfLine) 
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToBoolean(extends s as string) As Boolean
		  return s = "TRUE"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToBoolean(s as string) As Boolean
		  return s.ToBoolean
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToColor(extends s as String) As color
		  
		  If s.Left(2) = "&c" Then
		    
		    Dim v As Variant
		    v = s
		    Dim c As Color = v
		    
		    Return c
		    
		  Else
		    
		    Break
		    
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToColor(s as String) As color
		  
		  return s.ToColor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit))
		Function ToDouble(extends s as string) As Double
		  
		  Return Val(s)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDouble(s as string) As Double
		  
		  Return s.ToDouble
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit))
		Function ToInteger(extends s as string) As Integer
		  
		  Return Val(s)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToInteger(s as string) As Integer
		  
		  Return s.ToInteger
		  
		  
		End Function
	#tag EndMethod


	#tag Enum, Name = MatchPositions, Flags = &h0
		NoMatch
		  AtStart
		  AtEnd
		  InBetween
		Multiple
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
