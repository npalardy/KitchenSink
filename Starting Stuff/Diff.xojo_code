#tag Module
Protected Module Diff
	#tag Method, Flags = &h21
		Private Sub assert(test as boolean, msg as string)
		  If test = False Then
		    Break
		    Dim Logger As debug.logger = CurrentMethodName
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateDiffs(DataA as DiffData, DataB as DiffData) As item()
		  // Scan the tables of which lines are inserted and deleted,
		  // producing an edit script in forward order.  
		  
		  Dim a() As item
		  
		  Dim StartA, StartB As Integer
		  Dim LineA, LineB As Integer
		  
		  LineA = 0
		  LineB = 0
		  While (LineA < DataA.Length Or LineB < DataB.Length) 
		    
		    If ((LineA < DataA.Length) And (DataA.modified(LineA) = False) And (LineB < DataB.Length) And (DataB.modified(LineB) = False)) Then
		      // equal lines
		      LineA = lineA + 1
		      LineB = lineB + 1
		      
		    Else
		      // maybe deleted and/or inserted lines
		      StartA = LineA
		      StartB = LineB
		      
		      While (LineA < DataA.Length And (LineB >= DataB.Length Or DataA.modified(LineA) ))
		        // while (LineA < DataA.Length && DataA.modified[LineA])
		        LineA = LineA + 1
		      Wend
		      
		      While (LineB < DataB.Length And (LineA >= DataA.Length Or DataB.modified(LineB) ))
		        // while (LineB < DataB.Length && DataB.modified[LineB])
		        LineB = lineB + 1
		      Wend
		      
		      If ((StartA < LineA) Or (StartB < LineB)) Then
		        // store a new difference-item
		        Dim aItem As Item
		        
		        aItem.StartA = StartA
		        aItem.StartB = StartB
		        aItem.deletedA = LineA - StartA
		        aItem.insertedB = LineB - StartB
		        
		        a.Append aItem
		      End If // if
		    End If // if
		  Wend // while
		  
		  Return a 
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DiffCodes(aText as string, h as Dictionary, trimSpace as boolean, ignoreSpace as boolean, ignoreCase as boolean) As integer()
		  
		  // This function converts all textlines of the text into unique numbers for every unique textline
		  // so further work can work only with simple numbers.
		  
		  // Input - aText - the "left" text 
		  //       - h - This extern initialized hashtable is used for storing all ever used textlines.
		  //       - trimSpace ignore leading and trailing space characters
		  //       - ignoreSpace ignores embedded spaces 
		  //       - ignoreCase ignores case differences
		  // Return an array of integers (the "codes" for each unique line)
		  
		  // get all codes of the text
		  #Pragma BackgroundTasks False
		  #Pragma NilObjectChecking False
		  #Pragma BoundsChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim Codes() As Integer
		  Dim lastUsedCode As Integer = h.Count
		  
		  // strip off all cr, only use lf as textline separator.
		  aText = ReplaceLineEndings(aText, EndOfLine)
		  Dim Lines() As String = aText.Split(EndOfLine)
		  
		  redim Codes(Lines.Ubound)
		  
		  For i as integer = 0 to Lines.Ubound
		    Dim s As String = Lines(i)
		    
		    If trimSpace Then
		      s = s.Trim
		    End If
		    
		    If ignoreSpace Then
		      s = ReplaceLineEndings(s, "")
		      s = s.ReplaceAll(&u09, "")           // TODO: optimization: faster blank removal.
		      
		      While s.InStr(" ") > 0 
		        s = s.ReplaceAll(" ", "")            // TODO: optimization: faster blank removal.
		      Wend
		      
		    End If
		    
		    If ignoreCase Then
		      s = s.Lowercase
		    End If
		    
		    // we need a unique way to test "lines"
		    Dim md As String = md5(s)
		    
		    If h.HasKey(md) = False  Then
		      lastUsedCode = lastUsedCode + 1
		      h.value(md) = lastUsedCode
		      Codes(i) = lastUsedCode
		    Else 
		      Codes(i) = h.Value(md)
		    End If // if
		    
		  Next // for
		  
		  Return Codes
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DiffInt(ArrayA() as integer, ArrayB() as integer) As Item()
		  // Find the difference in 2 arrays of integers.
		  
		  // ArrayA - A-version of the numbers (usualy the old one)
		  // ArrayB - B-version of the numbers (usualy the new one)
		  
		  // Returns a array of Items that describe the differences. (the edit stream required to turn ArrayA into ArrayB)
		  
		  // The A-Version of the data (original data) to be compared.
		  Dim DataA As New DiffData(ArrayA)
		  
		  // The B-Version of the data (modified data) to be compared.
		  Dim DataB As New DiffData(ArrayB)
		  
		  Dim Max As Integer = DataA.Length + DataB.Length + 1
		  
		  // vector for the (0,0) to (x,y) search
		  Dim DownVector() As Integer
		  Redim DownVector(2 * Max + 2)
		  
		  // vector for the (u,v) to (N,M) search
		  Dim UpVector() As Integer
		  Redim UpVector(2 * Max + 2)
		  
		  LCS(DataA, 0, DataA.Length, DataB, 0, DataB.Length, DownVector, UpVector)
		  
		  Return CreateDiffs(DataA, DataB)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DiffText(TextA as string, TextB as string) As String
		  // Find the difference in 2 texts, comparing by textlines.
		  
		  // TextA - A-version of the text (usualy the old one)
		  // TextB - B-version of the text (usualy the new one)
		  // Returns a array of Items that describe the differences. (the edit stream)
		  
		  Return DiffText(TextA, TextB, False, False, False) 
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DiffText(TextA as string, TextB as string, trimSpace as boolean, ignoreSpace as boolean, ignoreCase as boolean) As String
		  // from http://www.mathertel.de/Diff/ViewSrc.aspx
		  
		  
		  // Find the difference in 2 text documents, comparing by textlines.
		  // The algorithm itself is comparing 2 arrays of numbers so when comparing 2 text documents
		  // each line is converted into a (hash) number. This hash-value is computed by storing all
		  // textlines into a common hashtable so i can find dublicates in there, and generating a 
		  // new number each time a new textline is inserted.
		  
		  // TextA - A-version of the text (usualy the old one)
		  // TextB -B-version of the text (usualy the new one)
		  // trimSpace -When set to true, all leading and trailing whitespace characters are stripped out before the comparation is done.
		  // ignoreSpace - When set to true, all whitespace characters are converted to a single space character before the comparation is done.
		  // ignoreCase - When set to true, all characters are converted to their lowercase equivivalence before the comparation is done.
		  
		  // Returns a array of Items that describe the differences.
		  
		  // prepare the input-text and convert to comparable numbers.
		  Dim h As New Dictionary
		  h.BinCount = len(TextA) + Len(TextB)
		  
		  // The A-Version of the data (original data) to be compared.
		  Dim DataA As New DiffData( DiffCodes(TextA, h, trimSpace, ignoreSpace, ignoreCase) )
		  
		  // The B-Version of the data (modified data) to be compared.
		  Dim DataB As New DiffData( DiffCodes(TextB, h, trimSpace, ignoreSpace, ignoreCase) )
		  
		  h = Nil // free up hashtable memory (maybe)
		  
		  Dim Max As Integer = DataA.Length + DataB.Length + 1
		  
		  // vector for the (0,0) to (x,y) search
		  Dim DownVector() As Integer 
		  Redim DownVector(2 * Max + 2) 
		  
		  // vector for the (u,v) to (N,M) search
		  Dim UpVector() As Integer
		  Redim UpVector(2 * Max + 2)
		  
		  LCS(DataA, 0, DataA.Length, DataB, 0, DataB.Length, DownVector, UpVector)
		  
		  Optimize(DataA)
		  Optimize(DataB)
		  
		  Return WriteDiffString( CreateDiffs(DataA, DataB) )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LCS(DataA as DiffData, LowerA as integer, UpperA as integer, DataB as DiffData, LowerB as integer, UpperB as integer, DownVector() as integer, UpVector() as integer)
		  // This is the divide-and-conquer implementation of the longes common-subsequence (LCS) 
		  // algorithm.
		  // The published algorithm passes recursively parts of the A and B sequences.
		  // To avoid copying these arrays the lower and upper bounds are passed while the sequences stay constant.
		  
		  // DataA - sequence A
		  // LowerA - lower bound of the actual range in DataA
		  // UpperA - upper bound of the actual range in DataA (exclusive)
		  // DataB - sequence B
		  // LowerB - lower bound of the actual range in DataB
		  // UpperB - upper bound of the actual range in DataB (exclusive)
		  // DownVector - a vector for the (0,0) to (x,y) search. Passed as a parameter for speed reasons.
		  // UpVector - a vector for the (u,v) to (N,M) search. Passed as a parameter for speed reasons.
		  
		  
		  // Fast walkthrough equal lines at the start
		  While (LowerA < UpperA and LowerB < UpperB And DataA.data(LowerA) = DataB.data(LowerB)) 
		    LowerA = lowerA + 1
		    LowerB = lowerB + 1
		  Wend
		  
		  // Fast walkthrough equal lines at the end
		  While (LowerA < UpperA And LowerB < UpperB And DataA.data(UpperA - 1) = DataB.data(UpperB - 1)) 
		    UpperA = UpperA - 1
		    UpperB = UpperB - 1
		  Wend
		  
		  If (LowerA = UpperA) Then
		    // mark as inserted lines.
		    While (LowerB < UpperB)
		      DataB.modified(LowerB) = True
		      lowerB = lowerB + 1
		    Wend
		    
		  Elseif (LowerB = UpperB) Then
		    // mark as deleted lines.
		    While (LowerA < UpperA)
		      DataA.modified(LowerA) = True
		      lowerA = lowerA + 1
		    Wend
		  Else 
		    // Find the middle snakea and length of an optimal path for A and B
		    Dim sms_rd As SMSRD = SMS(DataA, LowerA, UpperA, DataB, LowerB, UpperB, DownVector, UpVector)
		    
		    // Debug.Write(2, "MiddleSnakeData", String.Format("{0},{1}", smsrd.x, smsrd.y));
		    
		    // The path is from LowerX to (x,y) and (x,y) to Upper
		    LCS(DataA, LowerA, sms_rd.x, DataB, LowerB, sms_rd.y, DownVector, UpVector)
		    LCS(DataA, sms_rd.x, UpperA, DataB, sms_rd.y, UpperB, DownVector, UpVector)  // 2002.09.20: no need for 2 points 
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Optimize(data as DiffData)
		  
		  // If a sequence of modified lines starts with a line that contains the same content
		  // as the line that appends the changes, the difference sequence is modified so that the
		  // appended line and not the starting line is marked as modified.
		  // This leads to more readable diff sequences when comparing text files.
		  
		  // Inputs - Data - A Diff data buffer containing the identified changes.
		  
		  Dim StartPos, EndPos As Integer
		  
		  StartPos = 0
		  
		  While (StartPos < Data.Length) 
		    
		    While ((StartPos < Data.Length) And (Data.modified(StartPos) = False))
		      StartPos = startpos + 1
		    Wend
		    
		    EndPos = StartPos
		    While ((EndPos < Data.Length) And  (Data.modified(EndPos) = True))
		      EndPos = endpos + 1
		    Wend
		    
		    If ((EndPos < Data.Length) And (Data.data(StartPos) = Data.data(EndPos))) Then
		      Data.modified(StartPos) = False
		      Data.modified(EndPos) = True
		    Else
		      StartPos = EndPos
		    End If // if
		    
		  Wend // while
		  
		  // Optimize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  Dim Logger As debug.logger = CurrentMethodName
		  
		  
		  // Dim diff As New DiffParser
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    // test all changes
		    a = ReplaceAll("a,b,c,d,e,f,g,h,i,j,k,l", ",", &u0A)
		    b = ReplaceAll("0,1,2,3,4,5,6,7,8,9", ",", &u0A)
		    
		    Dim result As String = Diff.DiffText(a, b, False, False, False)
		    Assert( result = "12.10.0.0*", "all-changes test failed.")
		    logger.log("all-changes test passed.")
		    
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // test all same
		    a = ReplaceAll("a,b,c,d,e,f,g,h,i,j,k,l", ",", &u0A)
		    b = a
		    Dim result As String 
		    result = Diff.DiffText(a, b, False, False, False) 
		    Assert( Diff.DiffText(a, b, False, False, False) = "", "all-same test failed.")
		    logger.log("all-same test passed.")
		    
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // test snake
		    a = ReplaceAll("a,b,c,d,e,f", ",", &u0A)
		    b = ReplaceAll("b,c,d,e,f,x",",",&u0A)
		    Dim result As String 
		    result = Diff.DiffText(a, b, False, False, False)
		    Assert( result = "1.0.0.0*0.1.6.5*","snake test failed.")
		    logger.log("snake test passed.")
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // 2002.09.20 - repro
		    a = ReplaceAll("c1,a,c2,b,c,d,e,g,h,i,j,c3,k,l",",",&u0A)
		    b = ReplaceAll("C1,a,C2,b,c,d,e,I1,e,g,h,i,j,C3,k,I2,l",",",&u0A)
		    Dim result As String 
		    result = Diff.DiffText(a, b, False, False, False)
		    Assert( result = "1.1.0.0*1.1.2.2*0.2.7.7*1.1.11.13*0.1.13.15*","repro20020920 test failed.")
		    logger.log("repro20020920 test passed.")
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // 2003.02.07 - repro
		    a = ReplaceAll("F",",",&u0A)
		    b = ReplaceAll("0,F,1,2,3,4,5,6,7",",",&u0A)
		    Dim result As String 
		    result = Diff.DiffText(a, b, False, False, False)
		    Assert( result = "0.1.0.0*0.7.1.2*", "repro20030207 test failed.")
		    logger.log("repro20030207 test passed.")
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // Muegel - repro
		    a = "HELLO" + &u0a + "WORLD"
		    b = &u0a+&u0a+"hello"+&u0a+&u0a+&u0a+&u0a+"world"+&u0a
		    Dim result As String 
		    result = Diff.DiffText(a, b, False, False, False) 
		    Assert( result = "2.8.0.0*", "repro20030409 test failed.")
		    logger.log("repro20030409 test passed.")
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // test some differences
		    a = ReplaceAll("a,b,-,c,d,e,f,f",",",&u0A)
		    b = ReplaceAll("a,b,x,c,e,f",",",&u0A)
		    Dim result As String 
		    result = Diff.DiffText(a, b, False, False, False)
		    Assert( result = "1.1.2.2*1.0.4.4*1.0.7.6*", "some-changes test failed.")
		    logger.log("some-changes test passed.")
		    
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // test one change within long chain of repeats
		    a = ReplaceAll("a,a,a,a,a,a,a,a,a,a",",",&u0A)
		    b = ReplaceAll("a,a,a,a,-,a,a,a,a,a",",",&u0A)
		    Dim result As String
		    result = Diff.DiffText(a, b, False, False, False)
		    Assert( result = "0.1.4.4*1.0.9.10*", "long chain of repeats test failed.")
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // test snake but with case ignored
		    a = ReplaceAll("A,B,C,D,E,F", ",", &u0A)
		    b = ReplaceAll("b,c,d,e,f,x",",",&u0A)
		    Dim result As String
		    result = Diff.DiffText(a, b, False, False, True)
		    Assert( result = "1.0.0.0*0.1.6.5*","snake test failed.")
		    logger.log("snake test passed.")
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // test snake but with spaces trimmed & ignore case
		    a = ReplaceAll(" A, B ,C , D ,E , F ", ",", &u0A)
		    b = ReplaceAll("b,c,d,e,f,x",",",&u0A)
		    Dim result As String
		    result = Diff.DiffText(a, b, True, False, True)
		    Assert( result = "1.0.0.0*0.1.6.5*","snake test failed.")
		    logger.log("snake test passed.")
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    // test with ignoring spaces & ignore case
		    a = ReplaceAll("A A,B B,C C,D D,E E,F F", ",", &u0A)
		    b = ReplaceAll("bb,cc,dd,ee,ff,xx",",",&u0A)
		    Dim result As String 
		    result = Diff.DiffText(a, b, False, True, True)
		    Assert( result = "1.0.0.0*0.1.6.5*","snake test failed.")
		    logger.log("snake test passed.")
		    
		  End If
		  
		  If True Then
		    Dim a As String
		    Dim b As String
		    
		    
		    a = "this is a test"
		    b = "this is a test" + EndOfLine + "added line"
		    Dim result As String 
		    result = Diff.DiffText(a, b, False, False, False)
		    // if I read this right this should be 0.1.1.1
		    // deleted 0 lines starting at 1       ^   ^
		    // inserted 1 line starting at 1         ^   ^
		  End If
		  
		  logger.log("End.")
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SMS(DataA as DiffData, LowerA as integer, UpperA as integer, DataB as DiffData, LowerB as integer, UpperB as integer, DownVector() as integer, UpVector() as integer) As SMSRD
		  
		  // This is the algorithm to find the Shortest Middle Snake (SMS).
		  
		  // DataA - sequence A
		  // LowerA - lower bound of the actual range in DataA
		  // UpperA - upper bound of the actual range in DataA (exclusive)
		  // DataB - sequence B
		  // LowerB - lower bound of the actual range in DataB
		  // UpperB - upper bound of the actual range in DataB (exclusive)
		  // DownVector - a vector for the (0,0) to (x,y) search. Passed as a parameter for speed reasons.
		  // UpVector - a vector for the (u,v) to (N,M) search. Passed as a parameter for speed reasons.
		  
		  // a MiddleSnakeData record containing x,y 
		  
		  Dim ret As SMSRD
		  
		  Dim Max As Integer = DataA.Length + DataB.Length + 1
		  
		  Dim DownK As Integer = LowerA - LowerB // the k-line to start the forward search
		  Dim UpK As Integer = UpperA - UpperB // the k-line to start the reverse search
		  
		  Dim Delta As Integer= (UpperA - LowerA) - (UpperB - LowerB)
		  Dim oddDelta As Boolean = (Delta And &h01) <> 0
		  
		  // The vectors in the publication accepts negative indexes. the vectors implemented here are 0-based
		  // and are access using a specific offset: UpOffset UpVector and DownOffset for DownVektor
		  Dim DownOffset As Integer = Max - DownK
		  Dim UpOffset As Integer = Max - UpK
		  
		  Dim MaxD As Integer = ((UpperA - LowerA + UpperB - LowerB) / 2) + 1
		  
		  // init vectors
		  DownVector(DownOffset + DownK + 1) = LowerA
		  UpVector(UpOffset + UpK - 1) = UpperA
		  
		  For D As Integer = 0 To MaxD
		    
		    // Extend the forward path.
		    For k As Integer = DownK - D To DownK + D Step 2
		      //   Debug.Write(0, "SMS", "extend forward path " + k.ToString());
		      
		      // find the only or better starting point
		      Dim x, y As Integer
		      If (k = DownK - D) Then
		        x = DownVector(DownOffset + k + 1) // down
		      Else 
		        x = DownVector(DownOffset + k - 1) + 1 // a step to the right
		        If ((k < DownK + D) And (DownVector(DownOffset + k + 1) >= x)) Then
		          x = DownVector(DownOffset + k + 1) // down
		        End If
		      End If
		      y = x - k
		      
		      // find the end of the furthest reaching forward D-path in diagonal k.
		      While ((x < UpperA) And (y < UpperB) And (DataA.data(x) = DataB.data(y) )) 
		        x = x + 1
		        y = y + 1
		      Wend
		      DownVector(DownOffset + k) = x
		      
		      // overlap ?
		      If (oddDelta And (UpK - D < k) And (k < UpK + D)) Then
		        If (UpVector(UpOffset + k) <= DownVector(DownOffset + k)) Then
		          ret.x = DownVector(DownOffset + k)
		          ret.y = DownVector(DownOffset + k) - k
		          // ret.u = UpVector[UpOffset + k];      // 2002.09.20: no need for 2 points 
		          // ret.v = UpVector[UpOffset + k] - k;
		          Return ret
		        End If // if
		      End If // if
		      
		    Next // for k
		    // 
		    // // Extend the reverse path.
		    For k As Integer = UpK - D To UpK + D Step 2
		      // Debug.Write(0, "SMS", "extend reverse path " + k.ToString());
		      
		      // find the only or better starting point
		      Dim x, y As Integer
		      If (k = UpK + D) Then
		        x = UpVector(UpOffset + k - 1) // up
		      Else
		        x = UpVector(UpOffset + k + 1) - 1 // left
		        If ((k > UpK - D) And (UpVector(UpOffset + k - 1) < x)) Then
		          x = UpVector(UpOffset + k - 1) // up
		        End If
		      End If  // if
		      y = x - k
		      // 
		      While ((x > LowerA) And (y > LowerB) And (DataA.data(x - 1) = DataB.data(y - 1))) 
		        x = x - 1
		        y = y - 1 // diagonal
		      Wend
		      UpVector(UpOffset + k) = x
		      
		      // overlap ?
		      If (oddDelta = False And (DownK - D <= k) And (k <= DownK + D)) Then
		        If (UpVector(UpOffset + k) <= DownVector(DownOffset + k)) Then
		          ret.x = DownVector(DownOffset + k)
		          ret.y = DownVector(DownOffset + k) - k
		          // ret.u = UpVector[UpOffset + k];     // 2002.09.20: no need for 2 points 
		          // ret.v = UpVector[UpOffset + k] - k;
		          Return ret
		        End If // if
		      End If // if
		      
		    Next // for k
		    // 
		  Next // for D
		  
		  Dim unsupported As New UnsupportedOperationException
		  unsupported.Message = "the algorithm should never come here."
		  unsupported.Reason  = "the algorithm should never come here."
		  
		  Raise Unsupported
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function WriteDiffString(f() as Diff.Item) As string
		  Dim ret() As String
		  
		  For n As Integer = 0 To f.ubound
		    // ret.Append "StartA =" + Str(f(n).StartA) + _
		    // " StartB ="+ Str(f(n).StartB) + _
		    // " DeletedA =" + Str(f(n).deletedA) + _
		    // " InsertedB =" + Str(f(n).insertedB) + EndOfLine
		    
		    ret.Append Str(f(n).deletedA) + "." + Str(f(n).insertedB) + "." + Str(f(n).StartA) + "." + Str(f(n).StartB) + "*"
		  Next
		  
		  Return Join(ret, "")
		  
		End Function
	#tag EndMethod


	#tag Note, Name = From
		from https://stackoverflow.com/questions/805626/diff-algorithm
		
		     http://www.mathertel.de/Diff/
		     http://www.mathertel.de/Diff/ViewSrc.aspx
		
		
		USE A MONO SPACED FONT TO VIEW THIS and a wide monitor :)
		
		the raw output is nasty as hell
		its an "edit stream" or a list of things you need to do to turn "the left" into "the right"
		
		it comes back as one long string but we'll analyze the output chunk by chunk (chunks are delimited by a *)
		
		note that you NEVER see just a change (it would be a delete + insert)
		
		see the unit tests in RunUnitTests
		
		this is from one of them ( // 2002.09.20 - repro )
		                                                                                               Line #      LEFT      RIGHT
		                                                                                               0            c1        C1       
		                                                                                               1            a         a
		                                                                                               2            c2        C2
		                                                                                               3            b         b
		                                                                                               4            c         c
		                                                                                               5            d         d
		                                                                                               6            e         e
		                                                                                               7            g         I1
		                                                                                               8            h         e
		                                                                                               9            i         g
		                                                                                              10            j         h
		                                                                                              11            c3        i
		                                                                                              12            k         j
		                                                                                              13            l         C3
		                                                                                              14                      k
		                                                                                              15                      I2
		                                                                                              16                      l
		
		
		and the output is one long line = 1.1.0.0*1.1.2.2*0.2.7.7*1.1.11.13*0.1.13.15*
		
		a description of each portion follows
		
		line removals listed far to the right preceded with a - and additions with a +
		
		  1.1.0.0*          
		  ^   ^     - 1 line deleted starting at left line 0                                                                         - c1  
		    ^   ^   - 1 line added starting from right line 0                                                                        + C1 
		
		            - left line 1 is the same and so retained                                                                           a
		               
		  1.1.2.2*  
		  ^   ^     - 1 line deleted starting at left line 2                                                                         - c2
		    ^   ^   - 1 line added starting at right line 2                                                                          + C2
		
		            - left lines 3 - 6 are the same and so retained                                                                     b
		                                                                                                                                c
		                                                                                                                                d
		                                                                                                                                e
		
		  0.2.7.7*  
		  ^   ^     - 0 line deleted starting from left line 7                                                                 
		    ^   ^   - 2 lines added startning at right line 7                                                                        + I1
		                                                                                                                              + e 
		
		            - left lines 7 - 10 are the same and so retained                                                                    g
		                                                                                                                                h
		                                                                                                                                i
		                                                                                                                                j
		  1.1.11.13*
		  ^   ^     - 1 line deleted starting at line left 11                                                                        - c3
		    ^   ^   - 1 lines added startning from right line 13                                                                     + C3
		 
		
		            - left line 12 is the same and so retained                                                                          k
		
		  0.1.13.15*
		  ^   ^     - 0 line deleted starting at line left 13
		    ^   ^   - 1 lines added startning from right line 15                                                                     + I2
		
		            - left line 13 is the same and so retained                                                                          l
		
		note that you only see lines where there are difference of some kind (deletions or insertions)
		
		see the method "put result in text area" on Windows1 for how I convert this kind of data into a visual representation of the text
		
		
		                                                                                                  
	#tag EndNote


	#tag Structure, Name = Item, Flags = &h21
		startA as integer
		  startB as integer
		  deletedA as integer
		insertedB as integer
	#tag EndStructure

	#tag Structure, Name = SMSRD, Flags = &h21
		x as integer
		y as integer
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
