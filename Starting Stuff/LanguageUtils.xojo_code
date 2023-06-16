#tag Module
Protected Module LanguageUtils
	#tag Method, Flags = &h1
		Protected Function ArrayKeywords() As String()
		  
		  Return Array("append", "remove", "indexof", "insert", "shuffle", "sort", "sortwith" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub assert(test as boolean, msg as string)
		  If test = False Then
		    Break
		    System.DebugLog msg
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function BlockCloser(openingSrc As String) As String
		  // Find the source that closes the given opening.
		  
		  Dim aboveWord As String
		  dim tokens() as string = TokenizeLine(openingSrc, LanguageUtils.NoWhiteSpaceFlag)
		  If tokens.ubound < 0 Then
		    Return ""
		  End If
		  
		  aboveWord = tokens(0)
		  
		  Select Case aboveWord
		  Case "if", "elseif", "else"
		    // watch out for the case of "else" in a "select"...
		    // the caller really should pass the select line instead
		    Return "end if"
		  Case "#if", "#elseif", "#else"
		    Return "#endif"
		  Case "for"
		    Return "next"
		  Case "do"
		    Return  "loop"
		  Case "while"
		    Return "wend"
		  Case "select", "case"
		    Return "end select"
		  Case "try", "catch", "finally"
		    Return "end try"
		  Case "sub"
		    Return "end sub"
		  Case "function"
		    Return "end function"
		    
		  Case "public", "global", "private", "protected"
		    // next word is SUB or FUNCTION ?
		    If tokens.ubound < 1 Then
		      Return ""
		    End If
		    Select Case tokens(1)
		    Case "sub"
		      Return "end sub"
		    Case "function"
		      Return "end function"
		    End Select
		    
		  End Select
		  
		  return ""
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function BlockPairMatches(aboveSrc As String, belowSrc As String) As Boolean
		  // Return whether the two source lines form a block pair,
		  // e.g. If/Else, If/End If, Else/End if, For/Next, etc.
		  
		  Dim aboveWord, belowWord As String
		  Dim endWhat As String
		  
		  aboveWord = FirstToken( aboveSrc )
		  belowWord = FirstToken( belowSrc )
		  if belowWord = "end" then
		    endWhat = FirstToken( Mid( belowSrc, 5 ) )
		    If endWhat <> "" Then 
		      belowWord = belowWord + " " + endWhat
		    End If
		  end if
		  
		  select case aboveWord
		  case "#if"
		    return belowWord = "#else" or belowWord = "#elseif" _
		    or belowWord = "#endif"
		  case "#elseif"
		    return belowWord = "#else" or belowWord = "#elseif" _
		    or belowWord = "#endif"
		  case "#else"
		    return belowWord = "#endif"
		  case "if"
		    return belowWord = "else" or belowWord = "elseif" _
		    or belowWord = "end" or belowWord = "end if"
		  case "elseif"
		    return belowWord = "else" or belowWord = "elseif" _
		    or belowWord = "end" or belowWord = "end if"
		  case "else"
		    return belowWord = "else" or belowWord = "end" _
		    or belowWord = "end if" or belowWord = "end select"
		  case "for"
		    return belowWord = "next"
		  case "do"
		    return belowWord = "loop"
		  case "while"
		    return belowWord = "wend"
		  case "select"
		    return belowWord = "case" or belowWord = "else" _
		    or belowWord = "end" or belowWord = "end select"
		  case "case"
		    return belowWord = "case" or belowWord = "else" _
		    or belowWord = "end" or belowWord = "end select"
		  case "try"
		    return  belowWord = "catch" or belowWord = "finally" _
		    or belowWord = "end" or belowWord = "end try"
		  case "catch"
		    return belowWord = "finally" _
		    or belowWord = "end" or belowWord = "end try"
		  case "finally"
		    return belowWord = "end" or belowWord = "end try"
		  end Select
		  
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CommentStartPos(source As String) As Integer
		  // Return the byte offset of the start of the comment token for
		  // the given source line, or 0 if there is no comment.
		  Dim srcLen As Integer = source.Len
		  Dim pos As Integer
		  Dim inString As Boolean
		  Dim c As String
		  
		  For pos = 1 To srcLen
		    c = Mid( source, pos, 1 )
		    if c = """" then
		      inString = not inString
		    elseif not inString and _
		      (c = "'" or _
		      (c = "/" And Mid( source, pos+1, 1 ) = "/") Or _
		      (c = "R" And Mid( source, pos, 4 ) = "REM " And (pos = 1 Or Mid(source, pos-1, 1) = " "))) Then
		      // yep, this line ends in a comment, which starts at pos!
		      Return pos
		    end if
		  next
		  
		  return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit))
		Private Function Contains(s As String, what As String) As Boolean
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  
		  // Return true if 's' contains the substring 'what'.
		  // By "contains" we mean case-insensitive, encoding-savvy containment
		  // as with InStr.
		  
		  If what = "" Then 
		    Return True
		  End If
		  
		  return InStr( s, what ) > 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CrackClassDeclaration(content as string, byref attrs as string, byref scope as string, byref className as string) As boolean
		  #Pragma unused content
		  #Pragma unused scope
		  #pragma unused className
		  
		  #If debugBuild
		    Const debugThis = False
		  #Else
		    Const debugthis = False
		  #EndIf
		  
		  ' class decls are pretty simple
		  '
		  '          CLASS IDENTIFIER newline
		  '              classbody
		  '          END CLASS ENDL
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine(content, LanguageUtils.NoWhiteSpaceFlag)
		  
		  // empty string ?
		  If tokens.ubound < 0 Then 
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // attrs
		  // scope
		  
		  If tokens(0) <> kCLASS Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  Else
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // the class name 
		  If IsIdentifier( tokens(0) ) = False Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // the name is not an ident ?????
		  End If
		  className = tokens(0)
		  tokens.remove 0
		  
		  // we SHOULD out of tokens !
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseSuccess
		  End If
		  
		  Return parseFailure
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CrackConstDeclaration(content as string, byref scope as string, byref constName as string, byref type as string, byref optionalDefault as string) As Boolean
		  #If debugBuild
		    Const debugThis = False
		  #Else
		    Const debugthis = False
		  #EndIf
		  
		  // note there are cases we are not handling in this simple grammar
		  // ie consts defined INSDE a method can use an expression to initialize them
		  //    outside they cant
		  // in a class module etc they can have a scope qualifier
		  // outside they cant it really makes not sense outside the confines of a module class etc
		  
		  // Const foo = "123"
		  // Const bar As Integer = 123
		  // 
		  // Class foo
		  //      Private Const abc As Integer = 123
		  // End Class
		  
		  
		  // constant:
		  //   [scope] CONST ident optionalConstType '=' constval
		  //
		  // scope 
		  //     /* empty string */
		  //   | PRIVATE 
		  //   | PUBLIC 
		  //   | GLOBAL 
		  // 
		  // constval:
		  // NUMBER                           
		  // |    REALNUMBER                  
		  // |    '-' NUMBER                  
		  // |    '-' REALNUMBER              
		  // |    Color                       
		  // |    String                      
		  // |    TRUE                     
		  // |    FALSE                    
		  // |    namedObjectType                    
		  // |    NIL                      
		  // 
		  // optionalConstType:
		  //    /* empty String*/                
		  //  | AS type
		  // 
		  // consts have a local scope version and a global scope version :(
		  // constantexp:
		  //  CONST IDENTIFIER constTypeOpt '='    exp 
		  //
		  // namedObjectType
		  //      ident
		  //    | additionalNameQualifier . ident 
		  //
		  // additionalNameQualifier
		  //     GLOBAL 
		  //   | namedObjectType 
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine(content, LanguageUtils.NoWhiteSpaceFlag)
		  
		  // empty string ?
		  If tokens.ubound < 0 Then 
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // default scope set up
		  scope = kScopePublic
		  If tokens(0) = kScopeGlobal _
		    Or tokens(0) = kScopeProtected _
		    Or tokens(0) = kScopePrivate _
		    Or tokens(0) = kScopePublic Then
		    scope = tokens(0) // got a valid scope 
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  If tokens(0) <> kCONST Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  Else
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // the const name 
		  If IsIdentifier( tokens(0) ) = False Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // the name is not an ident ?????
		  End If
		  constName = tokens(0)
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "const name" but nothing else ?????????
		  End If
		  
		  If tokens(0) = "as" Then
		    tokens.remove 0
		    
		    // out of tokens ?
		    If tokens.Ubound < 0 Then
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure // got maybe "const name as " but nothing else ?????????
		    End If
		    
		    // the type name now .. accept dotted names ?????
		    // this basically needs to be ident
		    // or  ident . ident . ident
		    Dim expectIdent As Boolean = True
		    While tokens.ubound >= 0 And tokens(0) <> "="
		      
		      Dim keepThisPiece As Boolean 
		      
		      If expectIdent Then
		        If (IsIdentifier(tokens(0)) Or IsBaseType(tokens(0))) Then
		          keepThisPiece = True
		        End If
		      Else
		        If tokens(0) = "." Then
		          keepThisPiece = True
		        End If
		      End If
		      
		      If keepThisPiece = False Then
		        #If debugThis
		          Break
		        #EndIf
		        Return parseFailure // type name is not ident or ident.ident.ident
		      End If
		      
		      type = type + tokens(0)
		      tokens.remove 0
		      
		      expectIdent = Not expectIdent
		    Wend
		    
		  End If
		  
		  // out of tokens ? 
		  // we either got "const foo as type"
		  //            or "const foo "
		  // either way this better be a =
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  If tokens(0) <> "=" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got "scope name as type =" ?
		  End If
		  
		  // we better have a value now
		  // hmmm but we could have an expression now in some cases ???????
		  optionalDefault = join(tokens,"")
		  tokens.remove 0
		  
		  // out of tokens ?
		  // that would be a good thing as we do not want cruft at the end
		  If tokens.Ubound < 0 Then
		    
		    // ok we need to guess at the type if this doesnt have on already
		    If type = "" Then
		      Select Case True
		      Case optionalDefault.Left(1) = """" And optionalDefault.Right(1) = """"
		        type = "String"
		      Case IsInteger(optionalDefault)
		        type = "Integer"
		      Case IsRealNumber(optionalDefault)
		        type = "Double"
		      Case optionalDefault = "True" Or optionalDefault = "False"
		        type = "Boolean"
		      Case optionalDefault.Left(2) = "&c"
		        type = "Color"
		      Case optionalDefault.Left(2) = "&h"
		        type = "Uinteger"
		      End Select
		    End If
		    Return parseSuccess // YAY !!!!!!!!!
		  End If
		  
		  #If debugThis
		    Break
		  #EndIf
		  Return parseFailure
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CrackEnumDeclaration(content as string, byref attrs as string, byref scope as string, byref enumName as string, byref type as string) As Boolean
		  #If debugBuild
		    Const debugThis = False
		  #Else
		    Const debugthis = False
		  #EndIf
		  
		  // note there are cases we are not handling in this simple grammar
		  // ie consts defined INSDE a method can use an expression to initialize them
		  //    outside they cant
		  // in a class module etc they can have a scope qualifier
		  // outside they cant it really makes not sense outside the confines of a module class etc
		  
		  // enum foo as uint8
		  //     val1 = 1
		  // end enum
		  //
		  // enum foo as uint8
		  //     val1
		  // end enum
		  // enum foo 
		  //     val1 = 1
		  // end enum
		  // enum foo 
		  //     val1
		  // end enum
		  
		  // attrs scope enum .........
		  
		  // Enum: 
		  //       TK_ENUM IDENTIFIER enumTypeOpt ENDL
		  //       enumValueList
		  //       TK_END TK_ENUM ENDL
		  // ;
		  // enumValueList:
		  //            /* empty String */                
		  //       |    enumValue                        
		  //       |    enumValueList enumValue          
		  // ;
		  // 
		  // enumValue:
		  //            IDENTIFIER enumValueOpt ENDL
		  // ;
		  // 
		  // enumValueOpt:
		  //           /* empty String */                
		  //       |   '=' constval                    
		  //       |   ASSIGN constval                 
		  // ;
		  // 
		  // enumTypeOpt:
		  //           /* empty String */                
		  //       |   TK_AS typeSpecifier               
		  // ;
		  // 
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine(content, LanguageUtils.NoWhiteSpaceFlag)
		  
		  // empty string ?
		  If tokens.ubound < 0 Then 
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  
		  // attributes ?
		  If tokens(0) = "ATTRIBUTES" Then
		    // should be ( key [= quoted value,]+.... )
		    tokens.remove 0
		    // empty string ?
		    If tokens.ubound < 0 Then 
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure
		    End If
		    If tokens(0) <> "(" Then
		      Return parseFailure
		    End If
		    tokens.remove 0
		    If tokens.ubound < 0 Then 
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure
		    End If
		    While tokens(0) <> ")"
		      attrs = attrs + tokens(0)
		      tokens.remove 0
		      If tokens.ubound < 0 Then 
		        #If debugThis
		          Break
		        #EndIf
		        Return parseFailure
		      End If
		    Wend
		    tokens.remove 0
		  End If
		  
		  // default scope set up
		  scope = kScopePublic
		  If tokens(0) = kScopeGlobal _
		    Or tokens(0) = kScopeProtected _
		    Or tokens(0) = kScopePrivate _
		    Or tokens(0) = kScopePublic Then
		    scope = tokens(0) // got a valid scope 
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  If tokens(0) <> kEnum Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  Else
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // the enum name 
		  If IsIdentifier( tokens(0) ) = False Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // the name is not an ident ?????
		  End If
		  type = "Integer"
		  enumName = tokens(0)
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseSuccess // got maybe "enum name" but nothing else ?????????
		  End If
		  
		  If tokens(0) = "as" Then
		    tokens.remove 0
		    
		    // out of tokens ?
		    If tokens.Ubound < 0 Then
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure // got maybe "enum name as " but nothing else ?????????
		    End If
		    
		    type = ""
		    
		    // the type name now .. accept dotted names ?????
		    // this basically needs to be ident
		    // or  ident . ident . ident
		    Dim expectIdent As Boolean = True
		    While tokens.ubound >= 0 And tokens(0) <> "="
		      
		      Dim keepThisPiece As Boolean 
		      
		      If expectIdent Then
		        If (IsIdentifier(tokens(0)) Or IsBaseType(tokens(0))) Then
		          keepThisPiece = True
		        End If
		      Else
		        If tokens(0) = "." Then
		          keepThisPiece = True
		        End If
		      End If
		      
		      If keepThisPiece = False Then
		        #If debugThis
		          Break
		        #EndIf
		        Return parseFailure // type name is not ident or ident.ident.ident
		      End If
		      
		      type = type + tokens(0)
		      tokens.remove 0
		      
		      expectIdent = Not expectIdent
		    Wend
		    
		  End If
		  
		  // out of tokens ? 
		  // we either got "enum foo as type"
		  //            or "enum foo "
		  If tokens.Ubound > -1 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  Return parseSuccess // YAY !!!!!!!!!
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CrackEventDeclaration(content as string, byref attrs as string, byref scope as string, byref subFunc as string, byref methodName as string, byref params as string, byref returntype as string) As Boolean
		  #If debugBuild
		    Const debugThis = false
		  #Else
		    Const debugthis = False
		  #EndIf
		  // EVENT\s([^(]*)\((.*)\)\s*(as\s*(.*))?
		  // 
		  // IDENTICAL to a SUB FUNC just that we have only EVENT
		  
		  // strip content to make sure we basically got ONE line
		  Dim lines() As String = Split(ReplaceLineEndings(Trim(content), EndOfLine), EndOfLine)
		  
		  If lines.ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine(lines(0), LanguageUtils.NoWhiteSpaceFlag)
		  
		  scope = kScopePrivate
		  
		  // empty string ?
		  If tokens.ubound < 0 Then 
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // attributes ?
		  If tokens(0) = "ATTRIBUTES" Then
		    // should be ( key [= quoted value,]+.... )
		    tokens.remove 0
		    // empty string ?
		    If tokens.ubound < 0 Then 
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure
		    End If
		    If tokens(0) <> "(" Then
		      Return parseFailure
		    End If
		    tokens.remove 0
		    If tokens.ubound < 0 Then 
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure
		    End If
		    While tokens(0) <> ")"
		      attrs = attrs + tokens(0)
		      tokens.remove 0
		      If tokens.ubound < 0 Then 
		        #If debugThis
		          Break
		        #EndIf
		        Return parseFailure
		      End If
		    Wend
		    tokens.remove 0
		  End If
		  
		  // EVENT
		  If tokens(0) <> "EVENT" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  subFunc = tokens(0)
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  If IsIdentifier( tokens(0) ) = False Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // the name is not an ident ?????
		  End If
		  methodName = tokens(0)
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name" but nothing else ?????????
		  End If
		  
		  If tokens(0) <> "(" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure 
		  End If
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name ( " but nothing else ?????????
		  End If
		  
		  // params
		  // params:
		  // /* empty String */
		  // |    param
		  // |    params , param
		  
		  // param :
		  //   ident as type
		  // | ident( arrayspecList ) as type
		  
		  // arrayspecList :            // allows for () or (,) or (,,,) etc
		  //   /* empty String */
		  //   arrayspeclist , arrayspec
		  
		  // arrayspec
		  //   /* empty String */
		  
		  // we SHOULD be able to read any old token until we get to the closing matching paren
		  // we're not really tryng to validate the code is going to compile
		  // we just want to make sure that whatever is in ( ) is all picked up as "params"
		  // and that the ( and ) are "balanced"
		  Dim parenthesisCount As Integer = 1
		  While tokens.ubound >= 0 And parenthesisCount > 0
		    
		    If tokens(0) = "(" Then
		      parenthesisCount = parenthesisCount + 1
		      params = params + tokens(0)
		    Elseif tokens(0) = ")" Then
		      parenthesisCount = parenthesisCount - 1
		      If parenthesisCount > 0 Then
		        params = params + tokens(0)
		      end if
		    Else
		      
		      If tokens(0) = "." Then // a . we dont put spaces before
		      Elseif Right(params,1) = "." Then // and we dont put one after a . either
		      Else
		        If params <> "" Then
		          params = params + " "
		        End If
		      End If
		      
		      params = params + tokens(0)
		    End If
		    tokens.remove 0
		    
		  Wend
		  
		  // events do NOT clue us in ahead of time whether they retun a value or not
		  
		  // IF we're a FUNCTION then we should have "as typename"
		  // but as a SUB we exit here IF things are OK
		  If parenthesisCount <> 0 Then 
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure  // failed parse for a SUB - unclosed (
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseSuccess 
		  End If
		  
		  // we're a func !
		  // should have an AS type
		  If tokens(0) <> "as" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure 
		  End If
		  tokens.remove 0
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name ( ) as .... and no more ?
		  End If
		  
		  // the type name now .. accept dotted names ?????
		  // this basically needs to be ident, or ident(), or ident(,,,)
		  // or  ident . ident . ident, or  ident . ident . ident () 
		  // or  ident . ident . ident(,,,,)
		  Const kExpectIdent = 1
		  Const kExpectDot = 2
		  Const kExpectDotOrBracket = 3
		  Const kExpectCloseBracket = 4
		  Dim expect As Integer = kExpectIdent
		  Dim returnsArrayType As Boolean
		  
		  While tokens.ubound >= 0 And tokens(0) <> "="
		    
		    Select Case expect
		      
		    Case kExpectIdent
		      If IsIdentifier(tokens(0)) Or IsBaseType(tokens(0)) Or (tokens(0) = "Object") Then
		        returntype = returntype + tokens(0)
		        tokens.remove 0
		      Else
		        #If debugThis
		          Break
		        #EndIf
		        Return parseFailure // type name is not ident or ident.ident.ident
		      End If
		      expect = kExpectDotOrBracket
		      
		    Case kExpectDotOrBracket
		      If tokens(0) = "." Then
		        returntype = returntype + tokens(0)
		        tokens.remove 0
		        expect = kExpectIdent
		      Elseif tokens(0) = "(" Then
		        tokens.remove 0
		        returnsArrayType = True
		        expect = kExpectCloseBracket
		      End If
		      
		    Case kExpectCloseBracket
		      If tokens(0) = ")" Then
		        
		        tokens.remove 0
		        Exit While
		      Else
		        // eat toekns until we get to the close )
		        tokens.remove 0
		        
		      End If
		      
		    End Select
		    
		  Wend
		  If returnsArrayType Then
		    returntype = returntype + "()"
		  End If
		  
		  // out of tokens ?
		  // at this point we have a FULL Declaration so we can start saying "yup this is OK"
		  If tokens.Ubound < 0 Then
		    Return parseSuccess // YAY !!!!!!!!! got "scope name( params ) as type"
		  End If
		  
		  // theres more ?????????
		  #If debugThis
		    Break
		  #EndIf
		  Return parseFailure
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CrackMethodDeclaration(content as string, byref attrs as string, byref scope as string, byref subFunc as string, byref methodName as string, byref params as string, byref returntype as string) As Boolean
		  #If debugBuild
		    Const debugThis = false
		  #Else
		    Const debugthis = False
		  #EndIf
		  
		  // // ^ATTRIBUTES(...)(PRIVATE|PUBLIC|FRIEND|GLOBAL)?\s*(STATIC)?\s*(SUB|FUNCTION)\s([^(]*)\((.*)\)\s*(as\s*(.*))?
		  // 
		  // [scope] (STATIC) ????? (SUB | FUNCTION) ident ( paramList ) as returnType
		  // scope :
		  //     /* empty string */
		  //   | PRIVATE
		  //   | PUBLIC
		  //   | GLOBAL
		  
		  // ident ... what can I say - any identified just not a reserved word
		  //
		  // paramlist we dont really care as we just match up the outmost ( and )
		  // they just have to balance (if we crack parms then we would care)
		  //
		  // returnType :
		  //     intrinsicType 
		  //   | namedObjectType
		  //
		  // intrinsicType :
		  //       string integer double etc
		  //
		  // namedObjectType
		  //      ident
		  //    | additionalNameQualifier . ident 
		  //
		  // additionalNameQualifier
		  //     GLOBAL 
		  //   | namedObjectType 
		  
		  // strip content to make sure we basically got ONE line
		  Dim lines() As String = Split(ReplaceLineEndings(Trim(content), EndOfLine), EndOfLine)
		  
		  If lines.ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine(lines(0), LanguageUtils.NoWhiteSpaceFlag)
		  
		  // empty string ?
		  If tokens.ubound < 0 Then 
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // attributes ?
		  If tokens(0) = "ATTRIBUTES" Then
		    // should be ( key [= quoted value,]+.... )
		    tokens.remove 0
		    // empty string ?
		    If tokens.ubound < 0 Then 
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure
		    End If
		    If tokens(0) <> "(" Then
		      Return parseFailure
		    End If
		    tokens.remove 0
		    If tokens.ubound < 0 Then 
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure
		    End If
		    While tokens(0) <> ")"
		      attrs = attrs + tokens(0)
		      tokens.remove 0
		      If tokens.ubound < 0 Then 
		        #If debugThis
		          Break
		        #EndIf
		        Return parseFailure
		      End If
		    Wend
		    tokens.remove 0
		  End If
		  
		  // default scope set up
		  // scope :
		  //     /* empty string */
		  //   | PRIVATE
		  //   | PUBLIC
		  //  | GLOBAL
		  scope = kScopePublic
		  If tokens(0) = kScopeGlobal _
		    Or tokens(0) = kScopeProtected _ 
		    Or tokens(0) = kScopePrivate _
		    Or tokens(0) = kScopePublic Then
		    scope = tokens(0) // got a valid scope 
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // SUB FUNC ?
		  If tokens(0) <> "SUB" And tokens(0) <> "FUNCTION" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  subFunc = tokens(0)
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  If IsIdentifier( tokens(0) ) = False Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // the name is not an ident ?????
		  End If
		  methodName = tokens(0)
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name" but nothing else ?????????
		  End If
		  
		  If tokens(0) <> "(" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure 
		  End If
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name ( " but nothing else ?????????
		  End If
		  
		  // params
		  // params:
		  // /* empty String */
		  // |    param
		  // |    params , param
		  
		  // param :
		  //   ident as type
		  // | ident( arrayspecList ) as type
		  
		  // arrayspecList :            // allows for () or (,) or (,,,) etc
		  //   /* empty String */
		  //   arrayspeclist , arrayspec
		  
		  // arrayspec
		  //   /* empty String */
		  
		  // we SHOULD be able to read any old token until we get to the closing matching paren
		  // we're not really tryng to validate the code is going to compile
		  // we just want to make sure that whatever is in ( ) is all picked up as "params"
		  // and that the ( and ) are "balanced"
		  Dim parenthesisCount As Integer = 1
		  While tokens.ubound >= 0 And parenthesisCount > 0
		    
		    If tokens(0) = "(" Then
		      parenthesisCount = parenthesisCount + 1
		      params = params + tokens(0)
		    Elseif tokens(0) = ")" Then
		      parenthesisCount = parenthesisCount - 1
		      If parenthesisCount > 0 Then
		        params = params + tokens(0)
		      end if
		    Else
		      
		      If tokens(0) = "." Then // a . we dont put spaces before
		      Elseif Right(params,1) = "." Then // and we dont put one after a . either
		      Else
		        If params <> "" Then
		          params = params + " "
		        End If
		      End If
		      
		      params = params + tokens(0)
		    End If
		    tokens.remove 0
		    
		  Wend
		  
		  // IF we're a FUNCTION then we should have "as typename"
		  // but as a SUB we exit here IF things are OK
		  If subFunc = "SUB" Then
		    If tokens.ubound > -1 Then
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure  // failed parse for a SUB 
		    Elseif parenthesisCount <> 0 Then 
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure  // failed parse for a SUB - unclosed (
		    Else
		      Return parseSuccess // SUCCESSFUL FOR A SUB !!!!!!!!
		    End If
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name () " but nothing else ?????????
		  End If
		  
		  // we're a func !
		  // should have an AS type
		  If tokens(0) <> "as" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure 
		  End If
		  tokens.remove 0
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name ( ) as .... and no more ?
		  End If
		  
		  // the type name now .. accept dotted names ?????
		  // this basically needs to be ident, or ident(), or ident(,,,)
		  // or  ident . ident . ident, or  ident . ident . ident () 
		  // or  ident . ident . ident(,,,,)
		  Const kExpectIdent = 1
		  Const kExpectDot = 2
		  Const kExpectDotOrBracket = 3
		  Const kExpectCloseBracket = 4
		  Dim expect As Integer = kExpectIdent
		  Dim returnsArrayType As Boolean
		  
		  While tokens.ubound >= 0 And tokens(0) <> "="
		    
		    Select Case expect
		      
		    Case kExpectIdent
		      If IsIdentifier(tokens(0)) Or IsBaseType(tokens(0)) Or (tokens(0) = "Object") Then
		        returntype = returntype + tokens(0)
		        tokens.remove 0
		      Else
		        #If debugThis
		          Break
		        #EndIf
		        Return parseFailure // type name is not ident or ident.ident.ident
		      End If
		      expect = kExpectDotOrBracket
		      
		    Case kExpectDotOrBracket
		      If tokens(0) = "." Then
		        returntype = returntype + tokens(0)
		        tokens.remove 0
		        expect = kExpectIdent
		      Elseif tokens(0) = "(" Then
		        tokens.remove 0
		        returnsArrayType = True
		        expect = kExpectCloseBracket
		      End If
		      
		    Case kExpectCloseBracket
		      If tokens(0) = ")" Then
		        
		        tokens.remove 0
		        Exit While
		      Else
		        // eat toekns until we get to the close )
		        tokens.remove 0
		        
		      End If
		      
		    End Select
		    
		  Wend
		  If returnsArrayType Then
		    returntype = returntype + "()"
		  End If
		  
		  // out of tokens ?
		  // at this point we have a FULL Declaration so we can start saying "yup this is OK"
		  If tokens.Ubound < 0 Then
		    Return parseSuccess // YAY !!!!!!!!! got "scope name( params ) as type"
		  End If
		  
		  // theres more ?????????
		  #If debugThis
		    Break
		  #EndIf
		  Return parseFailure
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CrackParams(paramString as String) As LanguageUtils.LocalVariable()
		  ' params:
		  '    /* empty String */          
		  '    |    param
		  '    |    params ',' param       
		  '    ;
		  ' 
		  ' param:
		  '    paramModifierList               /* blank, ByVal, ByRef, etc. */
		  '    declident                       /* name Of the parameter */
		  '    paramtypeclause                 /* type, including Optional Array parens */
		  '    defaultparamvalopt              /* default value For parameter, */
		  '    ;
		  ' 
		  ' paramModifierList:
		  '    /* empty */                        
		  '    |    paramModifierList paramModifier
		  '    ;
		  ' 
		  ' paramModifier:
		  '      TK_BYVAL                     
		  '    | TK_BYREF                
		  '    | TK_ASSIGNS              
		  '    | TK_EXTENDS              
		  '    | TK_PARAMARRAY           
		  '    | TK_OPTIONAL             
		  '    ;
		  ' 
		  ' declident:
		  '      IDENTIFIER
		  '    | TK_ME
		  '    ;
		  ' 
		  ' paramtypeclause:
		  '      TK_AS typeSpecifier
		  '    | arrayRankSpecifier TK_AS typeSpecifier
		  '    ;
		  ' 
		  ' typeSpecifier:
		  '    namePath
		  ' ;
		  '
		  ' arrayRankSpecifier:    
		  '    '(' arrayRankCommaList ')'
		  '    ;
		  ' 
		  ' arrayRankCommaList:
		  '      /* empty */
		  '    | arrayRankCommaList ','
		  '    ;
		  
		  Dim result() As LanguageUtils.LocalVariable
		  // we fake this into being a DIM line
		  If paramString.Left(4) <> "DIM " Then
		    FindVarDeclarations("DIM " + paramString, 1, result)
		  Else
		    FindVarDeclarations(paramString, 1, result)
		  End If
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CrackPropertyDeclaration(content as string, byref isShared as boolean, byref scope as string, byref propName as string, byref isNew as boolean, byref type as string, byref optionalDefault as string, allowPROPERTY as boolean = false) As Boolean
		  #If debugBuild
		    Const debugThis = False
		  #Else
		    Const debugthis = False
		  #EndIf
		  
		  isShared = False
		  scope = kScopePublic
		  propName = ""
		  isNew = False
		  type = "Integer"
		  optionalDefault = ""
		  
		  // note there are cases that we arent handling in this simple grammar like
		  //   foo As Integer <<<<<<<<<< not legal like this outside a class or module
		  //   STATIC -- only allowed IN a method in a class or module otherwise invalid
		  // 
		  //   class bar 
		  //       foo As Integer <<<<<<<<<< not legal like this outside a class or module
		  //       dim foo As Integer
		  //       private dim foo as string
		  //       Private foo As Integer
		  //       Public foo As Integer
		  //       --- global foo As Integer <<<<<<< not ok
		  //       --- Static foo As Integer <<<<<<< not ok
		  //       Public shared foo As Integer
		  //   end class
		  
		  // Module baz
		  //   dim foo As Integer
		  //   Private foo As Integer
		  //   Public foo As Integer
		  //   global foo As Integer
		  //   --- Static foo As Integer  <<<<<<< not ok
		  // 
		  //   Sub something()
		  //     dim foo As Integer
		  //     --- Private foo As Integer  <<<<<<< not ok
		  //     --- Public foo As Integer  <<<<<<< not ok
		  //     --- global foo As Integer  <<<<<<< not ok
		  //     Static foo As Integer
		  //     --- shared Public foo As Integer  <<<<<<< not ok
		  //   End Sub
		  // 
		  // End Module
		  
		  
		  // [scope] ident as [typeAndDefault]
		  //
		  // scope 
		  //     /* empty string */
		  //   | PRIVATE dimOrStatic
		  //   | PUBLIC dimOrStatic
		  //   | GLOBAL dimOrStatic
		  //   | DIM - usable almost everywhere
		  //   | STATIC -- only allowed IN a method in a class or module otherwise invalid 
		  // 
		  // dimOrStatic
		  //     /* empty string */
		  //   | DIM
		  //   | STATIC
		  //
		  // ident ... what can I say - any identified just not a reserved word
		  //
		  // type
		  //     intrinsicType 
		  //   | namedObjectType
		  //
		  // typeAndDefault
		  //     intrinsicType optionalDefault
		  //   | namedObjectType
		  //   | newInstance
		  // 
		  // newInstance :
		  //     NEW  intrinsicType optionalDefault
		  //   | NEW namedObjectType
		  
		  // intrinsicType : 
		  //       string integer double etc
		  //
		  // optionalDefault :
		  //     /* empty string */
		  //   | = literal (perferably one that matches the intrinsic type but we cant enforce that in the grammar)
		  //
		  // namedObjectType
		  //      ident
		  //    | additionalNameQualifier . ident 
		  //
		  // additionalNameQualifier
		  //     GLOBAL 
		  //   | namedObjectType 
		  
		  // optionally we permit the use of a style like
		  //     Public PROPERTY foo As Integer
		  // which, if you copy properties from the IDE, is what IT writes (which is wrong but ....)
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine(content, LanguageUtils.NoWhiteSpaceFlag)
		  
		  // empty string ?
		  If tokens.ubound < 0 Then 
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // default scope set up
		  scope = kScopePublic
		  If tokens(0) = kScopeGlobal _
		    Or tokens(0) = kScopeProtected _
		    Or tokens(0) = kScopePrivate _
		    Or tokens(0) = kScopePublic Then
		    scope = tokens(0) // got a valid scope 
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // shared ?
		  If tokens(0) = "Shared" Then
		    isShared = True
		    tokens.remove 0
		  End If
		  
		  // if we got a private , global, public etc we can skip DIM / STATIC
		  // we CAN have one but dont require it
		  // if not then we need one or the other
		  If allowPROPERTY And tokens(0) = kProperty Then
		    tokens.Remove 0
		  elseIf scope = "" And ( tokens(0) <> kDIM And tokens(0) <> kSTATIC ) Then
		    // REQUIRES a DIM or STATIC 
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		    
		  Elseif tokens(0) = kDIM Or tokens(0) = kSTATIC Then
		    // OPTIONAL dim or STATIC
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  
		  // the prop name 
		  If IsIdentifier( tokens(0) ) = False Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // the name is not an ident ?????
		  End If
		  propName = tokens(0)
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name" but nothing else ?????????
		  End If
		  
		  If tokens(0) <> "as" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure 
		  End If
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name as " but nothing else ?????????
		  End If
		  
		  // we _could_ get a "new" at this point
		  // and this parser does NOT try to validate something like
		  //    NEW integer
		  //  which is the job of the semantic analysis
		  If tokens(0) = "NEW" Then
		    #If debugThis
		      Break
		    #EndIf
		    isNew = True
		    tokens.remove 0
		  End If
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got maybe "scope name as " but nothing else ?????????
		  End If
		  
		  // the type name now .. accept dotted names ?????
		  // this basically needs to be ident
		  // or  ident . ident . ident
		  Dim expectIdent As Boolean = True
		  type = ""
		  While tokens.ubound >= 0 And tokens(0) <> "="
		    
		    Dim keepThisPiece As Boolean 
		    
		    If expectIdent Then
		      If (IsIdentifier(tokens(0)) Or IsBaseType(tokens(0))) Then
		        keepThisPiece = True
		      End If
		    Else
		      If tokens(0) = "." Then
		        keepThisPiece = True
		      End If
		    End If
		    
		    If keepThisPiece = False Then
		      #If debugThis
		        Break
		      #EndIf
		      Return parseFailure // type name is not ident or ident.ident.ident
		    End If
		    
		    type = type + tokens(0)
		    tokens.remove 0
		    
		    expectIdent = Not expectIdent
		  Wend
		  
		  // out of tokens ?
		  // at this point we have a FULL Declaration so we can start saying "yup this is OK"
		  If tokens.Ubound < 0 Then
		    Return parseSuccess // YAY !!!!!!!!! got "scope name as type"
		  End If
		  
		  // whoops more tokens so we better have a = (if we are NOT computed !)
		  
		  If tokens(0) <> "=" Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure
		  End If
		  tokens.remove 0
		  
		  // out of tokens ?
		  If tokens.Ubound < 0 Then
		    #If debugThis
		      Break
		    #EndIf
		    Return parseFailure // got "scope name as type =" ?
		  End If
		  
		  optionalDefault = tokens(0)
		  tokens.remove 0
		  
		  // out of tokens ?
		  // that would be a good thing as we do not want cruft at the end
		  If tokens.Ubound < 0 Then
		    Return parseSuccess // YAY !!!!!!!!!
		  End If
		  
		  #If debugThis
		    Break
		  #EndIf
		  Return parseFailure
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DetailedErrorIf(errCondition As Boolean, details As String)
		  // Unit testing code calls this function to check if an error has
		  // occurred.  If so, report it to the user and then break into
		  // the debugger so he can do something about it.
		  
		  If Not errCondition Then 
		    Return
		  End If
		  
		  MsgBox "Unit test failure : " + EndOfLine + EndOfLine + details
		  
		  break  // OK, now look at the stack to see what went wrong!
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EndsInComment(source As String) As Boolean
		  // Return whether the given line of source code ends in a comment.
		  
		  return CommentStartPos(source) > 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EndsInLineContinuation(source As String) As Boolean
		  // Return whether the given line ends in a line-continuation token ("_"),
		  // possibly followed by a comment.  (If so, then the next line is a
		  // logical continuation of this one.)
		  
		  return LineContinuationPoint( source ) > 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ErrorIf(errCondition As Boolean, msg As String = "")
		  
		  // Unit testing code calls this function to check if an error has
		  // occurred.  If so, report it to the user and then break into
		  // the debugger so he can do something about it.
		  
		  If Not errCondition Then 
		    Return
		  End If
		  
		  If msg = "" Then
		    msg = "Unit Test Failure :"
		  End If
		  
		  #If DebugBuild
		    //msg = msg + EndOfLine + EndOfLine _
		    //+ "Click OK to drop into the debugger and examine the stack."
		  #EndIf
		  MsgBox msg
		  
		  
		  Break  // OK, now look at the stack to see what went wrong!
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Expect(expected() as string, tokens() as string, byref result as string) As boolean
		  // sees if tokens(0) is in the list of expected tokens
		  // if so it sets result to that token and returns true
		  // if not return false and does not alter tokens, or expected
		  
		  result = ""
		  If expected.Count <= 0 Then
		    Return True
		  End If
		  
		  If tokens.count <= 0 Then
		    Return False
		  End If
		  
		  // we expect to find token(0) as one of the "expected" tokens
		  
		  For Each expectedToken As String In expected
		    If tokens(0) = expectedToken Then
		      result = tokens(0)
		      tokens.Remove 0
		      Return True
		    End If
		  Next
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FindAnyInStr(startPos As Integer, source As String, findSet As String) As Integer
		  // This is like InStr, except that instead of searching for just a single
		  // character, we search for any character in a set.
		  
		  Dim i, maxi As Integer
		  maxi = Len( source )
		  Dim c As String
		  for i = startPos to maxi
		    c = Mid( source, i, 1 )
		    If InStr( findSet, c ) > 0 Then
		      // found one!
		      return i
		    end if
		  next
		  
		  return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FindOpeningParen(source As String, closePosB As Integer) As Integer
		  // Find the opening parenthesis that matches the one at closePosB
		  // in source.  Return its 1-based byte offset, or 0 if not found.
		  
		  Dim posB As Integer
		  Dim c As String
		  
		  Dim inQuote As Boolean
		  Dim closeCount As Integer = 1
		  for posB = closePosB - 1 DownTo 1
		    c = Mid( source, posB, 1 )
		    if c = """" then
		      inQuote = not inQuote
		    elseif c = ")" and not inQuote then
		      closeCount = closeCount + 1
		    elseif c = "(" and not inQuote then
		      closeCount = closeCount - 1
		      If closeCount = 0 Then 
		        Exit
		      End If
		    end if
		  next
		  
		  return posB
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub FindVarDeclarations(sourceLine As String, lineNum As Integer, outVars() As LocalVariable)
		  Const kIdentExpected = 1
		  Const kAsExpected = 2
		  Const kTypeExpected = 4
		  Const kInValueExpr = 8
		  Const kCommaExpected = 16
		  Const kOpenBracketExpected = 32
		  Const kCloseBracketExpected = 64
		  
		  // Find variable declarations in the given line.
		  // Append them to outVars.
		  Redim outvars(-1)
		  
		  Dim tokens() As String = TokenizeLine(sourceLine, LanguageUtils.NoWhiteSpaceFlag)
		  Dim accumulate_default As Boolean = True
		  
		  If tokens.ubound < 0 Then
		    Return
		  End If
		  
		  Dim isConstDecl As Boolean
		  
		  // attributes ?
		  // scope ?
		  // func | sub ?
		  Dim content, attrs, scope, subFunc, methodName, params, returntype, className As String
		  
		  If CrackClassDeclaration(sourceline, attrs, scope, className) = True Then
		    Return
		    
		  ElseIf CrackMethodDeclaration(sourceline, attrs, scope, subFunc, methodName, params, returntype) = True Then
		    
		    tokens = TokenizeLine(params,  LanguageUtils.NoWhiteSpaceFlag)
		    
		  ElseIf CrackEventDeclaration(sourceline, attrs, scope, subFunc, methodName, params, returntype) = True Then
		    
		    tokens = TokenizeLine(params,  LanguageUtils.NoWhiteSpaceFlag)
		    
		  ElseIf tokens(0) = "Const" Then
		    // We can just grab the next token as the local variable. 
		    isConstDecl = True
		    
		    tokens.remove 0 
		    
		  ElseIf tokens(0) = "Dim" Then
		    
		    tokens.remove 0 
		    
		  ElseIf tokens(0) = "Static" Then
		    
		    tokens.remove 0 
		    
		  ElseIf tokens(0) = "Var" Then
		    
		    tokens.remove 0 
		    
		  ElseIf tokens(0) = "For" Then
		    accumulate_default = False
		    
		    tokens.remove 0 
		    
		    If tokens(0) = "each" Then
		      tokens.remove 0 
		    End If
		    
		  ElseIf tokens(0) = "Enum" Then
		    
		    Return
		    
		  Else
		    // may happen with properties in classes
		    // which are written just as 
		    // name as type
		    
		    // this could be i,j,k as ..... ident, ident, ident
		    //               i(), j(), k
		    //               i(xx,xx), j, k etc
		    Dim state As Integer = kIdentExpected
		    For i As Integer = 0 To tokens.ubound
		      
		      If (state And kIdentExpected) = kIdentExpected And IsIdentifier( tokens(i) ) Then
		        state = kCommaExpected + kAsExpected + kOpenBracketExpected
		        Continue
		      ElseIf (state And kCommaExpected) = kCommaExpected And tokens(i) = "," Then
		        state = kIdentExpected
		        Continue
		      ElseIf (state And kOpenBracketExpected) = kOpenBracketExpected And tokens(i) = "(" Then
		        Dim openCount As Integer = 1
		        i = i + 1
		        While i <= tokens.ubound And openCount > 0
		          If tokens(i) = "(" Then
		            openCount = openCount + 1
		          ElseIf tokens(i) = ")" Then
		            openCount = openCount - 1
		          End If
		          i = i + 1
		        Wend
		        If openCount = 0 Then
		          i = i - 1
		          Continue
		        Else
		          Break
		          Return // we got something like i( with no close
		        End If
		        
		      ElseIf (state And kAsExpected) = kAsExpected And tokens(i) = "as" Then
		        // sure looks like a var decl on this line .. so we go find em
		        Exit For
		      Else
		        Return
		      End If
		      
		    Next i
		    
		  End If
		  
		  
		  Dim mode As Integer = kIdentExpected
		  Dim openBrackets As Integer
		  Dim bounds_str As String
		  
		  While tokens.count > 0
		    
		    Dim token As String = tokens(0)
		    
		    Select Case mode
		      
		    Case kIdentExpected
		      
		      If token = "ByRef" Or token = "ByVal" Or token = "Assigns" Or token = "Extends" Or token = "Optional" Or token = "ParamArray" Then
		        // skip param modifier
		      Else
		        outVars.Append New LocalVariable( token, "", lineNum )
		        
		        mode = kAsExpected
		      End If
		      
		    Case kAsExpected 
		      
		      If token = "(" Then
		        // skip everything until we get to a closing ")"
		        outVars(UBound(outVars)).isArray = True // (we'll prepend the actual type name below)
		        openBrackets = openBrackets + 1
		        
		      ElseIf token = "As" Then
		        mode = kTypeExpected
		        
		      ElseIf token = "New" Then
		        // skip "New"; it's just inserted before the type, which we should already expect
		        outVars(UBound(outVars)).requiresnew = True
		        
		      ElseIf token = ")" Then
		        openBrackets = openBrackets - 1
		        
		        If openBrackets = 0 Then
		          If outVars(UBound(outVars)).isarray = True Then
		            outVars(UBound(outVars)).bounds = bounds_str
		          End If
		          bounds_str = ""
		          
		          mode = kAsExpected
		        Else
		          bounds_str = bounds_str + token
		        End If
		        
		      ElseIf token = "," Then
		        
		        If openBrackets = 0 Then
		          mode = kIdentExpected
		        Else
		          bounds_str = bounds_str + token
		        End If
		        
		      ElseIf isConstDecl And token = "=" Then
		        
		        mode = kInValueExpr
		      ElseIf openBrackets > 0 Then
		        bounds_str = bounds_str + token
		      End If
		      
		    Case kTypeExpected
		      
		      If token = "New" Then
		        // skip the NEW whatever
		        outVars(UBound(outVars)).requiresnew = True
		        
		      Else
		        // ok if the next token is a "." then we should accumulate all the "type as "name.name.name."
		        Dim actualType As String
		        
		        Do
		          
		          actualType = actualType + tokens(0)
		          tokens.remove 0 
		          
		        Loop Until tokens.count <= 0 Or (tokens(0) <> "."  And IsIdentifier(tokens(0)) = False)
		        
		        For i As Integer = outvars.Ubound DownTo 0
		          
		          If outVars(i).type = "" Then
		            outVars(i).type = actualType + If(outVars(i).IsArray,"()","")
		          Else
		            Exit For
		          End If
		          
		        Next
		        
		        mode = kCommaExpected
		        
		        Continue // skip the pos + 1 below
		      End If
		      
		    Case kCommaExpected
		      
		      If token = "," Then
		        mode = kIdentExpected
		      ElseIf token = "=" Then
		        mode = kInValueExpr
		      End If
		      
		    Case kInValueExpr
		      Dim default As String 
		      
		      Do 
		        
		        default =  default + tokens(0)
		        tokens.remove 0
		        
		      Loop Until tokens.count <= 0 Or tokens(0) = "," Or tokens(0) = ")"
		      
		      If accumulate_default = True Then
		        outVars(outVars.Ubound).default_value_str = default
		      End If
		      
		      If tokens.count > 0 Then
		        If tokens(0) = "," Then
		          tokens.remove 0
		        ElseIf tokens(0) = ")" Then
		          tokens.remove 0
		        End If
		      End If
		      mode = kIdentExpected
		      
		      Continue // skip the pos + 1 below
		      
		    End Select
		    
		    tokens.remove 0
		  Wend
		  
		  If isConstDecl Then
		    
		    // check that the consts declared have types and if not then try the const expr to see what type they might be 
		    For i As Integer = 0 To outVars.Ubound
		      
		      If outVars(i).type = "" Then
		        
		        Select Case True
		        Case IsInteger(outVars(i).default_value_str)
		          outVars(i).type = "Integer"
		        Case IsColor(outVars(i).default_value_str)
		          outVars(i).type = "Color"
		        Case IsBoolean(outVars(i).default_value_str)
		          outVars(i).type = "Boolean"
		        Case IsRealNumber(outVars(i).default_value_str)
		          outVars(i).type = "Double"
		        Case outVars(i).default_value_str.Left(1)="""" And outVars(i).default_value_str.Right(1)="""" 
		          outVars(i).type = "String"
		        Else
		          Break
		        End Select
		        
		      End If
		      
		    Next
		    
		  End If
		  
		  For i As Integer = outvars.ubound DownTo 0
		    If Trim(outvars(i).type) = "" Then
		      outvars.Remove i
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FirstToken(source As String) As String
		  // Return the first token of the given source.
		  
		  Dim readtoken As Token = NextToken( source, 1 )
		  Return readtoken.stringvalue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IdentifierFromText(text As String) As String
		  // Given some text like "Cool Stuff...", make a legal RB
		  // identifier like "CoolStuff".  In other words, strip out
		  // all the characters which aren't legal within an identifier.
		  
		  Dim c, out As String
		  Dim i As Integer
		  
		  text = text.ConvertEncoding( Encodings.UTF8 )
		  for i = 1 to Len(text)
		    c = Mid(Text, i, 1)
		    if (c >= "a" and c <= "z") or (c >= "A" and c <= "Z") _
		      or (out.Len > 0 and c >= "0" and c <= "9") or c = "_" then
		      out = out + c
		    end if
		  next
		  
		  return out
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsBaseType(token As String) As Boolean
		  // Return whether the given token is one of our base types.
		  Return token = "Auto" Or _
		  token = "Boolean" Or _
		  token = "CFStringRef" Or token = "CGFloat" Or token = "Color" Or token = "CString" Or token = "Currency" Or _
		  token = "Delegate" Or token = "Double" Or _
		  token = "Int16" Or token = "Int32" Or token = "Int64" Or token = "Int8" Or token = "Integer" Or _
		  token = "Object" Or token = "OSType" Or _
		  token = "PString" Or token = "Ptr" Or _
		  token = "Short" Or token = "Single" Or token = "String" Or _
		  token = "Text" Or _
		  token = "UInt16" Or token = "UInt32" Or token = "UInt64" Or token = "UInt8" Or token = "UInteger" Or _
		  token = "Variant" Or _
		  token = "WindowPtr" Or token = "WString" 
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsBlockStart(previousLineText as string, byref blockEnder as string) As boolean
		  blockEnder = BlockCloser(previousLineText)
		  If blockEnder <> "" Then 
		    Return True
		  End If
		  
		  Dim attrs As String
		  Dim scope As String
		  Dim subFunc As String
		  Dim codeItemName As String
		  Dim params As String
		  Dim returntype As String
		  
		  If LanguageUtils.CrackMethodDeclaration(previousLineText, attrs, scope, subFunc, codeItemName, params, returntype) Then
		    blockEnder = BlockCloser(subFunc)
		    Return True
		  End If
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsBoolean(token as String) As Boolean
		  // Check to see whether the token is a boolean literal
		  
		  Return token = "true" or token = "false"
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsColor(token as String) As Boolean
		  // Check to see whether the token is a color literal
		  
		  // oddly all it needs its "&c" as the beginning and maybne nothing else :P
		  // dont believe me just uncomment this
		  ' Dim c As Color 
		  ' c = &c
		  
		  Return token.Left(2) = "&c" 
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsComment(token As String) As Boolean
		  // Return whether the given token is a comment.
		  
		  // First check for the case where it's nothing but a comment.
		  If token = "'" Or token = "//" Or token = "REM" Then 
		    Return True
		  End If
		  
		  // Then, check for a comment followed by something else;
		  // the only tricky case here is REM, which could also be
		  // the start of an identifier.
		  Return Left(token, 1) = "'" _
		  Or Left(token, 2) = "//" _
		  or Left(token, 4) = "REM "
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsDigit(c As String) As Boolean
		  // Return whether the first character of c is a digit (0 - 9).
		  
		  Dim ascC As Integer = Asc(c)
		  
		  return ascC >= &h30 and ascC <= &h39
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsEndOfFunctionLine(line as string) As boolean
		  // END FUNCTION (rem // or ') nothing else
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine(line.Trim, LanguageUtils.NoWhiteSpaceFlag)
		  
		  If tokens.Ubound < 1 Then 
		    Return False
		  End If
		  If tokens(0) <> "End" Then
		    Return False
		  End If
		  tokens.Remove 0
		  
		  If tokens(0) <> "Function" Then
		    Return False
		  End If
		  tokens.Remove 0
		  
		  // can be no tokens (end sub|function followed by nothing)
		  If tokens.Ubound < 0 Then
		    Return True
		  End If
		  
		  // tokenizer breaks comment into ONE token and thats the only thing allowed
		  If tokens.Ubound > 0 Then
		    Return False
		  End If
		  If IsComment(tokens(0)) = False Then
		    Return False
		  End If
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsEndOfSubLine(line as string) As boolean
		  // END SUB (rem // or ') nothing else
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine(line.Trim, LanguageUtils.NoWhiteSpaceFlag)
		  
		  If tokens.Ubound < 1 Then 
		    Return False
		  End If
		  If tokens(0) <> "End" Then
		    Return False
		  End If
		  tokens.remove 0
		  
		  If tokens(0) <> "Sub" Then
		    Return False
		  End If
		  tokens.Remove 0
		  
		  // can be no tokens (end sub|function followed by nothing)
		  If tokens.Ubound < 0 Then
		    Return True
		  End If
		  
		  // tokenizer breaks comment into ONE token and thats the only thing allowed
		  If tokens.Ubound > 0 Then
		    Return False
		  End If
		  If IsComment(tokens(0)) = False Then
		    Return False
		  End If
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsFunctionLine(line as String) As Boolean
		  Dim attrs As String
		  Dim scope As String
		  Dim subFunc As String
		  Dim codeItemName As String
		  Dim params As String
		  Dim returntype As String
		  
		  If LanguageUtils.CrackMethodDeclaration(line, attrs, scope, subFunc, codeItemName, params, returntype) Then
		    
		    Return subFunc = "Function"
		    
		  End 
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsHexNumber(value as string) As boolean
		  dim mb as memoryblock = value
		  
		  // any chars outside the range of 0-9-A-F-a-f ?
		  For i As Integer = 0 To mb.Size-1
		    
		    Dim ascChar As UInt8 = mb.UInt8Value(i)
		    
		    If ascChar >= 48 And ascChar <= 57 Then // Asc("0") And ascChar<=Asc("9") Then
		    Elseif ascChar >= 65 And ascChar <= 70 Then // ascChar >= Asc("a") And ascChar<=Asc("f") Then
		    Elseif ascChar >= 97 And ascChar <= 102 Then // ascChar >= Asc("A") And ascChar<=Asc("F") Then
		    Else
		      Return False
		    End If
		  Next
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsIdentifier(token As String) As Boolean
		  // Return whether the given identifier might be an identifier
		  // rather than an operator or keyword.
		  
		  // NOTE: "me" and "self" return false here, because they're keywords,
		  // even though they're also identifiers -- we may want to reconsider
		  // this at some point.
		  
		  Dim c As String
		  
		  // first letter cannot be a number
		  // or other punctuation
		  c = Left( token, 1 )
		  If InStr("0123456789~`!@#$%^&*()-+={}[]""':;<,>.?/|\", c) > 0 Then
		    Return False
		  End If
		  
		  // token must not be a keyword
		  If KeywordDict.HasKey( token ) Then 
		    Return False
		  End If
		  
		  // otherwise, it's probably an identifier
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsInStringLiteral(source As String, startPosB As Integer, lengthB As Integer) As Boolean
		  // Return whether the given section of 'source' is within a string literal.
		  // (Note: the quotation marks themselves are not counted as being within the literal.)
		  
		  // Note that currently this does NOT take into account the case where the
		  // range is in a "string literal" within a comment.  In other words, those
		  // are reported as being within a string literal too.  That may be considered
		  // sensible, since usually this will happen in things like commented-out
		  // code.  The caller can always call CommentStartPos to distinguish that case.
		  
		  Dim posB As Integer
		  
		  posB = InStr( 1, source, """" )
		  If posB < 1 Then 
		    Return False  // no quotation marks
		  End If
		  If posB >= startPosB Then 
		    Return False // quotation mark occurs after the start position
		  End If
		  
		  Dim inQuote As Boolean = true
		  do
		    posB = InStr( posB + 1, source, """" )
		    If posB < 1 Then 
		      Exit
		    End If
		    if posB > startPosB then
		      If posB >= startPosB + lengthB Then 
		        Exit
		      End If
		      If Mid( source, posB + 1, 1 ) <> """" Then
		        // the string literal terminated within our range, so the range
		        // is not itself within a string literal
		        return false
		      end if
		    end if
		    inQuote = not inQuote
		  loop
		  
		  return inQuote
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsInteger(token as String) As Boolean
		  // Check to see whether the token is numeric first
		  If Not IsNumeric( token ) Then 
		    Return False
		  End If
		  
		  // Now check to see if it's a real number
		  If IsRealNumber( token ) Then 
		    Return False
		  End If
		  
		  // Finally, we know it's numeric, but not a real number,
		  // so we're done
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsKeyword(word as string) As boolean
		  Return KeywordDict.HasKey(word)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsRealNumber(token as String) As Boolean
		  // First, check to see if the token is numeric
		  If Not IsNumeric( token ) Then 
		    Return False
		  End If
		  
		  // Now check to see whether the token has a "." or "e" in it
		  return InStr( token, "." ) > 0 or InStr( token, "e" ) > 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsScopeToken(token as string) As Boolean
		  If token = kScopeGlobal Or _
		    token = kScopePrivate Or _
		    token = kScopeProtected Or _
		    token = kScopePublic Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsStringLiteral(token as string) As boolean
		  // if left = " and right = "
		  // and tehre are only doubled up ones in between
		  
		  If token.BeginsWith("""") = False Or token.EndsWith("""") = False Then
		    Return False
		  End If
		  
		  Dim tmp As String = token.Middle(1,token.length-2)
		  
		  tmp = tmp.ReplaceAll("""""","")
		  
		  If tmp.Instr("""") >= 1 Then
		    Return False
		  End If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsSubLine(line as String) As Boolean
		  Dim attrs As String
		  Dim scope As String
		  Dim subFunc As String
		  Dim codeItemName As String
		  Dim params As String
		  Dim returntype As String
		  
		  If LanguageUtils.CrackMethodDeclaration(line, attrs, scope, subFunc, codeItemName, params, returntype) Then
		    
		    Return subFunc = "SUB"
		    
		  End 
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsSubOrFunctionStart(thisLine As String) As Boolean
		  // we are if the line is "Public Sub" and no extra chars
		  // we are not if the line is "Public Substitute"
		  // etc :)
		  
		  // Static lineStarts(-1) As String
		  // If lineStarts.Ubound < 0 Then
		  // lineStarts.append "Public Sub"
		  // lineStarts.append "Sub"
		  // lineStarts.append "Public Function"
		  // lineStarts.append "Function"
		  // End If
		  // 
		  // Dim testString As String 
		  // 
		  // Dim trimmedLine As String = thisLine.Trim
		  // 
		  // For Each starter As String In lineStarts
		  // testString = trimmedLine.Left(Len(starter))
		  // If testString = starter  Then
		  // // line is only Public Sub ?
		  // If trimmedLine.Len = Len(starter) Then
		  // Return True
		  // End If
		  // 
		  // testString = trimmedLine.Left(Len(starter)+1)
		  // If testString.Trim = starter Then
		  // Return True
		  // End If
		  // End If
		  // Next
		  
		  return IsSubLine(thisLine) or IsFunctionLine(thisLine)
		  
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsVarDeclarationLine(line as String) As boolean
		  // if the line only has 3 chars tand starts with DIM then it is
		  
		  If line.Len < 3 Then
		    Return False
		  Elseif line.Len = 3 And line = "DIM" Then
		    Return True
		  Else
		    Return line.Left(4) = "DIM "
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsWhitespace(c As String) As Boolean
		  // Return whether the first character of c is a whitespace character.
		  
		  return Asc(c) <= 32
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function KeywordDict() As Dictionary
		  // Return a dictionary containing all the RB keywords as keys
		  // (and nothing useful as values).
		  
		  If mKeywordDict <> Nil Then 
		    Return mKeywordDict
		  End If
		  
		  Dim keywords() As String
		  keywords = Split("addressof alias And Array As Assigns Boolean Break" +_
		  " ByRef ByVal Call Case Catch Class Color Const Declare Delegate" +_
		  " Dim Do Double DownTo Each Else #Else Elseif #ElseIf End #EndIf" +_
		  " Event Exception Exit Extends False Finally For Function GoTo" +_
		  " Handles If #If Implements In Inherits Integer Interface Is" +_
		  " IsA Lib Loop Me Mod Module Namespace New Next Nil Not Object" +_
		  " Of Optional Or ParamArray #Pragma Private Protected Public" +_
		  " Raise Redim Rem Return Return Select Self Shared Single Soft" +_
		  " Static Step String Sub Super Then To True Try Until Wend While", " ")
		  
		  mKeywordDict = New Dictionary
		  Dim keyword As String
		  for each keyword in keywords
		    mKeywordDict.Value( keyword ) = true
		  next
		  
		  return mKeywordDict
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function LineContinuationPoint(source As String) As Integer
		  // Return the position of the line-continuation token ("_").
		  // If this line doesn't end in continuation, then return 0.
		  
		  Dim posB As Integer
		  Dim maxPos As Integer = source.Len
		  Dim c As String
		  Dim found As Boolean
		  Dim commentPos As Integer = -1
		  do
		    // find the next occurrence of "_"; if none, then we're done
		    posB = InStr( posB+1, source, "_" )
		    If posB < 1 Then 
		      Return 0
		    End If
		    If commentPos > 0 And posB > commentPos Then 
		      Return 0
		    End If
		    
		    // this is a line continuation character if it's not part of some other
		    // token...
		    found = true
		    if posB > 1 then
		      c = Mid( source, posB - 1, 1 )
		      If InStr( """+-*/\^='.(), ", c ) < 1 Then
		        // the char before the _ is not a delimiter, so _ is part of that token
		        found = false
		      end if
		    end if
		    if found and posB < maxPos then
		      c = Mid( source, posB + 1, 1 )
		      if InStr( """+-*/\^='.(), ", c ) < 1 then
		        // the char after the _ is not a delimiter, so _ is part of that token
		        found = false
		      end if
		    end if
		    
		    // ...and if it's not in a string literal or comment...
		    if commentPos < 0 then
		      commentPos = CommentStartPos( source )
		      If commentPos > 0 And posB > commentPos Then 
		        found = False
		      End If
		    end if
		    
		    if found and IsInStringLiteral( source, posB, 1 ) then
		      found = false
		    end if
		    
		  loop until found
		  
		  return posB
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function LineIsBlockEnd(line as string) As boolean
		  
		  Dim tokens() As String = TokenizeLine(line, LanguageUtils.NoWhiteSpaceFlag)
		  
		  If tokens.ubound < 0 Then
		    Return False
		  End If
		  
		  Select Case True
		    
		  Case tokens.Count >= 1 And tokens(0) = "#endif"
		  Case tokens.Count >= 1 And tokens(0) = "next"
		  Case tokens.Count >= 1 And tokens(0) = "loop"
		  Case tokens.Count >= 1 And tokens(0) = "wend"
		    
		  Case tokens.Count >= 1 And tokens(0) = "end"
		    
		  Case tokens.Count >= 2 And tokens(0) + " " + tokens(1) = "end if"
		  Case tokens.Count >= 2 And tokens(0) + " " + tokens(1) = "end select"
		  Case tokens.Count >= 2 And tokens(0) + " " + tokens(1) = "end try"
		  Case tokens.Count >= 2 And tokens(0) + " " + tokens(1) = "end sub"
		  Case tokens.Count >= 2 And tokens(0) + " " + tokens(1) = "end function"
		    
		  Else
		    Return False
		  End Select
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function LineIsBlockStart(line as string) As boolean
		  Return BlockCloser(line) <> ""
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function MakeSignatureFromElements(name as string, params() as LanguageUtils.LocalVariable, returnType as String) As string
		  
		  // Return a string that is the signature
		  //   name
		  //   param TYPES (not param names)
		  //   return type
		  
		  Dim parts() As String 
		  
		  parts.Append name
		  parts.Append "|"
		  
		  If (params Is Nil) = False And params.ubound >= 0 Then
		    
		    For i As Integer = 0 To params.Ubound
		      Dim param As LanguageUtils.LocalVariable = params(i)
		      
		      If i > 0 Then
		        parts.append ","
		      End If
		      
		      parts.Append param.type
		      
		    Next
		    
		  End If
		  
		  parts.Append "|"
		  
		  parts.Append returnType
		  
		  Return Join(parts,"")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function MakeSignatureFromElements(name as string, params as string, returnType as String) As string
		  
		  // Return a string that is the signature
		  //   name
		  //   param TYPES (not param names)
		  //   return type
		  
		  Dim paramList() As languageUtils.localVariable
		  
		  Dim safeParams As String = LTrim(Params)
		  Dim compareTo As String = "DIM "
		  Dim nChars As Integer = Len(compareTo)
		  Dim leftNChars As String = safeparams.Left(nChars)
		  
		  If (leftNChars = compareTo) = False Then
		    paramList = CrackParams( "DIM " + params )
		  Elseif (leftNChars = compareTo) = True Then
		    paramList = CrackParams( params )
		  End If
		  
		  Return MakeSignatureFromElements(name, paramList, returnType)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NeedsMatchAbove(sourceLine As String) As Boolean
		  Dim firstWord As String
		  firstWord = FirstToken( sourceLine )
		  return firstWord = "end" or firstWord = "next" or firstWord = "wend" _
		  or firstWord = "loop" or firstWord = "else" or firstWord = "elseif" _
		  or firstWord = "case" or firstWord = "catch" or firstWord = "finally" _
		  or firstWord ="#endif" or firstWord = "#elseif" or firstWord = "#else"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NeedsMatchBelow(sourceLine As String) As Boolean
		  Dim firstWord As String
		  firstWord = FirstToken( sourceLine )
		  if firstWord = "else" or firstWord = "elseif" _
		    or firstWord = "do" or firstWord = "while" or firstWord = "for" _
		    or firstWord = "select" or firstWord = "case" _
		    or firstWord = "try" or firstWord = "catch" or firstWord = "finally" _
		    or firstWord = "#else" or firstWord = "#elseif"  or firstWord = "#if" Then 
		    Return True
		  End If
		  
		  Dim posB As Integer
		  Dim maxpos As Integer
		  
		  If firstWord = "if" Then
		    // "if" is a bit of a special case, since it has both a single-line
		    // and a block form.  The difference is whether there is anything
		    // after the "then".
		    posB = firstWord.Len
		    maxpos = sourceLine.Len
		    While posB <= maxpos
		      Dim tk As token = NextToken( sourceLine, posB )
		      posB = posB + tk.read
		      If tk.StringValue = "then" Then
		        // ok, if next token is not a comment or end of line, then
		        // we have a single-line if and need no match below
		        Do
		          tk = NextToken( sourceLine, posB )
		          posB = posB + tk.read
		        loop until tk.read = 0 
		        If tk.stringvalue = "" Or Left(tk.stringvalue,1) = "'" Or Left(tk.stringvalue,2) = "//" Or Left(tk.stringvalue,4) = "Rem " Then 
		          Return True
		        End If
		        Return False
		      end if
		      If tk.read = 0 Then 
		        Exit
		      End If
		    wend
		    // Hmm, we didn't even see a "then"?!? -- for now, assume a block 'if':
		    return true
		  end if
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NextToken(source As String, startPos As Integer) As token
		  // Get the next token in the given source code, starting at
		  // the given char offset (as in Mid, first byte = 1).
		  
		  Dim i, j, maxi As Integer
		  i = startPos
		  maxi = Len( source )
		  
		  Dim c As String
		  c = Mid( source, i, 1 )
		  
		  If IsWhitespace(c) Then
		    // run of whitespace
		    For j = i + 1 To maxi
		      If Not IsWhitespace( Mid( source, j, 1 ) ) Then 
		        Exit
		      End If
		    next
		    Return New token( token.types.whitespace, Mid( source, i, j - i ) )
		    
		  ElseIf c = "'" Then
		    // comment from here to end of line
		    Return New token( token.types.comment, Mid( source, i ) )
		    
		  ElseIf c = "/" And i < maxi And Mid( source, i+1, 1 ) = "/" Then
		    // comment from here to end of line
		    Return New token( token.types.comment, Mid( source, i ) )
		    
		  ElseIf c = "R" And Mid( source, i, 3 ) = "Rem" _
		    And IsWhitespace( Mid( source, i+3, 1 ) ) Then
		    // comment from here to end of line
		    Return New token( token.types.comment, Mid( source, i ) )
		    
		  ElseIf c = """" Then
		    // string literal
		    j = i
		    While j > 0 And j < maxi
		      j = InStr( j+1, source, """" )
		      If j = 0 Then  // no more quotes found -- terminate at end of string
		        j = maxi
		        Exit
		      End If
		      If Mid( source, j+1, 1 ) = """" Then
		        j = j + 1   // doubled embedded quote -- skip it and continue
		      Else
		        Exit        // found the close quote; exit the loop
		      End If
		    Wend
		    Return New token( token.types.String, Mid( source, i, j - i + 1 ) )
		    
		  ElseIf c = "\" And i < maxi And Mid( source, i+1, 1 ) = """" Then
		    // string literal escape encoded
		    // these CAN be multi lined ffs
		    Dim buffer() As String
		    j = i + 2
		    Dim read As Integer = 2
		    
		    While j > 0 And j <= maxi
		      Dim ch As String = Mid( source, j, 1 )
		      
		      read = read + 1
		      
		      If ch = "\" Then
		        
		        If j+1 > maxi Then
		          Exit While
		        Else
		          Select Case Mid(source, j+1, 1)
		          Case "n"
		            buffer.append ChrB(&h0A)
		            read = read + 1
		            
		          Case "t"
		            buffer.append ChrB(&h09)
		            read = read + 1
		            
		          Case "v"
		            buffer.append ChrB(&h0b)
		            read = read + 1
		            
		          Case "b"
		            buffer.append ChrB(&h08)
		            read = read + 1
		            
		          Case "f"
		            buffer.append ChrB(&h0C)
		            read = read + 1
		            
		          Case "a"
		            buffer.append ChrB(&h07)
		            read = read + 1
		            
		          Case "\"
		            buffer.append "\"
		            read = read + 1
		            
		          Case "?"
		            buffer.append "?"
		            read = read + 1
		            
		          Case "'"
		            buffer.append "'"
		            read = read + 1
		            
		          Case """"
		            buffer.append """"
		            read = read + 1
		            
		          Case "x" 
		            // two char Hex
		            buffer.append ChrB(Val("&h" + Mid(source, j + 2, 2)))
		            j = j + 1
		            read = read + 3
		            
		          Else
		            buffer.append " "
		            
		          End Select
		          j = j + 2
		        End If
		        
		      ElseIf ch = """" Then
		        Exit While
		      Else
		        buffer.append ch
		        j = j + 1
		        
		      End If
		      
		    Wend
		    
		    Return New token( token.types.String, """" + Join(buffer,"") + """", read )
		    
		  ElseIf IsDigit( c ) Or _
		    (c = "." And i < maxi And IsDigit( Mid( source, i+1, 1 ) )) Then
		    // a number
		    j = i + 1
		    Dim read As Integer
		    
		    While j <= maxi
		      c = Mid( source, j, 1 )
		      If c <> "." And Not IsDigit( c ) Then 
		        Exit
		      End If
		      j = j + 1
		      read = read  + 1
		      
		    Wend
		    Return New token( token.types.number, Mid( source, i, j - i ) )
		    
		  ElseIf InStr( "<>+-*/\^=.,():"+EndOfLine, c ) > 0 Then
		    // an operator or paren 
		    // currently all our operators are one character 
		    // uh NO ! <= >= <> ????
		    Dim nextC As String = Mid(source, i+1, 1) 
		    If c = "<" And nextC = ">" Then
		      Return New token( token.types.operator, c + nextC, 2 )
		    ElseIf c = "<" And nextC = "=" Then
		      Return New token( token.types.operator, c + nextC, 2 )
		    ElseIf c = ">" And nextC = "=" Then
		      Return New token( token.types.operator,c + nextC, 2 )
		    End If
		    
		    Return New token( token.types.operator, c )
		    
		  Else
		    // anything else -- grab to next delimiter
		    j = FindAnyInStr( i+1, source, "<>""+-*/\^='.(), :"+ EndOfLine + WhiteSpaceChars)
		    If j < 1 Then 
		      j = maxi+1
		    End If
		    Return New token( token.types.unknown, Mid( source, i, j - i ) )
		  End If
		  
		  Break // should never get here -- all cases above return something
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  #If DebugBuild
		    // Unit-test this module.
		    
		    UnitTestTokenize
		    UnitTestTokenizeSource
		    UnitTestFirstToken
		    
		    UnitTestBlockCloser
		    UnitTestCommentStartPos
		    UnitTestConvertComments
		    UnitTestEndsInComment
		    UnitTestEndsInLineCont
		    UnitTestEnumDeclCracker
		    UnitTestEventDeclCracker
		    UnitTestExpect
		    UnitTestFindAnyInStr
		    UnitTestFindOpeningParen
		    
		    UnitTestFindParams
		    
		    UnitTestFindVarDecs
		    // UnitTestFindVarHelper gets tested as part of FindVarDecs
		    UnitTestIsEndOfCodeBlock
		    UnitTestIsHexNumber()
		    UnitTestIsIdent
		    UnitTestIsInStringLiteral
		    UnitTestMakeSignature
		    
		    UnitTestMakeSignatureForEvent
		    
		    UnitTestMethodDeclCracker
		    UnitTestPropertyDeclCracker
		    
		    // UnitTestTokenHelper gets tested as part of tokenize
		    
		    UnitTestIsEndOfCodeBlock
		    
		    UnitTestFindParams
		    
		    UnitTestConvertComments()
		    
		    UnitTestExpect()
		    
		    LocalVariable.RunUnitTests
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ScopeFromFlags(flags as integer) As LanguageUtils.Scope
		  // may raise an UnsupportedOperationException if passed an invalid integer value for scope
		  
		  Select Case flags
		    
		  Case &h0 // LanguageUtils.kScopeGlobal
		    Return LanguageUtils.Scope.GlobalScope
		    
		  Case &h21 // LanguageUtils.kScopePrivate
		    Return LanguageUtils.Scope.PrivateScope
		    
		  Case &h1 // LanguageUtils.kScopeProtected
		    Return LanguageUtils.Scope.ProtectedScope
		    
		  Case &h0 // LanguageUtils.kScopePublic
		    Return LanguageUtils.Scope.PublicScope
		    
		  Else
		    assert False, CurrentMethodName + " got an invalid scope string"
		    
		    Return LanguageUtils.Scope.PublicScope
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ScopeFromFlags(flagsString as string) As LanguageUtils.Scope
		  // may raise an UnsupportedOperationException if passed an invalid integer value for scope
		  
		  Select Case flagsString
		    
		  Case  "&h0" // LanguageUtils.kScopeGlobal
		    Return LanguageUtils.Scope.GlobalScope
		    
		  Case "&h21" // LanguageUtils.kScopePrivate
		    Return LanguageUtils.Scope.PrivateScope
		    
		  Case "&h1" // LanguageUtils.kScopeProtected
		    Return LanguageUtils.Scope.ProtectedScope
		    
		  Case "&h0" // LanguageUtils.kScopePublic
		    Return LanguageUtils.Scope.PublicScope
		    
		  Else
		    assert False, CurrentMethodName + " got an invalid scope string"
		    
		    Return LanguageUtils.Scope.PublicScope
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ScopeFromString(scopestring as string) As LanguageUtils.Scope
		  // may raise an UnsupportedOperationException if passed an invalid integer value for scope
		  
		  Select Case scopestring
		    
		  Case LanguageUtils.kScopeGlobal
		    Return LanguageUtils.Scope.GlobalScope
		    
		  Case LanguageUtils.kScopePrivate
		    Return LanguageUtils.Scope.PrivateScope
		    
		  Case LanguageUtils.kScopeProtected
		    Return LanguageUtils.Scope.ProtectedScope
		    
		  Case LanguageUtils.kScopePublic
		    Return LanguageUtils.Scope.PublicScope
		    
		  Else
		    assert False, CurrentMethodName + " got an invalid scope string"
		    
		    Return LanguageUtils.Scope.PublicScope
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function StandardizeComment(comment as String) As string
		  
		  Dim start As Integer = LanguageUtils.CommentStartPos(comment)
		  If start < 1 Then
		    Return comment
		  End If
		  
		  Dim leftPart As String
		  dim leftPad as string
		  Dim rightpart As String
		  
		  If comment.Mid(start,1) = "'" Then
		    leftPart = comment.Left(start-1)
		    rightpart = comment.Mid(start+1)
		    
		  Elseif comment.Mid(start,2) = "//" Then
		    
		    leftPart = comment.Left(start-1)
		    rightpart = comment.Mid(start+2)
		    
		  Elseif comment.Mid(start,3) = "REM" Then
		    leftPart = comment.Left(start-1)
		    rightpart = comment.Mid(start+3)
		    
		    If leftPart.Trim <> "" and leftPart.Right(1) <> " " Then
		      leftPad = " "
		    End If
		    
		  Else
		    
		    Return comment
		    
		  End If
		  
		  Return leftPart + leftpad + Trim(StandardCommentFormStr  + rightpart.Trim)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function StringFromScope(scope as LanguageUtils.Scope) As string
		  // may raise an UnsupportedOperationException if passed an invalid integer value for scope
		  
		  Select Case scope
		    
		  Case LanguageUtils.Scope.GlobalScope
		    Return LanguageUtils.kScopeGlobal
		    
		  Case LanguageUtils.Scope.PrivateScope
		    Return LanguageUtils.kScopePrivate
		    
		  Case LanguageUtils.Scope.ProtectedScope
		    Return LanguageUtils.kScopeProtected
		    
		  Case LanguageUtils.Scope.PublicScope
		    Return LanguageUtils.kScopePublic
		    
		  Else
		    assert False, CurrentMethodName + " got an invalid scope value"
		    
		    Return LanguageUtils.kScopePublic
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function TokenizeLine(sourceLine As String, includeWhitespace As Integer = AllWhiteSpaceFlag) As String()
		  // Break the given line up into tokens.
		  // If includeWhitespace = true, then include whitespace as well,
		  // so the original line can be completely reconstructed.
		  // Otherwise, skip over any whitespace tokens.
		  
		  Dim out() As String
		  Dim pos As Integer = 1
		  Dim maxpos As Integer = sourceLine.Len
		  Dim tk As token
		  
		  While pos <= maxpos
		    
		    tk = NextToken( sourceLine, pos )
		    
		    If tk.read = 0 Then 
		      Return out
		    End If
		    
		    If includeWhitespace = AllWhiteSpaceFlag Then // keep everything - white space or not
		      
		      out.Append tk.stringValue
		      
		    ElseIf includeWhitespace = EndOfLineFlag Then
		      
		      If Contains(tk.stringValue, EndOfLine) Then // keep the end of lines
		        out.Append EndOfLine
		      ElseIf IsWhitespace(tk.stringValue) = False Then // keep no other white space
		        out.Append tk.stringValue
		      End If
		      
		    ElseIf includeWhitespace = NoWhiteSpaceFlag Then
		      
		      If IsWhitespace(tk.stringValue) = False Then // no white space
		        out.Append tk.stringValue
		      End If
		      
		    End If
		    
		    //incorrect in the case there ws a \" encoded stringg as that may consume more bytes than it returns 
		    // ie/ if it includes \xHEX then there imght be one byte returned but 4 bytes eaten !
		    pos = pos + tk.read
		    
		  Wend
		  
		  return out
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function TokenizeSource(source As String, includeWhitespace As Integer = AllWhiteSpaceFlag) As Token()
		  // tokenize source is for tokenizing MULTIPLE LINES
		  
		  Dim out() As token
		  Dim pos As Integer = 1
		  Dim maxpos As Integer = source.Len
		  Dim tk As token
		  
		  While pos <= maxpos
		    
		    tk = NextToken( source, pos )
		    
		    If tk.read = 0 Then 
		      Return out
		    End If
		    
		    If includeWhitespace = AllWhiteSpaceFlag Then // keep everything - white space or not
		      
		      out.Append tk
		      
		    ElseIf includeWhitespace = EndOfLineFlag Then
		      
		      If Contains(tk.stringValue, EndOfLine) Then // keep the end of lines
		        out.Append New token(token.types.EndOfLine, EndOfLine)
		      ElseIf IsWhitespace(tk.stringValue) = False Then // keep no other white space
		        out.Append tk
		      End If
		      
		    ElseIf includeWhitespace = NoWhiteSpaceFlag Then
		      
		      If IsWhitespace(tk.stringValue) = False Then // no white space
		        out.Append tk
		      End If
		      
		    End If
		    
		    //incorrect in the case there ws a \" encoded stringg as that may consume more bytes than it returns 
		    // ie/ if it includes \xHEX then there imght be one byte returned but 4 bytes eaten !
		    pos = pos + tk.read
		    
		  Wend
		  
		  Return out
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestBlockCloser()
		  
		  ErrorIf BlockCloser("if foo=bar then") <> "end if"
		  ErrorIf BlockCloser("do until foo") <> "loop"
		  ErrorIf BlockCloser("while something") <> "wend"
		  ErrorIf BlockCloser("move zig") <> ""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestCommentStartPos()
		  ErrorIf CommentStartPos("abc // def") <> 5
		  ErrorIf CommentStartPos("abc 'def") <> 5
		  ErrorIf CommentStartPos("abc Rem def") <> 5
		  ErrorIf CommentStartPos("abc def") <> 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestConvertComments()
		  // see that converting various comment fors turns the comment into "// "
		  
		  ErrorIf StandardizeComment("// def") <> "// def"
		  ErrorIf StandardizeComment("//def") <> "// def"
		  ErrorIf StandardizeComment("abc//") <> "abc//"
		  ErrorIf StandardizeComment("abc // def") <> "abc // def"
		  ErrorIf StandardizeComment("abc //def") <> "abc // def"
		  ErrorIf StandardizeComment("abc// def") <> "abc// def"
		  
		  ErrorIf StandardizeComment("' def") <> "// def"
		  ErrorIf StandardizeComment("'def") <> "// def"
		  ErrorIf StandardizeComment("abc'") <> "abc//"
		  ErrorIf StandardizeComment("abc ' def") <> "abc // def"
		  ErrorIf StandardizeComment("abc 'def") <> "abc // def"
		  ErrorIf StandardizeComment("abc' def") <> "abc// def"
		  
		  // note REM is a bit screwy 
		  // becuase REM must have spaces around it when it occurs in the middle of a line
		  // but not at the beginning of a line
		  ErrorIf StandardizeComment("REM def") <> "// def"
		  ErrorIf StandardizeComment("REMdef") <> "REMdef"
		  ErrorIf StandardizeComment("abcREM") <> "abcREM"
		  ErrorIf StandardizeComment("abc REM def") <> "abc // def"
		  ErrorIf StandardizeComment("abc REMdef") <> "abc REMdef"
		  ErrorIf StandardizeComment("abcREM def") <> "abcREM def"
		  
		  ErrorIf StandardizeComment("abc def") <> "abc def"
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestEndsInComment()
		  
		  ErrorIf EndsInComment("if x=3 then foo")
		  ErrorIf EndsInComment("if x=""foo//bar"" then foo")
		  ErrorIf not EndsInComment("x=""foo"" // bar")
		  ErrorIf not EndsInComment("x=""foo//baz"" // bar")
		  ErrorIf not EndsInComment("x=123 // bar ""baz bamf""")
		  ErrorIf not EndsInComment("//foo ""bar"" baz")
		  
		  ErrorIf EndsInComment("if x=3 then foo")
		  ErrorIf EndsInComment("if x=""foo'bar"" then foo")
		  ErrorIf not EndsInComment("x=""foo"" ' bar")
		  ErrorIf not EndsInComment("x=""foo'baz"" ' bar")
		  ErrorIf not EndsInComment("x=123 ' bar ""baz bamf""")
		  ErrorIf not EndsInComment("'foo ""bar"" baz")
		  
		  ErrorIf EndsInComment("if x=3 then foo")
		  ErrorIf EndsInComment("if x=""foo REM bar"" then foo")
		  ErrorIf not EndsInComment("x=""foo"" REM bar")
		  ErrorIf not EndsInComment("x=""foo REM baz"" REM bar")
		  ErrorIf not EndsInComment("x=123 REM bar ""baz bamf""")
		  ErrorIf not EndsInComment("REM foo ""bar"" baz")
		  
		  // Test some minor related functions too...
		  ErrorIf Not IsComment("Rem")
		  ErrorIf Not IsComment("Rem arkable")
		  ErrorIf Not IsComment("// spam")
		  ErrorIf Not IsComment("'Joe wuz here")
		  ErrorIf IsComment("Remarkable")
		  ErrorIf IsComment("/")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestEndsInLineCont()
		  ErrorIf EndsInLineContinuation( "if x=3 then foo" )
		  ErrorIf EndsInLineContinuation( "x_2 = y_3" )
		  ErrorIf EndsInLineContinuation( "foo = bar // dang _" )
		  ErrorIf EndsInLineContinuation( "foo = ""quote _ """ )
		  ErrorIf EndsInLineContinuation( "foo = bar + ""_ // dang""" )
		  
		  ErrorIf not EndsInLineContinuation( "if x=3 _" )
		  ErrorIf not EndsInLineContinuation( "x_2 = y_3 _" )
		  ErrorIf not EndsInLineContinuation( "foo = bar _ // dang" )
		  ErrorIf not EndsInLineContinuation( "foo = _ Rem bar" )
		  ErrorIf not EndsInLineContinuation( "foo = ""quote _ "" _" )
		  ErrorIf not EndsInLineContinuation( "_ // pointless, no?" )
		  ErrorIf not EndsInLineContinuation( "_" )
		  
		  
		  // Note that the following is illegal anyway:
		  //   EndsInLineContinuation( "foo = _ * bar" )
		  // ...so we really don't care what answer we get.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestEnumDeclCracker()
		  UnitTest_ValidEnumDeclarations
		  
		  UnitTest_InvalidEnumDeclarations
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestEventDeclCracker()
		  UnitTest_ValidEventDeclarations
		  
		  UnitTest_InvalidEventDeclarations
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestExpect()
		  #If DebugBuild
		    If True Then
		      Dim tokens() As String
		      Dim expectedTokens() As String
		      
		      tokens.append "foo"
		      tokens.append "bar"
		      expectedTokens.Append "foo"
		      
		      Dim matched As String
		      Dim result As Boolean = Expect(expectedTokens, tokens, matched)
		      
		      DetailedErrorIf result <> True, " expect failed to find expected token"
		      DetailedErrorIf matched <> "foo", " expected 'foo' but got '" + matched + "'"
		      DetailedErrorIf tokens.count <> 1, " token not taken out of stream"
		      DetailedErrorIf tokens(0) <> "bar", " token not eaten"
		      
		    End If
		    
		    
		    If True Then
		      Dim tokens() As String
		      Dim expectedTokens() As String
		      
		      tokens.append "bar"
		      tokens.append "foo"
		      tokens.append "baz"
		      expectedTokens.Append "bar"
		      expectedTokens.Append "foo"
		      
		      Dim matched As String
		      Dim result As Boolean = Expect(expectedTokens, tokens, matched)
		      
		      DetailedErrorIf result <> True, " expect failed to find expected token"
		      DetailedErrorIf matched <> "bar", " expected 'foo' but got '" + matched + "'"
		      DetailedErrorIf tokens.count <> 2, " token not taken out of stream"
		      DetailedErrorIf tokens(0) <> "foo", " token not eaten"
		      DetailedErrorIf tokens(1) <> "baz", " token not eaten"
		      
		    End If
		    
		    
		    If True Then
		      Dim tokens() As String
		      Dim expectedTokens() As String
		      
		      tokens.append "bar"
		      tokens.append "foo"
		      tokens.append "baz"
		      expectedTokens.Append "1"
		      expectedTokens.Append "1"
		      
		      Dim matched As String
		      Dim result As Boolean = Expect(expectedTokens, tokens, matched)
		      
		      DetailedErrorIf result <> False, " expect found token when it should nto have"
		      DetailedErrorIf matched <> "", " expected '' but got '" + matched + "'"
		      DetailedErrorIf tokens.count <> 3, " token taken out of stream when it should not have been"
		      DetailedErrorIf tokens(0) <> "bar", " token eaten"
		      DetailedErrorIf tokens(1) <> "foo", " token eaten"
		      DetailedErrorIf tokens(2) <> "baz", " token eaten"
		      
		    End If
		    
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestFindAnyInStr()
		  
		  ErrorIf FindAnyInStr(1, "abcdef", "zdq") <> 4
		  ErrorIf FindAnyInStr(4, "abcdefedcba", "zdq") <> 4
		  ErrorIf FindAnyInStr(5, "abcdefedcba", "zdq") <> 8
		  ErrorIf FindAnyInStr(9, "abcdefedcba", "zdq") <> 0
		  ErrorIf FindAnyInStr(1, "abcdefedcba", "zyq") <> 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestFindOpeningParen()
		  
		  ErrorIf FindOpeningParen("12(456)8", 7) <> 3
		  ErrorIf FindOpeningParen("12(4())8", 7) <> 3
		  ErrorIf FindOpeningParen("12(""("")8", 7) <> 3
		  ErrorIf FindOpeningParen("12("")"")8", 7) <> 3
		  ErrorIf FindOpeningParen("1""(4("")8", 7) <> 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestFindParams()
		  If True Then
		    Dim vars() As LanguageUtils.LocalVariable
		    vars = CrackParams("a as integer")
		    ErrorIf vars.Ubound <> 0
		    ErrorIf vars(0).type <> "integer"
		  End If
		  
		  If True Then
		    Dim vars() As LanguageUtils.LocalVariable
		    vars = CrackParams("a as integer, s() as string")
		    ErrorIf vars.Ubound <> 1
		    ErrorIf vars(0).type <> "integer"
		    ErrorIf vars(1).type <> "string()"
		  End If
		  
		  If True Then
		    Dim vars() As LanguageUtils.LocalVariable
		    vars = CrackParams("a as integer, b() as string, d(,) as double)")
		    ErrorIf vars.Ubound <> 2
		    ErrorIf vars(0).type <> "integer"
		    ErrorIf vars(1).type <> "string()"
		    ErrorIf vars(2).type <> "double()"
		    
		  End If
		  
		  If True Then
		    Dim vars() As LanguageUtils.LocalVariable
		    vars = CrackParams("other As UIObject, x As Integer = -1, y As Integer = -1, width As Integer = -1, height As Integer = -1)")
		    ErrorIf vars.Ubound <> 4
		    
		    ErrorIf vars(0).type <> "UIObject"
		    ErrorIf vars(1).type <> "Integer"
		    ErrorIf vars(2).type <> "Integer"
		    ErrorIf vars(3).type <> "Integer"
		    ErrorIf vars(4).type <> "Integer"
		    
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestFindVarDecs()
		  UnitTestFindVarHelper "Dim i,j As Integer", "i:Integer,j:Integer"
		  UnitTestFindVarHelper "Dim i As Integer, foo As String", "i:Integer,foo:String"
		  UnitTestFindVarHelper "Dim a(5),b(-1),c() As Color", "a:Color():5,b:Color():-1,c:Color():"
		  
		  UnitTestFindVarHelper "Private Sub Foo(bar as Integer, baz as String)", "bar:Integer,baz:String"
		  UnitTestFindVarHelper "Function Foo(ByRef foo as Date, Assigns bar as Integer) as Boolean", "foo:Date,bar:Integer"
		  UnitTestFindVarHelper "Attributes( asdfasdf ) Function Foo(ByRef foo as Date, Assigns bar as Integer) as string", "foo:Date,bar:Integer"
		  
		  UnitTestFindVarHelper "Private Sub Foo(bar() as Integer, baz(100) as String)", "bar:Integer():,baz:String():100"
		  UnitTestFindVarHelper "Private Sub Foo(bar() as Integer, baz() as String)", "bar:Integer():,baz:String():"
		  
		  UnitTestFindVarHelper "Dim d As New Date", "d:Date"
		  UnitTestFindVarHelper "Dim a(5),b(-1,-1),c() As Color", "a:Color():5,b:Color():-1,-1,c:Color():"
		  UnitTestFindVarHelper "Dim a As Foo.Bar.Baz", "a:Foo.Bar.Baz"
		  UnitTestFindVarHelper "Dim a As Foo.Bar.Baz, b as Date", "a:Foo.Bar.Baz,b:Date"
		  
		  UnitTestFindVarHelper "const a As Foo.Bar.Baz", "a:Foo.Bar.Baz"
		  UnitTestFindVarHelper "const a = 123", "a:integer"
		  UnitTestFindVarHelper "const a = 1.23", "a:double"
		  UnitTestFindVarHelper "const a = ""123""", "a:string"
		  UnitTestFindVarHelper "const a = &c090909", "a:color"
		  UnitTestFindVarHelper "const a = &h090909", "a:integer"
		  UnitTestFindVarHelper "const a = &b010101", "a:integer"
		  UnitTestFindVarHelper "const a = &O070605", "a:integer"
		  
		  UnitTestFindVarHelper "Static d As New Date", "d:Date"
		  UnitTestFindVarHelper "Var d As New Date", "d:Date"
		  
		  UnitTestFindVarHelper "i = i + 1", ""
		  
		  UnitTestFindVarHelper "Enum AdressTypes as Uint8", ""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestFindVarHelper(sourceLine As String, expected As String)
		  // Helper method for UnitTestFindVarDecs.
		  // 'sourceLine' is a line of source code, 'expected' represents the local
		  // vars we expect to find, as a comma-separated list of name:type pairs.
		  
		  Dim vars(-1) As LocalVariable
		  FindVarDeclarations sourceLine, 100, vars
		  
		  Dim i As Integer
		  Dim got As String
		  
		  For i = 0 To UBound( vars )
		    
		    ErrorIf vars(i).firstLine <> 100
		    
		    If i > 0 Then 
		      got = got + ","
		    End If
		    
		    got = got + vars(i).name + ":" + vars(i).type
		    
		    If vars(i).isarray Then
		      got = got + ":" + vars(i).bounds
		    End If
		    
		  Next
		  
		  DetailedErrorIf got <> expected, "Vars found: " + got _
		  + EndOfLine + "Expected: " + expected
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestFirstToken()
		  ErrorIf FirstToken("if x then") <> "if"
		  ErrorIf FirstToken("end if") <> "end"
		  ErrorIf FirstToken("// it's a comment") <> "// it's a comment"
		  ErrorIf FirstToken("'it's a comment") <> "'it's a comment"
		  ErrorIf FirstToken("Rem it's a comment") <> "Rem it's a comment"
		  ErrorIf FirstToken("Remark no it's not") <> "Remark"
		  ErrorIf FirstToken("foo.bar(baz)") <> "foo"
		  ErrorIf FirstToken("foo(bar.baz)") <> "foo"
		  ErrorIf FirstToken("foo=bar.baz") <> "foo"
		  
		  // if our line is a continuation of a previous line,
		  // then the first token could be just about anything...
		  ErrorIf FirstToken("""foo bar"") = true") <> """foo bar"""
		  ErrorIf FirstToken("then dosomething") <> "then"
		  ErrorIf FirstToken("""foo """"bar"""" baz"") = true") <> """foo """"bar"""" baz"""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestIsEndOfCodeBlock()
		  // ones that should work
		  If True Then
		    Dim source As String = "End Sub"
		    assert IsEndOfSubLine(source), "should be an end sub but isnt"
		  End If
		  If True Then
		    Dim source As String = "End Sub" + EndOfLine
		    assert IsEndOfSubLine(source), "should be an end sub but isnt"
		  End If
		  If True Then
		    Dim source As String = "End Sub// this is a comment"
		    assert IsEndOfSubLine(source), "should be an end sub but isnt"
		  End If
		  If True Then
		    Dim source As String = "End Sub' this is a comment"
		    assert IsEndOfSubLine(source), "should be an end sub but isnt"
		  End If
		  If True Then
		    Dim source As String = "End Sub REM this is a comment"
		    assert IsEndOfSubLine(source), "should be an end sub but isnt"
		  End If
		  If True Then
		    Dim source As String = "End function"
		    assert IsEndOfFunctionLine(source), "should be an end function but isnt"
		  End If
		  If True Then
		    Dim source As String = "End function" + EndOfLine
		    assert IsEndOfFunctionLine(source), "should be an end function but isnt"
		  End If
		  If True Then
		    Dim source As String = "End function// this is a comment"
		    assert IsEndOfFunctionLine(source), "should be an end function but isnt"
		  End If
		  If True Then
		    Dim source As String = "End function' this is a comment"
		    assert IsEndOfFunctionLine(source), "should be an end function but isnt"
		  End If
		  If True Then
		    Dim source As String = "End function REM this is a comment"
		    assert IsEndOfFunctionLine(source), "should be an end function but isnt"
		  End If
		  
		  
		  
		  // ones that should NOT work
		  If True Then
		    Dim source As String = "EndSub"
		    assert IsEndOfSubLine(source)=False, "is a code block closer but should not be"
		  End If
		  If True Then
		    Dim source As String = "End Subfoo"
		    assert IsEndOfSubLine(source)=False, "is a code block closer but should not be"
		  End If
		  If True Then
		    Dim source As String = "End Sub foo"
		    assert IsEndOfSubLine(source)=False, "is a code block closer but should not be"
		  End If
		  
		  If True Then
		    Dim source As String = "EndFunction"
		    assert IsEndOfSubLine(source)=False, "is a code block closer but should not be"
		  End If
		  If True Then
		    Dim source As String = "End Functionfoo"
		    assert IsEndOfSubLine(source)=False, "is a code block closer but should not be"
		  End If
		  If True Then
		    Dim source As String = "End Function foo"
		    assert IsEndOfSubLine(source)=False, "is a code block closer but should not be"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestIsHexNumber()
		  
		  ErrorIf IsHexNumber("Af09") <> True
		  ErrorIf IsHexNumber("abcdef") <> True
		  ErrorIf IsHexNumber("1234F") <> True
		  ErrorIf IsHexNumber("FFFF") <> True
		  
		  ErrorIf IsHexNumber("098isfkjasd") <> False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestIsIdent()
		  
		  ErrorIf IsIdentifier("ÜberschriftDok") <> True
		  ErrorIf IsIdentifier("abcdef") <> True
		  ErrorIf IsIdentifier("¿abcdef") <> True
		  ErrorIf IsIdentifier("😃¿abcdef") <> True
		  
		  
		  ErrorIf IsIdentifier("098isfkjasd") <> False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestIsInStringLiteral()
		  
		  ErrorIf IsInStringLiteral("foo bar baz", 5, 3)
		  ErrorIf not IsInStringLiteral("foo ""bar"" baz", 6, 3)
		  ErrorIf IsInStringLiteral("foo ""bar"" baz", 5, 3)
		  ErrorIf IsInStringLiteral("foo ""bar"" baz", 6, 4)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestIsStringLiteral()
		  
		  ErrorIf IsStringLiteral("""ÜberschriftDok""") <> True
		  
		  ErrorIf IsStringLiteral("098isfkjasd") <> False
		  ErrorIf IsStringLiteral(" ""098isfkjasd""") <> False
		  ErrorIf IsStringLiteral("""098isfkjasd"" ") <> False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestMakeSignature()
		  #If DebugBuild
		    If True Then
		      
		      Dim name As String = "foo"
		      Dim params  As String = "i as integer, s as string"
		      Dim returntype As String = ""
		      
		      Dim result As String = MakeSignatureFromElements(name, params, returnType)
		      
		      DetailedErrorIf result = "", " failed to create signature"
		      DetailedErrorIf result <> "foo|integer,string|", "wrong signature"
		    End If
		    
		    If True Then
		      
		      Dim name As String = "foo"
		      Dim params  As String = "i as integer, s as string"
		      Dim returntype As String = "auto"
		      
		      Dim result As String = MakeSignatureFromElements(name, params, returnType)
		      
		      DetailedErrorIf result = "", " failed to create signature"
		      DetailedErrorIf result <> "foo|integer,string|auto", "wrong signature"
		    End If
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestMakeSignatureForEvent()
		  #If DebugBuild
		    
		    If True Then
		      Dim content As String
		      Dim attrs As String
		      Dim scope As String
		      Dim subFunc As String
		      Dim name As String
		      Dim params As String
		      Dim returnType As String
		      
		      content = "Event name()"
		      
		      ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, name, params, returnType) <> True
		      
		      Dim result As String = MakeSignatureFromElements(name, params, returnType)
		      
		      DetailedErrorIf result = "", " failed to create signature"
		      DetailedErrorIf result <> "name||", "wrong signature"
		      
		    End If
		    
		    
		    If True Then
		      
		      Dim content As String
		      Dim attrs As String
		      Dim scope As String
		      Dim subFunc As String
		      Dim name As String
		      Dim params As String
		      Dim returnType As String
		      
		      content = "Event foo(i as integer, s as string)"
		      
		      ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, name, params, returnType) <> True
		      
		      
		      Dim result As String = MakeSignatureFromElements(name, params, returnType)
		      
		      DetailedErrorIf result = "", " failed to create signature"
		      DetailedErrorIf result <> "foo|integer,string|", "wrong signature"
		    End If
		    
		    If True Then
		      
		      Dim content As String
		      Dim attrs As String
		      Dim scope As String
		      Dim subFunc As String
		      Dim name As String
		      Dim params As String
		      Dim returnType As String
		      
		      content = "Event foo(i as integer, s as string) as auto"
		      
		      ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, name, params, returnType) <> True
		      
		      Dim result As String = MakeSignatureFromElements(name, params, returnType)
		      
		      DetailedErrorIf result = "", " failed to create signature"
		      DetailedErrorIf result <> "foo|integer,string|auto", "wrong signature"
		    End If
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestMethodDeclCracker()
		  UnitTest_ValidMethodDeclarations
		  
		  UnitTest_InvalidMethodDeclarations
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestPropertyDeclCracker()
		  UnitTest_ValidPropertyDecls
		  
		  UnitTest_InvalidPropertyDecls
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestSourceTokenizerHelper(source As String, expected As String, includeWhitespace As Integer = AllWhiteSpaceFlag)
		  // This is a helper function for UnitTestTokenize.  The source is just
		  // plain RB source; "expected" is a string with vertical bars inserted
		  // between the tokens.
		  
		  Dim tokens() As Token
		  tokens = TokenizeSource( source, includeWhitespace )
		  
		  dim tokenstrs() as string
		  For Each t As token In tokens
		    tokenstrs.append t.stringvalue
		  Next t
		  
		  Dim got As String = Join(tokenStrs, "|")
		  
		  DetailedErrorIf got <> expected, "Expected: " + expected + EndOfLine + "Got: " + got
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestTokenHelper(source As String, expected As String, includeWhitespace As Integer = AllWhiteSpaceFlag)
		  // This is a helper function for UnitTestTokenize.  The source is just
		  // plain RB source; "expected" is a string with vertical bars inserted
		  // between the tokens.
		  
		  Dim tokens() As String
		  tokens = TokenizeLine( source, includeWhitespace )
		  
		  Dim got As String = Join(tokens, "|")
		  DetailedErrorIf got <> expected, "Expected: " + expected _
		  + EndOfLine + "Got: " + got
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestTokenize()
		  UnitTestTokenHelper "if foo=bar then", "if| |foo|=|bar| |then"
		  
		  UnitTestTokenHelper "x = ""foo bar"" // this is a test", "x| |=| |""foo bar""| |// this is a test"
		  
		  UnitTestTokenHelper "x=1-12.345 - 60", "x|=|1|-|12.345| |-| |60"
		  
		  UnitTestTokenHelper "Dim i, j,maxi as Integer", "Dim| |i|,| |j|,|maxi| |as| |Integer"
		  
		  UnitTestTokenHelper "Dim i, j,maxi as Integer", "Dim|i|,|j|,|maxi|as|Integer", LanguageUtils.NoWhiteSpaceFlag
		  
		  UnitTestTokenHelper "x=UBound(vars)", "x|=|UBound|(|vars|)"
		  
		  UnitTestTokenHelper "rb3d=Foo42", "rb3d|=|Foo42"
		  
		  UnitTestTokenHelper "rb3d=Foo42"+EndOfLine, "rb3d|=|Foo42|"+EndOfLine
		  
		  UnitTestTokenHelper "rb3d=Foo42"+EndOfLine, "rb3d|=|Foo42", LanguageUtils.NoWhiteSpaceFlag
		  
		  UnitTestTokenHelper "rb3d = Foo42 "+EndOfLine, "rb3d|=|Foo42|"+EndOfLine, LanguageUtils.EndOfLineFlag
		  
		  // test an oddity of the tokenizer
		  UnitTestTokenHelper "Picture         =   ""Angebot_Erstellen_Neu.frx"":1D93","Picture|         |=|   |""Angebot_Erstellen_Neu.frx""|:|1|D93"
		  
		  UnitTestTokenHelper "ADODB.EventReasonEnum, adStatus As ADODB.EventStatusEnum,","ADODB|.|EventReasonEnum|,| |adStatus| |As| |ADODB|.|EventStatusEnum|,"
		  
		  UnitTestTokenHelper " dim i as integer=1^2<>3>=4<=5^6<7>8" ," |dim| |i| |as| |integer|=|1|^|2|<>|3|>=|4|<=|5|^|6|<|7|>|8" 
		  
		  // runs of whitespaces coalesced properly ?
		  UnitTestTokenHelper "Property Width As Integer" + EndOfLine + "Get" + &u09 + EndOfLine + "#If forUseInIDEScript = False", "Property| |Width| |As| |Integer|" + EndOfLine + "|Get|" + &u09 + EndOfLine + "|#If| |forUseInIDEScript| |=| |False"
		  
		  UnitTestTokenHelper "if    foo   =   bar    then", "if|    |foo|   |=|   |bar|    |then"
		  
		  UnitTestTokenHelper "dim s as string = \""foo bar \n then", "dim| |s| |as| |string| |=| |""foo bar " + ChrB(10) + " then"""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTestTokenizeSource()
		  #If debugbuild
		    
		    If True Then
		      Dim source As String = "dim s as string = ""foo bar""" + EndOfLine + "dim i as integer" 
		      Dim expected As String = "dim| |s| |as| |string| |=| |""foo bar""|" + EndOfLine + "|dim| |i| |as| |integer" 
		      
		      UnitTestSourceTokenizerHelper source, expected
		    End If
		    
		    If True Then
		      Dim source As String = "dim s as string = \""foo" + EndOfLine + "bar""" + EndOfLine + "dim i as integer" 
		      Dim expected As String = "dim| |s| |as| |string| |=| |""foo" + EndOfLine + "bar""|" + EndOfLine + "|dim| |i| |as| |integer" 
		      
		      UnitTestSourceTokenizerHelper source, expected
		    End If
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTest_InvalidEnumDeclarations()
		  // if true blocks because they crate a new scope 
		  // so vars are not carried from oe block to another :P
		  
		  // =================================================================
		  // these should all work
		  //
		  // =================================================================
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim enumName As String
		    Dim type As String
		    
		    content = "Enum"
		    
		    ErrorIf LanguageUtils.CrackEnumDeclaration(content, attrs, scope, enumName, type) = True
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim enumName As String
		    Dim type As String
		    
		    content = "Enum Foo Uint8"
		    
		    ErrorIf LanguageUtils.CrackEnumDeclaration(content, attrs, scope, enumName, type) = True
		    
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim enumName As String
		    Dim type As String
		    
		    content = "Private Enum Foo as"
		    
		    ErrorIf LanguageUtils.CrackEnumDeclaration(content, attrs, scope, enumName, type) = True
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim enumName As String
		    Dim type As String
		    
		    content = "Attributes( bar  Enum Foo "
		    
		    ErrorIf LanguageUtils.CrackEnumDeclaration(content, attrs, scope, enumName, type) = True
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTest_InvalidEventDeclarations()
		  // if true blocks because they crate a new scope 
		  // so vars are not carried from oe block to another :P
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = ""
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  // =================================================================
		  // these should NOT work
		  //
		  // SUBS
		  // =================================================================
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name("
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name() as"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name as"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name() as string"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "sub name( as"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name( as string"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  
		  // FUNCTIONS
		  // =================================================================
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name("
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name( as"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name()"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name() as"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name() string"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name()"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name() as Assigns"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTest_InvalidMethodDeclarations()
		  // if true blocks because they crate a new scope 
		  // so vars are not carried from oe block to another :P
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = ""
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  // =================================================================
		  // these should NOT work
		  //
		  // SUBS
		  // =================================================================
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name("
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name() as"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name as"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name() as string"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "sub name( as"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name( as string"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  
		  // FUNCTIONS
		  // =================================================================
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name("
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name( as"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name()"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name() as"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name() string"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name()"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name() as Assigns"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> False
		    
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTest_InvalidPropertyDecls()
		  // if true blocks because they crate a new scope 
		  // so vars are not carried from oe block to another :P
		  
		  // =================================================================
		  // these should NOT work
		  // =================================================================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "name"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    // if we get a false all bets are off for the byref params
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "name as"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "name as String string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "Foo name as String"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "PROPERTY"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "PROPERTY name"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "PROPERTY name as"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  // =======================
		  // =======================
		  // =======================
		  // =======================
		  // =======================
		  If True Then
		    // with the OPTIONAL "accept PROPERTY keywords OFF (the default) this fails !
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    
		    src = "PROPERTY name as string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    
		    src = "PROPERTY name as string ="
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "PROPERTY name as string =""foo"""
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "PROPERTY name string ="
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "PROPERTY name ="
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  // =======================
		  
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    
		    src = "PUBLIC PROPERTY name as string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		  
		  // =======================
		  
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    
		    src = "SHARED PUBLIC PROPERTY name as string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault) <> False
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTest_ValidEnumDeclarations()
		  // if true blocks because they crate a new scope 
		  // so vars are not carried from oe block to another :P
		  
		  // =================================================================
		  // these should all work
		  //
		  // SUBS
		  // =================================================================
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim enumName As String
		    Dim type As String
		    
		    content = "Enum Foo "
		    
		    ErrorIf LanguageUtils.CrackEnumDeclaration(content, attrs, scope, enumName, type) <> True
		    ErrorIf attrs <> ""
		    ErrorIf scope <> kScopePublic
		    ErrorIf enumName <> "foo"
		    ErrorIf type <> "Integer"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim enumName As String
		    Dim type As String
		    
		    content = "Enum Foo as Uint8"
		    
		    ErrorIf LanguageUtils.CrackEnumDeclaration(content, attrs, scope, enumName, type) <> True
		    ErrorIf attrs <> ""
		    ErrorIf scope <> kScopePublic
		    ErrorIf enumName <> "foo"
		    ErrorIf type <> "Uint8"
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim enumName As String
		    Dim type As String
		    
		    content = "Private Enum Foo "
		    
		    ErrorIf LanguageUtils.CrackEnumDeclaration(content, attrs, scope, enumName, type) <> True
		    ErrorIf attrs <> ""
		    ErrorIf scope <> kScopePrivate
		    ErrorIf enumName <> "foo"
		    ErrorIf type <> "Integer"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim enumName As String
		    Dim type As String
		    
		    content = "Attributes( bar ) Protected Enum Foo "
		    
		    ErrorIf LanguageUtils.CrackEnumDeclaration(content, attrs, scope, enumName, type) <> True
		    ErrorIf attrs <> "bar"
		    ErrorIf scope <> kScopeProtected
		    ErrorIf enumName <> "foo"
		    ErrorIf type <> "Integer"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTest_ValidEventDeclarations()
		  // if true blocks because they crate a new scope 
		  // so vars are not carried from oe block to another :P
		  
		  // =================================================================
		  // these should all work
		  //
		  // SUBS
		  // =================================================================
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "Event Foo (  ) "
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "foo"
		    ErrorIf params <> ""
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name()"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> ""
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name(foo as string)"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string"
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name(foo     as     string)"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string"
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name(foo     as     string.string.string)"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string.string.string"
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name(foo     as     string.string.string , bar     as     string.string.string)"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name() as string"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> ""
		    ErrorIf returnType <> "string"
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name() as string.string.string"
		    
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> ""
		    ErrorIf returnType <> "string.string.string"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name(foo     as     string.string.string , bar     as     string.string.string) as string.string.string"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> "string.string.string"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name(foo()     as     string.string.string , bar     as     string.string.string) as string.string.string"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo() as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> "string.string.string"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name(foo()     as     string.string.string , bar     as     string.string.string) as string.string.string()"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo() as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> "string.string.string()"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event name(foo()     as     string.string.string , bar     as     string.string.string) as string.string.string(,)"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo() as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> "string.string.string()"
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Event getBoundPart(Str As String) As Object"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "getBoundPart"
		    ErrorIf params <> "Str As String"
		    ErrorIf returnType <> "Object"
		  End If
		  
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "Event getBoundPart(s as Ptr) As WindowPtr"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackEventDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePrivate
		    ErrorIf methodName <> "getBoundPart"
		    ErrorIf params <> "s as Ptr"
		    ErrorIf returnType <> "WindowPtr"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTest_ValidMethodDeclarations()
		  // if true blocks because they crate a new scope 
		  // so vars are not carried from oe block to another :P
		  
		  // =================================================================
		  // these should all work
		  //
		  // SUBS
		  // =================================================================
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "Public Sub Foo (  ) "
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "foo"
		    ErrorIf params <> ""
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name()"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> ""
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name(foo as string)"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string"
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name(foo     as     string)"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string"
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name(foo     as     string.string.string)"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string.string.string"
		    ErrorIf returnType <> ""
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "sub name(foo     as     string.string.string , bar     as     string.string.string)"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> ""
		  End If
		  
		  // FUNCTIONS
		  // =================================================================
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name() as string"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> ""
		    ErrorIf returnType <> "string"
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name() as string.string.string"
		    
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> ""
		    ErrorIf returnType <> "string.string.string"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name(foo     as     string.string.string , bar     as     string.string.string) as string.string.string"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> "string.string.string"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name(foo()     as     string.string.string , bar     as     string.string.string) as string.string.string"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo() as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> "string.string.string"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name(foo()     as     string.string.string , bar     as     string.string.string) as string.string.string()"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo() as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> "string.string.string()"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function name(foo()     as     string.string.string , bar     as     string.string.string) as string.string.string(,)"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "name"
		    ErrorIf params <> "foo() as string.string.string , bar as string.string.string"
		    ErrorIf returnType <> "string.string.string()"
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    
		    content = "Function getBoundPart(Str As String) As Object"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "getBoundPart"
		    ErrorIf params <> "Str As String"
		    ErrorIf returnType <> "Object"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "Function getBoundPart(s as Ptr) As WindowPtr"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "getBoundPart"
		    ErrorIf params <> "s as Ptr"
		    ErrorIf returnType <> "WindowPtr"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "Attributes(""foo"") Function getBoundPart(s As Ptr) As WindowPtr"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf attrs <> """foo"""
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "getBoundPart"
		    ErrorIf params <> "s as Ptr"
		    ErrorIf returnType <> "WindowPtr"
		  End If
		  
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "Attributes(""foo""=""asd"") Function getBoundPart(s As Ptr) As WindowPtr"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf attrs <> """foo""=""asd"""
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "getBoundPart"
		    ErrorIf params <> "s as Ptr"
		    ErrorIf returnType <> "WindowPtr"
		  End If
		  
		  If True Then
		    Dim content As String
		    Dim attrs As String
		    Dim scope As String
		    Dim subFunc As String
		    Dim methodName As String
		    Dim params As String
		    Dim returnType As String
		    
		    content = "Attributes(""foo"" = ""asd"" , ""bar"" ) Function getBoundPart(s As Ptr) As WindowPtr"
		    
		    // cracking will rip out multiple spaces
		    ErrorIf LanguageUtils.CrackMethodDeclaration(content, attrs, scope, subFunc, methodName, params, returnType) <> True
		    ErrorIf attrs <> """foo""=""asd"",""bar"""
		    ErrorIf scope <> kScopePublic
		    ErrorIf methodName <> "getBoundPart"
		    ErrorIf params <> "s as Ptr"
		    ErrorIf returnType <> "WindowPtr"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnitTest_ValidPropertyDecls()
		  // if true blocks because they crate a new scope 
		  // so vars are not carried from oe block to another :P
		  
		  // =================================================================
		  // thse should all work
		  // =================================================================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "dim name as string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePublic
		    ErrorIf propName <> "name"
		    ErrorIf type <> "string"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  
		  
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "dim name as string = ""this is a test"""
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePublic
		    ErrorIf propName <> "name"
		    ErrorIf type <> "string"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> """this is a test"""
		    
		  End If
		  
		  
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "name as string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePublic
		    ErrorIf propName <> "name"
		    ErrorIf type <> "string"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "dim name as String.string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePublic
		    ErrorIf propName <> "name"
		    ErrorIf type <> "String.string"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  // =======================
		  
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "private name as String"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePrivate
		    ErrorIf propName <> "name"
		    ErrorIf type <> "String"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "private name as String"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePrivate
		    ErrorIf propName <> "name"
		    ErrorIf type <> "String"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "private dim name as String"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePrivate
		    ErrorIf propName <> "name"
		    ErrorIf type <> "String"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "private name as String"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePrivate
		    ErrorIf propName <> "name"
		    ErrorIf type <> "String"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "Dim ÜberschriftDok As String"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf propName <> "ÜberschriftDok"
		    ErrorIf type <> "String"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "private name as Integer = 123"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf scope <> kScopePrivate
		    ErrorIf propName <> "name"
		    ErrorIf type <> "Integer"
		    ErrorIf isNew <> False
		    ErrorIf optionalDefault <> "123"
		    
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "Dim p as New Collection"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> False
		    ErrorIf propName <> "p"
		    ErrorIf type <> "Collection"
		    ErrorIf isNew <> True
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "Private shared dim p as New Collection"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isNew, type, optionalDefault) <> True
		    ErrorIf isShared <> true
		    ErrorIf propName <> "p"
		    ErrorIf type <> "Collection"
		    ErrorIf isNew <> True
		    ErrorIf optionalDefault <> ""
		    
		  End If
		  
		  
		  
		  // =======================
		  // =======================
		  // =======================
		  // =======================
		  // =======================
		  // =======================
		  // =======================
		  If True Then
		    // with the OPTIONAL "accept PROPERTY keywords ON this WORKS !!!!!!!!!!!
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    
		    src = "PROPERTY name as string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault, True) <> True
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    src = "PROPERTY name as string =""foo"""
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault, True) <> True
		    
		  End If
		  // =======================
		  
		  // =======================
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    
		    src = "PUBLIC PROPERTY name as string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault, True) <> True
		    
		  End If
		  
		  // =======================
		  
		  If True Then
		    Dim src As String
		    Dim isShared As Boolean
		    Dim scope As String
		    Dim propName As String
		    Dim isNew As Boolean
		    Dim type As String
		    Dim optionalDefault As String
		    
		    
		    src = "PUBLIC SHARED PROPERTY name as string"
		    
		    ErrorIf LanguageUtils.CrackPropertyDeclaration(src, isShared, scope, propName, isnew, type, optionalDefault, True) <> True
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function UnStringLiteral(token as string) As string
		  // take a string literal like 
		  //    "123" and return 123
		  //    "12""3" and return 12"3
		  
		  If IsStringLiteral(token) = False Then
		    Return token
		  End If
		  
		  Dim result As String = token.Middle(1, token.Length - 2)
		  
		  result = result.ReplaceAll("""""", """")
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function WhitespaceChars() As String
		  // Return whether the first character of c is a whitespace character.
		  Static retValue As String
		  
		  If retvalue.LenB <= 0 Then
		    
		    For i As Integer = 0 To 32
		      retvalue = retvalue + ChrB(i)
		    Next i
		    
		  End If
		  
		  Return retValue
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected mKeywordDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStandardCommentForm As CommentForms
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  
			  Return mStandardCommentForm
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Select Case value
			    // note this assumes that, for REM, it will be at the beginning of a line
			    
			  Case CommentForms.apostropheStyle
			    mStandardCommentForm = value
			  Case CommentForms.doubleSlashStyle
			    mStandardCommentForm = value
			  Case CommentForms.remStyle
			    mStandardCommentForm = value
			  Else
			    mStandardCommentForm = CommentForms.none
			  End Select
			  
			End Set
		#tag EndSetter
		Protected StandardCommentForm As CommentForms
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  // note this assumes that, for REM, it will be at the beginning of a line
			  Select Case mStandardCommentForm
			    
			  Case CommentForms.apostropheStyle
			    Return "' "
			  Case CommentForms.doubleSlashStyle
			    Return "// "
			  Case CommentForms.remStyle
			    Return "REM "
			  Case CommentForms.none
			    Return "// "
			  End Select
			End Get
		#tag EndGetter
		Protected StandardCommentFormStr As String
	#tag EndComputedProperty


	#tag Constant, Name = AllWhiteSpaceFlag, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = blockMatches, Type = String, Dynamic = False, Default = \"#if\t#else|#elseif|#endif\n#elseif\t#else|#elseif|#endif\n#else\t#endif\nif\telse|elseif|end|end if\nelseif\telse|elseif|end|end if\nelse\telse|end|end if|end select\nfor\tnext\ndo\tloop\nwhile\twend\nselect\tcase|else|end|end select\ncase\tcase|else|end|end select\ntry\tcatch|finally|end|end try\ncatch\tfinally|end|end try\nfinally\tend|end try\nsub\tend sub\nfunction\tend function\n", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EndOfLineFlag, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCLASS, Type = String, Dynamic = False, Default = \"Class", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCONST, Type = String, Dynamic = False, Default = \"Const", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kDIM, Type = String, Dynamic = False, Default = \"Dim", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEnum, Type = String, Dynamic = False, Default = \"Enum", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kPROPERTY, Type = String, Dynamic = False, Default = \"Property", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kScopeGlobal, Type = String, Dynamic = False, Default = \"Global", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kScopePrivate, Type = String, Dynamic = False, Default = \"Private", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kScopeProtected, Type = String, Dynamic = False, Default = \"Protected", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kScopePublic, Type = String, Dynamic = False, Default = \"Public", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kSTATIC, Type = String, Dynamic = False, Default = \"Static", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = NoWhiteSpaceFlag, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = parseFailure, Type = Boolean, Dynamic = False, Default = \"false", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = parseSuccess, Type = Boolean, Dynamic = False, Default = \"true", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = CommentForms, Type = Integer, Flags = &h0
		none = 0
		  remStyle = 1
		  apostropheStyle = 2
		doubleSlashStyle = 3
	#tag EndEnum

	#tag Enum, Name = Scope, Flags = &h0
		GlobalScope
		  PublicScope
		  ProtectedScope
		PrivateScope
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
