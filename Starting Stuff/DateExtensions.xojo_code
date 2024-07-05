#tag Module
Protected Module DateExtensions
	#tag Method, Flags = &h21
		Private Function dayOfWeek(dayName as string) As integer
		  Select Case dayName
		  Case "Sun" 
		    Return 1
		  Case "Mon" 
		    Return 2
		  Case "Tue"
		    Return 3
		  Case "Wed"
		    Return 4
		  Case "Thu"
		    Return 5
		  Case "Fri"
		    Return 6
		  Case "Sat"
		    Return 7
		  End Select
		  
		  Break
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function isDigits(toCheck as string, minDigits as integer, maxDigits as integer) As boolean
		  
		  Dim digits() As String = Split(toCheck, "")
		  
		  If digits.count < minDigits Or digits.Count > maxDigits Then
		    Return False
		  End If
		  
		  //  is it all digits ?
		  For Each digit As String In digits
		    Select Case digit
		    Case "0"
		    Case "1"
		    Case "2"
		    Case "3"
		    Case "4"
		    Case "5"
		    Case "6"
		    Case "7"
		    Case "8"
		    Case "9"
		    Else
		      Return False
		    End Select
		  Next digit
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsFoldingWhitespace(toCheck as string) As boolean
		  // in an rfc date FOLDING whitespace is JUST ascii space (32) and horizontal tab (9)
		  // + CR LF
		  // nothing else
		  
		  Dim chars() As String = Split(toCheck,"")
		  
		  For i as integer = 0 to chars.ubound
		    
		    Dim char As String = chars(i)
		    If char = &u09 Or char = &u20 Then
		    ElseIf char = &u0D Then // CR LF ( &uOD &uOA ) ???????? 
		      If i >= chars.ubound Then
		        Return False // we're at the end and no LF after CR
		      ElseIf chars(i+1) <> &u0A Then
		        Return False // we're at the end and no LF after CR
		      Else
		        i = i + 1
		      End If
		    Else
		      Return False
		    End If
		  Next
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ISO8601DateTimeStr(d as date) As string
		  
		  Return d.ISO8601DateTimeStr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ISO8601DateTimeStr(extends d as Date) As string
		  // formats a date as yyyy-MM-DD HH:MM:SS [+/-]hh:mm
		  // hh is HOURS offset from GMT
		  // mm is minutes offset from GMT
		  
		  Dim s As String 
		  
		  Dim hours As Integer
		  Dim mins As Integer
		  
		  hours = d.GMTOffset 
		  mins = (d.GMTOffset - hours) * 60
		  
		  hours = Abs(hours)
		  mins = Abs(mins)
		  
		  s = s + d.SQLDateTime
		  s = s +  " " + If(d.GMTOffset < 0, "-" , "+") + Format(hours,"00") + ":" + Format(mins,"00")
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function isTZName(zoneStr as string) As boolean
		  // zone            =   (FWS ( "+" / "-" ) 4DIGIT) / obs-zone
		  // obs-zone        =   "UT" / "GMT" /     ; Universal Time
		  // ; North American UT
		  // ; offsets
		  // "EST" / "EDT" /    ; Eastern:  - 5/ - 4
		  // "CST" / "CDT" /    ; Central:  - 6/ - 5
		  // "MST" / "MDT" /    ; Mountain: - 7/ - 6
		  // "PST" / "PDT" /    ; Pacific:  - 8/ - 7
		  // ;
		  // 
		  // %d65-73 /          ; Military zones - "A"
		  // %d75-90 /          ; through "I" And "K"
		  // %d97-105 /         ; through "Z", both
		  // %d107-122          ; upper And lower Case
		  
		  Select Case Uppercase(zoneStr)
		  Case "UT" ,"GMT" 
		  Case "EST", "EDT" //    ; Eastern:  - 5/ - 4
		  Case "CST", "CDT" //    ; Central:  - 6/ - 5
		  Case "MST", "MDT" //    ; Mountain: - 7/ - 6
		  Case "PST", "PDT" //    ; Pacific:  - 8/ - 7
		  Case "A", "B", "C", "D", "E", "F", "G", "H", "I" //          ; Military zones - "A"
		  Case "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" //          ; through "I" And "K"
		    //         ; through "Z", both UPPER & LOWER CASE
		  Else
		    Return False
		  End Select
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function isValidMonth(monthStr as string) As boolean
		  Select Case monthstr
		  Case "Jan" 
		  Case "Feb" 
		  Case "Mar" 
		  case "Apr" 
		  Case "May"
		  Case "Jun" 
		  Case "Jul" 
		  case "Aug" 
		  Case "Sep" 
		  Case "Oct" 
		  Case "Nov" 
		  Case "Dec"
		  Else
		    Return False
		  End Select
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsWhitespace(toCheck as string) As boolean
		  // in an rfc date whitespace is JUST ascii space (32) and horizontal tab (9)
		  // nothing else
		  
		  Dim chars() As String = Split(toCheck,"")
		  
		  For Each char As String In chars
		    
		    If char = &u09 Or char = &u20 Then
		    Else
		      Return False
		    End If
		  Next
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParseRFC5322Date(dateString as string) As DateTime
		  
		  // from https://www.rfc-editor.org/rfc/rfc5322#section-3.3
		  // updated by rfc 6854 (no change to date formats)
		  //
		  // 2.2.  Header Fields
		  // 
		  // Header fields are lines beginning With a field name, followed by a
		  // colon (":"), followed by a field body, And terminated by CRLF.  A
		  // field name MUST be composed Of printable US-ASCII characters (i.e.,
		  // characters that have values between 33 And 126, inclusive), except
		  // colon.  A field body may be composed Of printable US-ASCII characters
		  // As well As the space (SP, ASCII value 32) And horizontal tab (HTAB,           <<< WSP = TAB + SPACE
		  // ASCII value 9) characters (together known As the white space
		  // characters, WSP).  A field body MUST Not include CR And LF except
		  // when used In "folding" And "unfolding", As described In section
		  // 2.2.3.  All field bodies MUST conform To the syntax described In
		  // sections 3 And 4 Of this specification.
		  //
		  //
		  // 3.2.2.  Folding White Space And Comments
		  // 
		  // White space characters, including white space used In folding
		  // (described In section 2.2.3), may appear between many elements In
		  // header field bodies.  Also, strings Of characters that are treated As
		  // comments may be included In structured field bodies As characters
		  // enclosed In parentheses.  The following defines the folding white
		  // space (FWS) And comment constructs.
		  // 
		  // Strings Of characters enclosed In parentheses are considered comments
		  // so long As they Do Not appear within a "quoted-string", As defined In
		  // section 3.2.4.  Comments may nest.
		  // 
		  // There are several places In this specification where comments And FWS
		  // may be freely inserted.  To accommodate that syntax, an additional
		  // token For "CFWS" Is defined For places where comments And/Or FWS can
		  // occur.  However, where CFWS occurs In this specification, it MUST Not
		  // be inserted In such a way that any line Of a folded header field Is
		  // made up entirely Of WSP characters And nothing Else.
		  // 
		  // FWS             =   ([*WSP CRLF] 1*WSP) /  obs-FWS
		  // ; Folding white space
		  // 
		  // ctext           =   %d33-39 /          ; Printable US-ASCII
		  // %d42-91 /          ;  characters Not including
		  // %d93-126 /         ;  "(", ")", Or "\"
		  // obs-ctext
		  // 
		  // ccontent        =   ctext / quoted-pair / comment
		  // 
		  // comment         =   "(" *([FWS] ccontent) [FWS] ")"
		  // 
		  // CFWS            =   (1*([FWS] comment) [FWS]) / FWS
		  //
		  // 3.3.  Date And Time Specification
		  // 
		  // Date And time values occur In several header fields.  This section
		  // specifies the syntax For a full date And time specification.  Though
		  // folding white space Is permitted throughout the date-time
		  // specification, it Is RECOMMENDED that a Single space be used In Each
		  // place that FWS appears (whether it Is required Or Optional); some
		  // older implementations will Not interpret longer sequences Of folding
		  // white space correctly.
		  // 
		  // 
		  // 
		  // 
		  // Resnick                     Standards Track                    [Page 14]
		  // 
		  // RFC 5322                Internet Message Format             October 2008
		  // 
		  // 
		  // date-time       =   [ day-Of-week "," ] date time [CFWS]
		  // 
		  // day-Of-week     =   ([FWS] day-name) / obs-day-Of-week
		  // 
		  // day-name        =   "Mon" / "Tue" / "Wed" / "Thu" / "Fri" / "Sat" / "Sun"
		  // 
		  // date            =   day month year
		  // 
		  // day             =   ([FWS] 1*2DIGIT FWS) / obs-day
		  // 
		  // month           =   "Jan" / "Feb" / "Mar" / "Apr" /
		  // "May" / "Jun" / "Jul" / "Aug" /
		  // "Sep" / "Oct" / "Nov" / "Dec"
		  // 
		  // year            =   (FWS 4*DIGIT FWS) / obs-year
		  // 
		  // time            =   time-Of-day zone
		  // 
		  // time-Of-day     =   hour ":" minute [ ":" second ]
		  // 
		  // hour            =   2DIGIT / obs-hour
		  // 
		  // minute          =   2DIGIT / obs-minute
		  // 
		  // second          =   2DIGIT / obs-second
		  // 
		  // zone            =   (FWS ( "+" / "-" ) 4DIGIT) / obs-zone
		  // 
		  // The day Is the numeric day Of the month.  The year Is any numeric
		  // year 1900 Or later.
		  // 
		  // The time-Of-day specifies the number Of hours, minutes, And
		  // optionally seconds since midnight Of the date indicated.
		  // 
		  // The date And time-Of-day SHOULD express local time.
		  // 
		  // The zone specifies the offset from Coordinated Universal Time (UTC,
		  // formerly referred To As "Greenwich Mean Time") that the date And
		  // time-Of-day represent.  The "+" Or "-" indicates whether the time-Of-
		  // day Is ahead Of (i.e., east Of) Or behind (i.e., west Of) Universal
		  // Time.  The first two digits indicate the number Of hours difference
		  // from Universal Time, And the last two digits indicate the number Of
		  // additional minutes difference from Universal Time.  (Hence, +hhmm
		  // means +(hh * 60 + mm) minutes, And -hhmm means -(hh * 60 + mm)
		  // minutes).  The form "+0000" SHOULD be used To indicate a time zone at
		  // Universal Time.  Though "-0000" also indicates Universal Time, it Is
		  // used To indicate that the time was generated on a System that may be
		  // In a local time zone other than Universal Time And that the date-time
		  // contains no information about the local time zone.
		  // 
		  // A date-time specification MUST be semantically valid.  That Is, the
		  // day-Of-week (If included) MUST be the day implied by the date, the
		  // numeric day-Of-month MUST be between 1 And the number Of days allowed
		  // For the specified month (In the specified year), the time-Of-day MUST
		  // be In the range 00:00:00 through 23:59:60 (the number Of seconds
		  // allowing For a leap second; see [RFC1305]), And the last two digits
		  // Of the zone MUST be within the range 00 through 59.
		  // 
		  // 4.2.  Obsolete Folding White Space
		  // 
		  // In the obsolete syntax, any amount Of folding white space MAY be
		  // inserted where the obs-FWS rule Is allowed.  This creates the
		  // possibility Of having two consecutive "folds" In a line, And
		  // therefore the possibility that a line which makes up a folded header
		  // field could be composed entirely Of white space.
		  // 
		  // obs-FWS         =   1*WSP *(CRLF 1*WSP)
		  // 
		  // 4.3.  Obsolete Date And Time
		  // 
		  // The syntax For the obsolete date Format allows a 2 digit year In the
		  // date field And allows For a list Of alphabetic time zone specifiers
		  // that were used In earlier versions Of this specification.  It also
		  // permits comments And folding white space between many Of the tokens.
		  // 
		  // obs-day-Of-week =   [CFWS] day-name [CFWS]
		  // 
		  // obs-day         =   [CFWS] 1*2DIGIT [CFWS]
		  // 
		  // obs-year        =   [CFWS] 2*DIGIT [CFWS]
		  // 
		  // obs-hour        =   [CFWS] 2DIGIT [CFWS]
		  // 
		  // obs-minute      =   [CFWS] 2DIGIT [CFWS]
		  // 
		  // obs-second      =   [CFWS] 2DIGIT [CFWS]
		  // 
		  // obs-zone        =   "UT" / "GMT" /     ; Universal Time
		  // ; North American UT
		  // ; offsets
		  // "EST" / "EDT" /    ; Eastern:  - 5/ - 4
		  // "CST" / "CDT" /    ; Central:  - 6/ - 5
		  // "MST" / "MDT" /    ; Mountain: - 7/ - 6
		  // "PST" / "PDT" /    ; Pacific:  - 8/ - 7
		  // ;
		  // 
		  // %d65-73 /          ; Military zones - "A"
		  // %d75-90 /          ; through "I" And "K"
		  // %d97-105 /         ; through "Z", both
		  // %d107-122          ; upper And lower Case
		  // 
		  // Where a two Or three digit year occurs In a date, the year Is To be
		  // interpreted As follows: If a two digit year Is encountered whose
		  // value Is between 00 And 49, the year Is interpreted by adding 2000,
		  // ending up With a value between 2000 And 2049.  If a two digit year Is
		  // encountered With a value between 50 And 99, Or any three digit year
		  // Is encountered, the year Is interpreted by adding 1900.
		  // 
		  // In the obsolete time zone, "UT" And "GMT" are indications Of
		  // "Universal Time" And "Greenwich Mean Time", respectively, And are
		  // both semantically identical To "+0000".
		  // 
		  // The remaining three character zones are the US time zones.  The first
		  // letter, "E", "C", "M", Or "P" stands For "Eastern", "Central",
		  // "Mountain", And "Pacific".  The second letter Is either "S" For
		  // "Standard" time, Or "D" For "Daylight Savings" (Or summer) time.
		  // Their interpretations are As follows:
		  // 
		  // EDT Is semantically equivalent To -0400
		  // EST Is semantically equivalent To -0500
		  // CDT Is semantically equivalent To -0500
		  // CST Is semantically equivalent To -0600
		  // MDT Is semantically equivalent To -0600
		  // MST Is semantically equivalent To -0700
		  // PDT Is semantically equivalent To -0700
		  // PST Is semantically equivalent To -0800
		  // 
		  // The 1 character military time zones were defined In a non-standard
		  // way In [RFC0822] And are therefore unpredictable In their meaning.
		  // The original definitions Of the military zones "A" through "I" are
		  // equivalent To "+0100" through "+0900", respectively; "K", "L", And
		  // "M" are equivalent To "+1000", "+1100", And "+1200", respectively;
		  // "N" through "Y" are equivalent To "-0100" through "-1200".
		  // respectively; And "Z" Is equivalent To "+0000".  However, because Of
		  // the error In [RFC0822], they SHOULD all be considered equivalent To
		  // "-0000" unless there Is out-Of-band information confirming their
		  // meaning.
		  // 
		  // Other multi-character (usually between 3 And 5) alphabetic time zones
		  // have been used In Internet messages.  Any such time zone whose
		  // meaning Is Not known SHOULD be considered equivalent To "-0000"
		  // unless there Is out-Of-band information confirming their meaning.
		  //
		  // // above obsoletes https://www.rfc-wiki.org/wiki/RFC2822
		  // // above obsoletes https://www.w3.org/Protocols/rfc822/#z26
		  
		  Dim tokens() As String = LanguageUtils.TokenizeLine( Trim(dateString) )
		  
		  // folding white space ?
		  // FWS             =   ([*WSP CRLF] 1*WSP) /  obs-FWS
		  While tokens.Count > 0 And IsFoldingWhitespace(tokens(0))
		    tokens.remove 0
		  Wend
		  
		  // date-time       =   [ day-Of-week "," ] date time [CFWS]
		  // day-Of-week     =   ([FWS] day-name) / obs-day-Of-week
		  // 
		  // day-name        =   "Mon" / "Tue" / "Wed" / "Thu" / "Fri" / "Sat" / "Sun"
		  // 
		  
		  Dim dayName As String
		  
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  // is the first token one of our day names ?
		  Select Case tokens(0)
		  Case "Mon" , "Tue" , "Wed" , "Thu" , "Fri" , "Sat" , "Sun" // day-name
		    dayName = tokens(0)
		    tokens.remove 0
		    // white space ?
		    If tokens.count <= 0 Then
		      // break
		      Return Nil
		    End If
		    If IsWhitespace(tokens(0)) = True Then
		      tokens.remove 0
		    End If
		    // now a comma
		    If tokens.count <= 0 Then
		      // break
		      Return Nil
		    End If
		    If tokens(0) <> "," Then
		      // break
		      Return Nil
		    Else
		      tokens.remove 0
		    End If
		  Else
		    // break
		    Return Nil
		  End Select
		  
		  
		  // NOW a DATE
		  // date-time       =   [ day-Of-week "," ] date time [CFWS] 
		  // date            =   day month year
		  // 
		  // day             =   ([FWS] 1*2DIGIT FWS) / obs-day
		  // 
		  // month           =   "Jan" / "Feb" / "Mar" / "Apr" /
		  // "May" / "Jun" / "Jul" / "Aug" /
		  // "Sep" / "Oct" / "Nov" / "Dec"
		  // 
		  // year            =   (FWS 4*DIGIT FWS) / obs-year
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If IsWhitespace(tokens(0)) Then
		    tokens.remove 0
		  End If
		  
		  // day
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If isDigits(tokens(0),1,2) <> True Then
		    // break
		    Return Nil
		  End If
		  Dim dayDigits As String = tokens(0)
		  tokens.remove 0
		  
		  // month
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If IsWhitespace(tokens(0)) Then
		    tokens.remove 0
		  End If
		  
		  If isValidMonth(tokens(0)) = False Then
		    // break
		    Return Nil
		  End If
		  Dim monthName As String = tokens(0)
		  tokens.remove 0
		  
		  // year
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If IsWhitespace(tokens(0)) Then
		    tokens.remove 0
		  End If
		  
		  If isDigits(tokens(0),4,4) = False Then
		    // break
		    Return Nil
		  End If
		  Dim yearDigits As String = tokens(0)
		  tokens.remove 0
		  
		  // time            =   time-Of-day zone
		  // 
		  // time-Of-day     =   hour ":" minute [ ":" second ]
		  // 
		  // hour            =   2DIGIT / obs-hour
		  // 
		  // minute          =   2DIGIT / obs-minute
		  // 
		  // second          =   2DIGIT / obs-second
		  // 
		  // zone            =   (FWS ( "+" / "-" ) 4DIGIT) / obs-zone
		  
		  // hour
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If IsWhitespace(tokens(0)) Then
		    tokens.remove 0
		  End If
		  
		  If isDigits(tokens(0),2,2) = False Then
		    // break
		    Return Nil
		  End If
		  Dim hourDigits As String = tokens(0)
		  tokens.remove 0
		  
		  // :
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If IsWhitespace(tokens(0)) Then
		    tokens.remove 0
		  End If
		  
		  If tokens(0) <> ":" Then
		    // break
		    Return Nil
		  End If
		  tokens.remove 0
		  
		  // minute
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If IsWhitespace(tokens(0)) Then
		    tokens.remove 0
		  End If
		  
		  If isDigits(tokens(0),2,2) = False Then
		    // break
		    Return Nil
		  End If
		  Dim minDigits As String = tokens(0)
		  tokens.remove 0
		  
		  // seconds
		  Dim secondDigits As String = "00"
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If IsWhitespace(tokens(0)) Then
		    tokens.remove 0
		  End If
		  If tokens(0) = ":" Then // optional seconds ?
		    tokens.remove 0
		    
		    If tokens.count <= 0 Then
		      // break
		      Return Nil
		    End If
		    If IsWhitespace(tokens(0)) Then
		      tokens.remove 0
		    End If
		    If isDigits(tokens(0),2,2) = False Then
		      // break
		      Return Nil
		    End If
		    secondDigits = tokens(0)
		    tokens.remove 0
		  End If
		  
		  // zone - complicated
		  // +4dig / - 4dig / GMT / UT and several others are valid
		  Dim zoneSign As String
		  Dim zoneOffsetStr As String
		  Dim zoneStr As String
		  If tokens.count <= 0 Then
		    // break
		    Return Nil
		  End If
		  If IsWhitespace(tokens(0)) Then
		    tokens.remove 0
		  End If
		  If tokens(0) = "+" Or tokens(0) = "-" Then
		    zoneSign = tokens(0)
		    tokens.remove 0
		    If tokens.count <= 0 Then
		      // break
		      Return Nil
		    End If
		    If isDigits(tokens(0),4,4) = False Then
		      // break
		      Return Nil
		    End If
		    zoneOffsetStr = tokens(0)
		    tokens.remove 0
		    
		  ElseIf isTZName(tokens(0)) Then
		    zoneStr = tokens(0)
		    tokens.remove 0
		    zoneSign = "-"
		    
		    Select Case zoneStr
		    Case "EDT" // EDT Is semantically equivalent To -0400
		      zoneOffsetStr = "0400"
		    Case "EST" // EST Is semantically equivalent To -0500
		      zoneOffsetStr = "0500"
		    Case "CDT" // CDT Is semantically equivalent To -0500
		      zoneOffsetStr = "0500"
		    Case "CST" // CST Is semantically equivalent To -0600
		      zoneOffsetStr = "0600"
		    Case "MDT" // MDT Is semantically equivalent To -0600
		      zoneOffsetStr = "0600"
		    Case "MST" // MST Is semantically equivalent To -0700
		      zoneOffsetStr = "0700"
		    Case "PDT" // PDT Is semantically equivalent To -0700
		      zoneOffsetStr = "0700"
		    Case "PST" // PST Is semantically equivalent To -0800
		      zoneOffsetStr = "0800"
		    Else
		      // break
		      Return Nil
		    End Select
		  Else
		    // break
		    Return Nil
		  End If
		  
		  // zoneOffsetStr = "HHMM"
		  Dim hoursOffset As Integer = Val(zoneOffsetStr.Left(2)) * 60 * 60
		  Dim minutesOffset As Integer = Val(zoneOffsetStr.Right(2)) * 60 
		  Dim totalSecondsOffset As Integer = hoursOffset + minutesOffset
		  If zoneSign = "-" Then
		    totalSecondsOffset = -1 * totalSecondsOffset
		  End If
		  
		  If tokens.count <> 0 Then
		    // break
		    Return Nil
		  End If
		  
		  Dim tz As New TimeZone( totalSecondsOffset )
		  Dim year, month, day, hour, minute, second As Integer
		  year = Val(yearDigits)
		  month = toMonthNumber(monthName)
		  day = Val(dayDigits)
		  hour = Val(hourDigits)
		  minute = Val(minDigits)
		  second = Val(secondDigits)
		  
		  #Pragma BreakOnExceptions False
		  
		  Try
		    Dim tmpDate As New datetime(year, month, day, hour, minute, second, 0, tz)
		    // we need to validate that the DOW is right 
		    // just in case they said "Wed Oct 1 , 2022" but Oct 1, 2022 ISNT wed !!!!!!!!!!!
		    If tmpDate.DayOfWeek <> dayOfWeek(dayName) Then
		      // break
		      #Pragma BreakOnExceptions Default
		      Return Nil
		    End If
		    
		    #Pragma BreakOnExceptions Default
		    Return tmpDate
		    
		  Catch iax As InvalidArgumentException
		    // break
		    #Pragma BreakOnExceptions Default
		    
		    Return Nil
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunUnitTests()
		  #If DebugBuild
		    // TEST ZONE STRINGS
		    Dim validList() As String = Array("UT", "GMT", "EST", "EDT", "CST", "CDT", "MST", "MDT", "PST", "PDT", _
		    "A", "B", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" )
		    For Each tzStr As String In validList
		      If isTZName(tzStr) <> True Then
		        Break
		      End If
		    Next tzStr
		    // now a bunch that are not valid
		    Dim invalidList() As String = Array("U T", "GM T", "E ST", "E DT", "CS T", "C DT", "M ST", "M DT", "P ST", "P D T", _
		    " A", "B ", " C", "dD", "Ee", "fF", "G.", ";H", "'I", "j", "'K", """L", ":M", "[N", "]O", "{P", "Q}", "~R", "!S", "@T", "$U", "%V", "%W", "^X", "&Y", "*Z" )
		    For Each tzStr As String In invalidList
		      If isTZName(tzStr) = True Then
		        Break
		      End If
		    Next tzStr
		    
		    // test IsWhiteSpace
		    //  space (32) and horizontal tab (9)
		    If IsWhitespace(" ") <> True Then
		      Break
		    End If
		    If IsWhitespace(Encodings.UTF8.Chr(9)) <> True Then
		      Break
		    End If
		    If IsWhitespace(" "+Encodings.UTF8.Chr(9)) <> True Then
		      Break
		    End If
		    If IsWhitespace(Encodings.UTF8.Chr(9)+" ") <> True Then
		      Break
		    End If
		    
		    If IsWhitespace(Encodings.UTF8.Chr(1)) = True Then
		      Break
		    End If
		    If IsWhitespace(".") = True Then
		      Break
		    End If
		    
		    
		    // test IsDigits
		    If isDigits("0",1,2) <> True Then
		      Break
		    End If
		    If isDigits("01",1,2) <> True Then
		      Break
		    End If
		    
		    If isDigits("034",1,2) = True Then
		      Break
		    End If
		    If isDigits("a",1,1) = True Then
		      Break
		    End If
		    If isDigits(&u2150,1,1) = True Then
		      Break
		    End If
		    
		    // test isFoldiingWhitespace
		    // JUST ascii space (32) And horizontal tab (9)
		    // + CR LF
		    
		    
		    // should all pass !!!!!!
		    If True Then
		      Dim tmp As DateTime = ParseRFC5322Date("Wed, 12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		      If tmp.DayOfWeek <> dayOfWeek("Wed") Then 
		        Break
		      End If
		      If tmp.Day <> 12 Then 
		        Break
		      End If
		      If tmp.Month <> 10 Then 
		        Break
		      End If
		      If tmp.Year <> 2022 Then 
		        Break
		      End If
		      If tmp.hour <> 21 Then 
		        Break
		      End If
		      If tmp.minute <> 29 Then 
		        Break
		      End If
		      If tmp.Second <> 52 Then 
		        Break
		      End If
		      If tmp.Timezone.SecondsFromGMT <> 0 Then
		        Break
		      End If
		    End If
		    // try some different tz's
		    If True Then 
		      Dim tmp As DateTime = ParseRFC5322Date("Wed, 12 Oct 2022 21:29:52 -0700") 
		      If tmp Is Nil Then
		        Break
		      End If
		      If tmp.DayOfWeek <> dayOfWeek("Wed") Then 
		        Break
		      End If
		      If tmp.Day <> 12 Then 
		        Break
		      End If
		      If tmp.Month <> 10 Then 
		        Break
		      End If
		      If tmp.Year <> 2022 Then 
		        Break
		      End If
		      If tmp.hour <> 21 Then 
		        Break
		      End If
		      If tmp.minute <> 29 Then 
		        Break
		      End If
		      If tmp.Second <> 52 Then 
		        Break
		      End If
		      If tmp.Timezone.SecondsFromGMT <> (-1 * 7 * 60 * 60) Then
		        Break
		      End If
		      
		    End If
		    
		    
		    
		    If  True Then
		      Dim tmp As DateTime = ParseRFC5322Date("Wed,      12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		    End If
		    If  True Then
		      Dim tmp As DateTime = ParseRFC5322Date(" Wed, 12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		    End If
		    If True Then 
		      Dim tmp As DateTime = ParseRFC5322Date("     Wed, 12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		    End If
		    If True Then
		      Dim tmp As DateTime = ParseRFC5322Date(Encodings.UTF8.Chr(9) + "Wed, 12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		    End If
		    If True Then
		      Dim tmp As DateTime = ParseRFC5322Date(Encodings.UTF8.Chr(9) + " Wed, 12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		    End If
		    If True Then
		      Dim tmp As DateTime = ParseRFC5322Date(Encodings.UTF8.Chr(9) + " Wed, 12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		    End If
		    If True Then
		      Dim tmp As DateTime = ParseRFC5322Date(" " + Encodings.UTF8.Chr(9) + " " + Encodings.UTF8.Chr(9) + "     Wed, 12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		    End If
		    If True Then
		      Dim tmp As DateTime = ParseRFC5322Date(" " + Encodings.UTF8.Chr(9) + &u0D + &u0A + " " + Encodings.UTF8.Chr(9) + "     Wed, 12 Oct 2022 21:29:52 +0000") 
		      If tmp Is Nil Then
		        Break
		      End If
		    End If
		    
		    /// ======================/// ======================/// ======================/// ======================/// ======================
		    /// ======================/// ======================/// ======================/// ======================/// ======================
		    /// ======================/// ======================/// ======================/// ======================/// ======================
		    
		    // should all fail !!!!!!
		    If ParseRFC5322Date("asdkljlausduaysd asodu asd Wed, 12 Oct 2022 21:29:52 +0000") <> Nil Then // garbage before date
		      Break
		    End If
		    If ParseRFC5322Date("Wed 12 Oct 2022 21:29:52 +0000")  <> Nil Then // malformed - no , after DAY
		      Break
		    End If
		    If ParseRFC5322Date("Wed,      Oct 2022 21:29:52 +0000")  <> Nil Then // malformed - no day #
		      Break
		    End If
		    If ParseRFC5322Date(" Wed, 12 2022 21:29:52 +0000")  <> Nil Then // malformed
		      Break
		    End If
		    If ParseRFC5322Date(" Wed, 12 Oct 21:29:52 +0000")  <> Nil Then // malformed
		      Break
		    End If
		    If ParseRFC5322Date(" Wed, 12 Oct 2022 29:52 +0000")  <> Nil Then // malformed hour out of range
		      Break
		    End If
		    If ParseRFC5322Date(" Wed, 12 Oct 2022 21:29:52")  <> Nil Then // malformed no TZ
		      Break
		    End If
		    If ParseRFC5322Date(" Wed,  1 Oct 2022 21:29:52 +0000")  <> Nil Then // malformed - NO SUCH DATE ! (oct 1 2022 is NOT wed !)
		      Break
		    End If
		    If ParseRFC5322Date(" " + Encodings.UTF8.Chr(1) + &u0D + &u0A + " " + Encodings.UTF8.Chr(9) + "     Wed, 12 Oct 2022 21:29:52 +0000")  <> Nil Then // invalid chars !
		      Break
		    End If
		    
		    /// ======================/// ======================/// ======================/// ======================/// ======================
		    /// ======================/// ======================/// ======================/// ======================/// ======================
		    /// ======================/// ======================/// ======================/// ======================/// ======================
		    
		    
		    Dim resetDateTime As Date
		    Dim s As String
		    
		    // note for DATE the difference between local time and Greenwich Mean Time (aka UTC) in hours. 
		    // 2023-11-15 16:35:0 -07:00
		    resetDateTime = New date(2023, 11, 15, 16, 35, 0, -7.0 )
		    s = ISO8601DateTimeStr(resetDateTime)
		    
		    If s <> "2023-11-15 16:35:00 -07:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    // 2023-11-15 16:35:0 +00:00
		    resetDateTime = New date(2023, 11, 15, 16, 35, 0, 0 )
		    s = ISO8601DateTimeStr(resetDateTime)
		    If s <> "2023-11-15 16:35:00 +00:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    // 2023-11-15 16:35:0 +07:00
		    resetDateTime = New date(2023, 11, 15, 16, 35, 0, 7.0 )
		    s = ISO8601DateTimeStr(resetDateTime)
		    If s <> "2023-11-15 16:35:00 +07:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    resetDateTime = New date(2023, 11, 15, 16, 35, 0, -7.0 )
		    s = resetDateTime.ToISO8601
		    If s <> "2023-11-15 16:35:00 -07:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    // 2023-11-15 16:35:0 +00:00
		    resetDateTime = New date(2023, 11, 15, 16, 35, 0, 0 )
		    s = resetDateTime.ToISO8601
		    If s <> "2023-11-15 16:35:00 +00:00" Then
		      Raise New UnsupportedOperationException
		    End If
		    
		    // 2023-11-15 16:35:0 +07:00
		    resetDateTime = New date(2023, 11, 15, 16, 35, 0, 7.0 )
		    s = resetDateTime.ToISO8601
		    If s <> "2023-11-15 16:35:00 +07:00" Then
		      Raise New UnsupportedOperationException
		    End If
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToISO8601(extends d as date) As string
		  Return DateExtensions.ISO8601DateTimeStr(d)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function toMonthNumber(monthName as string) As integer
		  Select Case monthName
		  Case "Jan" 
		    Return 1
		  Case "Feb" 
		    Return 2
		  Case "Mar" 
		    Return 3
		  Case "Apr" 
		    Return 4
		  Case "May"
		    Return 5
		  Case "Jun" 
		    Return 6
		  Case "Jul" 
		    Return 7
		  Case "Aug" 
		    Return 8
		  Case "Sep" 
		    Return 9
		  Case "Oct" 
		    Return 10
		  Case "Nov" 
		    Return 11
		  Case "Dec"
		    Return 12
		  End Select
		  
		  Break
		  Return 0
		  
		  
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
