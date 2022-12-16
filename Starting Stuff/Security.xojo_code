#tag Module
Protected Module Security
	#tag Method, Flags = &h21
		Private Sub CountChars(pwd as string, byref length as integer, byref uppercaseCount as integer, byref lowercaseCount as integer, byref numbersCount as integer, byref symbolsCount as integer)
		  // count the ASCII lower case chars in a password
		  Dim asciichars() As String
		  asciichars = Split( pwd, "" )
		  
		  length = 0
		  uppercaseCount = 0
		  lowercaseCount = 0
		  numbersCount = 0 
		  symbolsCount = 0 
		  
		  length = asciichars.Ubound + 1
		  
		  For i As Integer = 0 To asciichars.Ubound 
		    
		    If InStrB(Lowercase, asciichars(i)) > 0 Then
		      lowercaseCount = lowercaseCount + 1
		    Elseif InStrB(Uppercase, asciichars(i)) > 0 Then
		      uppercaseCount = uppercaseCount + 1
		    Elseif InStrB(numbers, asciichars(i)) > 0 Then
		      numbersCount = numbersCount + 1
		    Elseif InStrB(symbols, asciichars(i)) > 0 Then
		      symbolsCount = symbolsCount + 1
		    Else
		      Break
		    End If
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function PasswordStrength(password as string) As integer
		  Const minPasswordLength = 8
		  
		  Const bonusExcess = 3
		  Const bonusUpper = 4
		  Const bonusNumbers = 5
		  Const bonusSymbols = 5
		  
		  
		  Dim baseScore As Integer
		  Dim numExcess As Integer
		  Dim bonusCombo As Integer
		  Dim bonusFlatLower As Integer
		  Dim bonusFlatNumber As Integer
		  
		  If (password.length <= minPasswordLength) Then
		    Return 0
		  Else
		    baseScore = 50    
		    
		    Dim resultLength As Integer 
		    Dim resultUppers As Integer 
		    Dim resultLowers As Integer
		    Dim resultNumbers As Integer 
		    Dim resultSymbols As Integer 
		    
		    CountChars(password, resultLength, resultUppers, resultLowers, resultNumbers, resultSymbols)
		    
		    numExcess = resultLength - minPasswordLength
		    
		    If resultUppers > 0 And resultNumbers >= 0 And resultSymbols > 0 Then
		      bonusCombo = 25 
		    Elseif resultUppers >= 0 And resultNumbers >= 0 Then
		      bonusCombo = 15 
		    Elseif resultUppers >= 0 And resultSymbols >= 0 Then
		      bonusCombo = 15 
		    Elseif resultNumbers >= 0 And resultSymbols >= 0 Then
		      bonusCombo = 15
		    End If
		    
		    If resultLowers = resultLength Then
		      bonusFlatLower = -15
		    End If
		    
		    If resultNumbers = resultLength Then
		      bonusFlatNumber = -35
		    End If
		    
		    Return baseScore + (numExcess*bonusExcess) + (resultUppers*bonusUpper) + (resultNumbers*bonusNumbers) + (resultSymbols*bonusSymbols) + bonusCombo + bonusFlatLower + bonusFlatNumber
		    
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function RandomPassword(length as integer = 16, uppercaseCount as integer = -1, lowercaseCount as integer = -1, numbersCount as integer = -1, symbolsCount as integer = -1) As string
		  // total of all the counts cant be more than the length
		  If uppercaseCount + lowercaseCount + numbersCount + symbolsCount > length Then
		    Dim tmp As New UnsupportedOperationException
		    tmp.message = "uppercase + lowercase + numbers + symbols > length"
		    Raise tmp
		  End If
		  
		  
		  Const all = Uppercase + Lowercase + numbers + symbols
		  
		  Dim password As String = ""
		  Dim allcountsSatisfied As Boolean
		  
		  Dim r As New Random
		  
		  While allcountsSatisfied = False
		    password = ""
		    
		    For index As Integer = 1 To length
		      Dim randomNumber As Integer = r.InRange(1, all.Len)
		      password = password + Mid(all, randomNumber, 1)
		    Next
		    allcountsSatisfied = true
		    Dim upperCaseCounter As Integer
		    Dim lowercaseCounter As Integer
		    Dim numbersCounter As Integer
		    Dim symbolsCounter As Integer
		    
		    // we count chars using ASC and MID because Xojo IS NOT case sensitive but we need to be !
		    For i As Integer = 1 To Len(password)
		      Dim chASc As Integer = Asc(password.Mid(i,1))
		      Dim j As Integer
		      For j = 1 To Len(Uppercase)
		        If chASc = Asc(Mid(Uppercase,j,1)) Then
		          upperCaseCounter = upperCaseCounter + 1
		        End If
		      Next
		      For j = 1 To Len(Lowercase)
		        If chASc = Asc(Mid(Lowercase,j,1)) Then
		          lowercaseCounter = lowercaseCounter + 1
		        End If
		      Next
		      For j = 1 To Len(numbers)
		        If chASc = Asc(Mid(numbers,j,1)) Then
		          numbersCounter = numbersCounter + 1
		        End If
		      Next
		      For j = 1 To Len(symbols)
		        If chASc = Asc(Mid(symbols,j,1)) Then
		          symbolsCounter = symbolsCounter + 1
		        End If
		      Next
		    Next
		    
		    If uppercaseCount > 0 Then
		      allcountsSatisfied = allcountsSatisfied And ( upperCaseCounter >= uppercaseCount )
		    End If
		    If lowercaseCount > 0 Then
		      allcountsSatisfied = allcountsSatisfied And ( lowercaseCounter >= lowercaseCount )
		    End If
		    If numbersCount > 0 Then
		      allcountsSatisfied = allcountsSatisfied And ( numbersCounter >= numbersCount )
		    End If
		    If symbolsCount > 0 Then
		      allcountsSatisfied = allcountsSatisfied And ( symbolsCounter >= symbolsCount )
		    End If
		    
		  Wend
		  
		  Return password
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  If True Then
		    
		    Dim length As Integer = 7
		    Dim uppers As Integer = 2
		    Dim lowers As Integer = 2
		    Dim numbers As Integer = 2
		    Dim symbols As Integer = 2
		    
		    #Pragma BreakOnExceptions False
		    Try
		      Dim pwd As String 
		      pwd = RandomPassword( length, uppers, lowers, numbers, symbols )
		      Break
		    Catch uoe As UnsupportedOperationException
		      // this IS expected !
		    End Try
		    #pragma BreakOnExceptions default
		  End If
		  
		  
		  If True Then
		    
		    Dim length As Integer = 16
		    Dim uppers As Integer = 2
		    Dim lowers As Integer = 2
		    Dim numbers As Integer = 2
		    Dim symbols As Integer = 2
		    
		    Dim pwd As String = RandomPassword( length, uppers, lowers, numbers, symbols )
		    
		    Dim resultLength As Integer 
		    Dim resultUppers As Integer 
		    Dim resultLowers As Integer
		    Dim resultNumbers As Integer 
		    Dim resultSymbols As Integer 
		    
		    CountChars(pwd, resultLength, resultUppers, resultLowers, resultNumbers, resultSymbols)
		    
		    debug.Assert resultLength >= length, CurrentMethodName + " length is wrong"
		    debug.Assert resultUppers >= uppers, CurrentMethodName + " wrong # of uppers"
		    debug.Assert resultLowers >= lowers, CurrentMethodName + " wrong # of lowers"
		    debug.Assert resultNumbers >= numbers, CurrentMethodName + " wrong # of numbers"
		    debug.Assert resultSymbols >= symbols, CurrentMethodName + " wrong # of symbols"
		    
		  End If
		  
		  
		  If True Then
		    
		    Dim pwd As String
		    
		    Dim pwdStrength As Integer = PasswordStrength( pwd )
		    
		    debug.Assert pwdStrength = 0, CurrentMethodName + " strength assesed wrong"
		  End If
		  
		  If True Then
		    
		    Dim length As Integer = 20
		    Dim uppers As Integer = 3
		    Dim lowers As Integer = 3
		    Dim numbers As Integer = 3
		    Dim symbols As Integer = 3
		    
		    Dim pwd As String = RandomPassword( length, uppers, lowers, numbers, symbols )
		    
		    Dim pwdStrength As Integer = PasswordStrength( pwd )
		    
		    debug.Assert pwdStrength >= 150, CurrentMethodName + " strength assesed wrong"
		  End If
		End Sub
	#tag EndMethod


	#tag Constant, Name = Lowercase, Type = String, Dynamic = False, Default = \"abcdefghijklmnopqrstuvwxyz", Scope = Private
	#tag EndConstant

	#tag Constant, Name = numbers, Type = String, Dynamic = False, Default = \"0123456789", Scope = Private
	#tag EndConstant

	#tag Constant, Name = symbols, Type = String, Dynamic = False, Default = \"!\"#$%&\'()*+\x2C-./:;<\x3D>\?@[\\\\]^_`{|}~", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Uppercase, Type = String, Dynamic = False, Default = \"ABCDEFGHIJKLMNOPQRSTUVWXYZ", Scope = Private
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
