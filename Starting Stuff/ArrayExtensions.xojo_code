#tag Module
Protected Module ArrayExtensions
	#tag Method, Flags = &h0, Description = 417070656E64732065616368206974656D20696E20746865206E65774974656D7320617272617920746F20746865206F726967696E616C
		Sub Append(extends stringArray() as string, newItems() as String)
		  For Each item As String In newItems
		    stringArray.Append item
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612070726566697820746F2065616368206974656D20696E20746865206E6577417272617920616E64206164647320697420746F20746865206172726179
		Sub Append(extends stringArray() as string, prefix as string, newItems() as String)
		  For Each item As String In newItems
		    stringArray.Append prefix + item
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320616C6C206C69737465642076616C75657320746F2074686520656E64206F662074686520617272617920696E20746865206F7264657220676976656E
		Sub Append(extends stringArray() as string, item1 as string, item2 as string, ParamArray items() as string)
		  stringArray.append item1
		  stringArray.append item2
		  For Each s As String In items
		    stringArray.append s
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equals(extends baseArray() as string, otherArray() as string) As boolean
		  // compares two arrays for
		  //   same # of elements
		  //   same contents in the same order
		  
		  If baseArray.Ubound <> otherArray.Ubound Then
		    Return False
		  End If
		  
		  For i As Integer = 0 To baseArray.Ubound
		    If baseArray(i) <> otherArray(i) Then
		      Return False
		    End If
		  Next
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  If True Then
		    Dim array1() As String
		    Dim array2() As String = Array ("123")
		    
		    array1.Append array2
		    
		    Debug.assert array1.Ubound = 0, CurrentMethodName + " got wrong count"
		    Debug.assert array1(0) = "123", CurrentMethodName + " got wrong item"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String
		    Dim array2() As String = Array ("123")
		    
		    array2.Append array1
		    
		    Debug.assert array2.Ubound = 0, CurrentMethodName + " got wrong count"
		    Debug.assert array2(0) = "123", CurrentMethodName + " got wrong item"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String
		    Dim array2() As String = Array ("123")
		    
		    array1.Append "prefix " , array2
		    
		    Debug.assert array1.Ubound = 0, CurrentMethodName + " got wrong count"
		    Debug.assert array1(0) = "prefix 123", CurrentMethodName + " got wrong item"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String
		    Dim array2() As String = Array ("123")
		    
		    array2.Append "prefix" , array1
		    
		    // we add NOTHING as array1 is empty !!!!!!!
		    Debug.assert array2.Ubound = 0, CurrentMethodName + " got wrong count"
		    Debug.assert array2(0) = "123", CurrentMethodName + " got wrong item"
		    
		  End If
		  
		  
		  // slice tests
		  If True Then
		    Dim array1() As String = Array ("123")
		    Dim array2() As String = array1.Slice(1,1)
		    
		    // array2 should be empty
		    Debug.assert array2.Ubound < 0, CurrentMethodName + " got wrong count"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String = Array ("123")
		    Dim array2() As String = array1.Slice(0,1)
		    
		    // array2 should have 1 element that is a copy of array1
		    Debug.assert array2.Ubound = 0, CurrentMethodName + " got wrong count"
		    Debug.assert array2(0) = array1(0), CurrentMethodName + " got wrong value"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String = Array ("123" , "234", "345", "456" )
		    Dim array2() As String = array1.Slice(1,2)
		    
		    // array2 should have 2 elements that is a copy of array1(1) and array1(2)
		    Debug.assert array2.Ubound = 1, CurrentMethodName + " got wrong count"
		    Debug.assert array2(0) = array1(1), CurrentMethodName + " got wrong value"
		    Debug.assert array2(1) = array1(2), CurrentMethodName + " got wrong value"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String = Array ("123" , "234", "345", "456" )
		    Dim array2() As String = array1.Slice(2,2)
		    
		    // array2 should have 2 elements that is a copy of array1(2) and array1(3)
		    Debug.assert array2.Ubound = 1, CurrentMethodName + " got wrong count"
		    Debug.assert array2(0) = array1(2), CurrentMethodName + " got wrong value"
		    Debug.assert array2(1) = array1(3), CurrentMethodName + " got wrong value"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String = Array ("123" , "234", "345", "456" )
		    Dim array2() As String = array1.Slice(-1,-1)
		    
		    // array2 should have 4 elements that are copies of array1
		    Debug.assert array2.Ubound = array1.Ubound, CurrentMethodName + " got wrong count"
		    Debug.assert array2(0) = array1(0), CurrentMethodName + " got wrong value"
		    Debug.assert array2(1) = array1(1), CurrentMethodName + " got wrong value"
		    Debug.assert array2(2) = array1(2), CurrentMethodName + " got wrong value"
		    Debug.assert array2(3) = array1(3), CurrentMethodName + " got wrong value"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String = Array ("123" , "234", "345", "456" )
		    Dim array2() As String = array1.Slice(1,-1)
		    
		    // array2 should have 3 elements that are copies of array1
		    Debug.assert array2.Ubound = 2, CurrentMethodName + " got wrong count"
		    Debug.assert array2(0) = array1(1), CurrentMethodName + " got wrong value"
		    Debug.assert array2(1) = array1(2), CurrentMethodName + " got wrong value"
		    Debug.assert array2(2) = array1(3), CurrentMethodName + " got wrong value"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String
		    array1.append "123" , "234", "345", "456" 
		    Dim array2() As String = array1.Slice(1,-1)
		    
		    // array2 should have 3 elements that are copies of array1
		    Debug.assert array2.Ubound = 2, CurrentMethodName + " got wrong count"
		    Debug.assert array2(0) = array1(1), CurrentMethodName + " got wrong value"
		    Debug.assert array2(1) = array1(2), CurrentMethodName + " got wrong value"
		    Debug.assert array2(2) = array1(3), CurrentMethodName + " got wrong value"
		    
		  End If
		  
		  If True Then
		    Dim array1() As String
		    array1.append "123" , "234", "345", "456" 
		    Dim array2() As String 
		    array2.append "123" , "234", "345", "456" 
		    
		    // array2 should have the same # of elements that are copies of array1
		    Debug.assert array2.Ubound = array1.Ubound, CurrentMethodName + " got wrong count"
		    debug.assert array1.Equals(array2) = True, CurrentMethodName + " failed array equals"
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Slice(extends original() as string, startOffset as integer = -1, lineCount as integer = -1) As String()
		  
		  Return slice( original, startOffset, lineCount )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Slice(original() as string, startOffset as integer = -1, lineCount as integer = -1) As String()
		  Dim newLines() As String
		  
		  If startOffset > original.Ubound Then
		    Return newLines
		  End If
		  
		  If lineCount < 0 Then
		    lineCount =  original.Ubound + 1
		  End If
		  
		  For i As Integer = Max(startOffset,0) To Max(startOffset,0) + (lineCount-1)
		    
		    newlines.Append original(i)
		    
		    If i + 1 > original.Ubound Then
		      Exit For
		    End If
		    
		  Next
		  
		  Return newLines
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(extends stringArray() as string, separator as string = " ") As string
		  
		  Return Join(stringArray, separator)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Trim(extends stringArray() as string) As string()
		  For i As Integer = 0 To stringArray.ubound
		    stringArray(i) = Trim( stringArray(i) )
		  Next
		  
		  Return stringArray
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
