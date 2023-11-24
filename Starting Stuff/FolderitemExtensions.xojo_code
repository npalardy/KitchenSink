#tag Module
Protected Module FolderitemExtensions
	#tag Method, Flags = &h0
		Sub CreateDirectory(extends f as folderitem)
		  // ok so the entire path to this item might have several missing items and we need to create the items down to the leaf
		  
		  Dim parts() As folderitem
		  Dim foundValidStartingPoint As Boolean
		  
		  Try
		    While f <> Nil
		      parts.append f
		      f = f.parent
		      If f.Exists = true Then
		        foundValidStartingPoint = True
		        Exit
		      End If
		    Wend
		  Catch noe As NilObjectException
		    Break
		  End Try
		  
		  If foundValidStartingPoint = False Then
		    Break
		    Raise New CreateDirectoryException("folder path cant be created")
		  End If
		  
		  For i As Integer = parts.LastIndex DownTo 0
		    
		    Try
		      parts(i).CreateFolder
		    Catch iox As IOException
		      Break
		      Raise New CreateDirectoryException("folder path cant be created")
		    End Try
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteFolderAndContents(extends f as folderitem)
		  Dim items() As FolderItem
		  For i As Integer = 1 To f.Count
		    items.append f.item(i)
		  Next
		  
		  For i As Integer = items.Ubound DownTo 0
		    Dim thisItem As Folderitem = Items(i)
		    
		    If thisItem.Directory Then
		      thisItem.DeleteFolderAndContents
		    End If
		    
		    thisItem.Delete
		    
		    #If DebugBuild 
		      If thisItem.Exists Then
		        Break
		      End If
		    #EndIf
		    
		  Next
		  
		  f.Delete
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Extension(extends fi as FolderItem) As string
		  // extension 
		  // 1) must have a period
		  // 2) mutliple dots are ok
		  // 3) bit after last period is the "extension"
		  
		  Dim parts() As String
		  
		  parts = Split(fi.Name, ".")
		  If parts.Count <=1 Then 
		    Return ""
		  End If
		  
		  Return parts(parts.ubound)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindRelativeChild(extends baseitem as folderitem, pathToClass as string) As FolderItem
		  Dim f As FolderItem = baseitem.Parent
		  Dim parts() As String = Split(pathToClass, "\")
		  For i As Integer = 0 To parts.ubound-1
		    If parts(i) = ".." Then
		      f = f.parent
		    Else
		      f = f.Child(parts(i))
		    End If
		  Next
		  f = f.Child( parts(parts.ubound) )
		  
		  // this is a total hack for this specific use case in this app !!!!!!
		  If (parts(parts.Ubound).InStr("ü") > 0) And (f Is Nil Or f.exists = False) Then
		    
		    Break
		    Dim newvalue As String = ReplaceAll( parts(parts.ubound), ChrB(&hC3)+ChrB(&hBC), ChrB(&hC2)+ChrB(&h81))
		    
		    Dim newUrl As String = baseitem.Parent.URLPath + "/" + EncodeURLComponent(newvalue)
		    f = GetFolderItem(newUrl, FolderItem.PathTypeURL)
		    
		    If f Is Nil Or f.exists = False Then
		      
		      Break
		      newvalue = ReplaceAll( parts(parts.ubound), ChrB(&hFC), ChrB(&hC2)+ChrB(&h81))
		      
		      newUrl = baseitem.Parent.URLPath + "/" + EncodeURLComponent(newvalue)
		      f = GetFolderItem(newUrl, FolderItem.PathTypeURL)
		    End If
		  End If
		  
		  Return f
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetFileValue(f As FolderItem, key As String, ByRef result As ptr) As Boolean
		  #If TargetMacOS
		    // Gets an NSURL resource value for the given FolderItem.
		    //
		    // @param f The FolderItem to inspect (non-nil).
		    // @param key The NSURL resource value key. See the documentation for NSURL.
		    // @param result Upon return, the resource value or error.
		    // @result Whether or not the function succeeded.
		    
		    Declare Function dlopen Lib "System" ( path As CString, mode As Integer ) As ptr
		    Declare Function dlsym Lib "System" ( handle As PTr, name As CString ) As ptr
		    Const RTLD_LAZY = 1
		    Const RTLD_GLOBAL = 8
		    
		    Dim libPtr As ptr = dlopen( "/System/Library/Frameworks/Foundation.framework/Foundation", RTLD_LAZY Or RTLD_GLOBAL )
		    If libPtr = Nil Then 
		      Return False
		    End If
		    
		    Dim symPtr As ptr = dlsym( libPtr, key )
		    If symPtr = Nil Then 
		      Return False
		    End If
		    
		    // Now we can create the URL and get the value
		    Declare Function NSClassFromString Lib "Foundation" ( name As CFStringRef ) As ptr
		    Declare Function URLWithString Lib "Foundation" selector "URLWithString:" ( obj As ptr, Str As CFStringRef ) As ptr
		    Declare Function getResourceValue Lib "Foundation" selector "getResourceValue:forKey:error:" _
		    ( obj As ptr, ByRef Val As ptr, key As ptr, ByRef error As ptr ) As Boolean
		    
		    Dim fileURL As ptr = URLWithString( NSClassFromString( "NSURL" ), f.URLPath )
		    
		    Dim value, error As ptr
		    
		    If getResourceValue( fileURL, value, symPtr.ptr, error ) Then
		      result = value
		      Return True
		    Else
		      result = error
		      Return False
		    End If
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IconForFile(extends f as folderitem, tSize as Size, optional QuickLookIcon as Boolean = true) As Picture
		  #If TargetMacOS Then
		    
		    #Pragma DisableBackgroundTasks
		    #Pragma DisableBoundsChecking
		    #Pragma NilObjectChecking False
		    
		    If f = Nil Or Not f.Exists Then Return Nil
		    
		    Dim path As String = f.NativePath
		    
		    // Declare for allocating (reserving memory for) an Objective-C object
		    // https://developer.apple.com/documentation/objectivec/nsobject/1571958-alloc/
		    Declare Function Alloc Lib "Foundation" Selector "alloc" (classRef As ptr) As ptr
		    
		    // Declare for autoreleasing (freeing from memory) an Objective-C object
		    // https://developer.apple.com/documentation/foundation/nsautoreleasepool/1807021-autorelease/
		    Declare Sub AutoRelease Lib "Foundation" Selector "autorelease" (classInstance As ptr)
		    
		    // Declare for getting a reference to an Objective-C class based on the received String
		    // https://developer.apple.com/documentation/foundation/1395135-nsclassfromstring?language=objc
		    Soft Declare Function NSClassFromString Lib "Foundation" (className As CFStringRef) As ptr
		    
		    // Declare for getting a reference to the shared Workspace of macOS process.
		    // https://developer.apple.com/documentation/appkit/nsworkspace/1530344-sharedworkspace/
		    Soft Declare Function sharedWorkSpace Lib "AppKit" Selector "sharedWorkspace" (classObject As ptr) As ptr
		    
		    // Declare for getting the Icon object from the recived file path
		    // https://developer.apple.com/documentation/appkit/nsworkspace/1528158-iconforfile/
		    Soft Declare Function iconForFile Lib "AppKit" Selector "iconForFile:" (instanceObject As ptr, path As CFStringRef) As ptr
		    
		    // Declare for setting the size of an NSImage
		    Soft Declare Function setSize Lib "AppKit" Selector "setSize:" (instanceObject As ptr, size As NSSize) As ptr
		    
		    // Declare for Lock and Unlock an NSImage in Objective-C
		    // https://developer.apple.com/documentation/appkit/nsimage/1519891-lockfocus?language=objc
		    // https://developer.apple.com/documentation/appkit/nsimage/1519853-unlockfocus?language=objc
		    Declare Sub LockFocus Lib "AppKit" Selector "lockFocus" (imageObj As ptr)
		    Declare Sub UnlockFocus Lib "AppKit" Selector "unlockFocus" (imageObj As ptr)
		    
		    // Declare for getting a new Bitmap Representation based on the Locked view
		    Declare Function InitWithFocusedView Lib "AppKit" Selector "initWithFocusedViewRect:" (imageObj As ptr, rect As NSRect) As ptr
		    
		    // Declare for getting an NSData object with the specified image format from a Bitmap Representation
		    // https://developer.apple.com/documentation/appkit/nsbitmapimagerep/1395458-representationusingtype/
		    Declare Function RepresentationUsingType Lib "AppKit" Selector "representationUsingType:properties:" (imageRep As ptr, type As UInteger, properties As ptr) As ptr
		    
		    Dim targetSize As NSSize
		    targetSize.Width = tsize.Width
		    targetSize.Height = tsize.Height
		    
		    Dim tRect As NSRect
		    tRect.Origin.x = 0
		    tRect.Origin.y = 0
		    tRect.RectSize = targetSize
		    
		    Dim data As ptr
		    
		    If QuickLookIcon Then
		      
		      //=================
		      // Let's try to retrieve the icon from QuickLooky
		      
		      Dim dictClass As ptr = NSClassFromString("NSDictionary")
		      Dim numberClass As ptr = NSClassFromString("NSNumber")
		      
		      // Declare for getting an NSNumber object from the received Boolean value
		      // https://developer.apple.com/documentation/foundation/nsnumber/1551475-numberwithbool/
		      
		      Declare Function NSNumberWithBool Lib "Foundation" Selector "numberWithBool:" (numberClass As ptr, value As Boolean) As ptr
		      Dim numberWithBool As ptr = NSNumberWithBool(numberClass, True)
		      
		      // Declare for getting an NSDictionary object from the received Key and Value
		      // https://developer.apple.com/documentation/foundation/nsdictionary/1414965-dictionarywithobject/
		      
		      Declare Function NSDictionaryWithObject Lib "Foundation" Selector "dictionaryWithObject:forKey:" (dictClass As ptr, value As ptr, key As CFStringRef) As ptr
		      Dim dictInstance As ptr = NSDictionaryWithObject(dictClass, numberWithBool,"IconMode")
		      
		      Dim fileClass As ptr = NSClassFromString("NSURL")
		      
		      // Declare for getting an NSURL object from the received path as string
		      // https://developer.apple.com/documentation/foundation/nsurl/1410828-fileurlwithpath/
		      
		      Declare Function NSFileURLWithPath Lib "Foundation" Selector "fileURLWithPath:" (fileClass As ptr, path As CFStringRef) As ptr
		      Dim fileInstance As ptr = NSFileURLWithPath(fileClass, f.NativePath)
		      
		      // Declare for getting the QuickLook based icon thumbnail for the received file and with the specified size
		      // https://developer.apple.com/documentation/quicklook/1402623-qlthumbnailimagecreate?language=objc
		      
		      Declare Function QLThumbnailImageCreate Lib "QuickLook" (allocator As Integer, file As ptr, size As NSSize, dictRef As ptr) As ptr
		      Dim imageRef As ptr = QLThumbnailImageCreate(0, fileInstance, targetSize, dictInstance)
		      
		      If imageref <> Nil Then
		        
		        Dim BitmapImageRepClass As ptr = NSClassFromString("NSBitmapImageRep")
		        Dim BitmapImageRepInstance As ptr = Alloc(BitmapImageRepClass)
		        
		        // https://developer.apple.com/documentation/appkit/nsbitmapimagerep/1395423-initwithcgimage/
		        
		        Declare Function CGInitWithCGImage Lib "AppKit" Selector "initWithCGImage:" (bitmapInstance As ptr, CGImage As ptr) As ptr
		        Dim BitmapImageRep As ptr = CGInitWithCGImage(BitmapImageRepInstance, imageRef)
		        
		        data = RepresentationUsingType(bitmapImageRep,4, Nil) // 4 = PNG
		        
		        AutoRelease(BitmapImageRep)
		        AutoRelease(imageref)
		        
		        // Getting Xojo Picture instance from NSData object
		        Var p As Picture = NSDataToPicture(data)
		        
		        data = Nil
		        numberWithBool = Nil
		        fileInstance = Nil
		        dictInstance = Nil
		        BitmapImageRepInstance = Nil
		        Return p
		        
		      End If
		    End If
		    
		    // If we reach this point is because there is no way to retrieve the
		    // QuickLook icon for the file, it has returned a non valid object,
		    // or we received the optional QuickLookIcon param set to False,
		    // so we fallback to the regular one (FileType based).
		    
		    Dim WorkSpace As ptr = NSClassFromString("NSWorkspace")
		    Dim sharedSpace As ptr = sharedWorkSpace(WorkSpace)
		    Dim icon As ptr = iconForFile(sharedSpace, path) // We get NSImage here
		    
		    Dim resizedIcon As ptr = setSize(icon, targetSize)
		    
		    // Getting bitmap image representation in order to extract the data as PNG.
		    
		    LockFocus(resizedIcon)
		    
		    Dim NSBitmapImageRepClass As ptr = NSClassFromString("NSBitmapImageRep")
		    Dim NSBitmapImageRepInstance As ptr = Alloc(NSBitmapImageRepClass)
		    Dim newRep As ptr = InitWithFocusedView(NSBitmapImageRepInstance, tRect)
		    
		    UnlockFocus(resizedIcon)
		    
		    data = RepresentationUsingType(newRep,4, Nil) // 4 = PNG
		    
		    // Getting Xojo Picture instance from NSData object
		    Var p As Picture = NSDataToPicture(data)
		    
		    data = Nil
		    icon = Nil
		    AutoRelease(newRep)
		    
		    Return p
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsPackage(extends f As FolderItem) As Boolean
		  #If TargetMacOS
		    Declare Function boolValue Lib "Foundation" selector "boolValue" ( obj As ptr ) As Boolean
		    
		    Dim isPackage As ptr
		    
		    If GetFileValue( f, "NSURLIsPackageKey", isPackage ) Then
		      Return boolValue( isPackage )
		    Else
		      // At this point, isPackage isa NSError. Do something with it or just assume
		      // that it's not a package.
		      Return False
		    End If
		    
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NameWithoutExtension(extends f as folderitem) As string
		  If f Is Nil Then 
		    Return ""
		  End If
		  
		  Dim parts() As String = Split(f.Name, ".")
		  
		  If parts.ubound = 0 Then
		    Return parts(0)
		  Else
		    parts.remove parts.ubound
		    Return Join(parts,".")
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NSDataToPicture(data as ptr) As Picture
		  #If targetmacOS
		    Declare Function DataLength Lib "Foundation" Selector "length" (obj As ptr) As Integer
		    Declare Sub GetDataBytes Lib "Foundation" Selector "getBytes:length:" (obj As ptr, buff As ptr, Len As Integer)
		    
		    Var dlen As Integer
		    Var mb As MemoryBlock
		    Var mbptr As ptr
		    
		    // Getting image data to generate the Picture object in the Xojo side
		    // We need to get the length of the raw data…
		    dlen = DataLength(data)
		    
		    // …in order to create a memoryblock with the right size
		    mb = New MemoryBlock(dlen)
		    mbPtr = mb
		    
		    // And now we can dump the PNG data from the NSDATA objecto to the memoryblock
		    GetDataBytes(data,mbPtr,dlen)
		    
		    // In order to create a Xojo Picture from it
		    Return Picture.FromData(mb)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  #If DebugBuild
		    
		    Dim Logger As debug.logger = CurrentMethodName
		    
		    #If TargetMacOS
		      Dim f As New folderitem("/Users/npalardy/Desktop/tabpanel.xojo_binary_project", FolderItem.PathTypeNative)
		      
		      Dim s As New Size
		      s.Width = 80
		      s.height = 80
		      Dim p As picture 
		      p = f.IconforFile(s)
		      
		      #Pragma warning "Norm finish !"
		      
		    #EndIf
		    
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VolumeIsInternal(Extends target As FolderItem) As Boolean
		  #If TargetMacOS
		    Soft Declare Function NSClassFromString Lib "AppKit" (classname As CFStringRef) As ptr
		    Soft Declare Function fileURLWithPathIsDirectory Lib "Foundation" Selector "fileURLWithPath:isDirectory:" ( NSURLClass As Ptr, path As CFStringRef, directory As Boolean) As Ptr
		    Soft Declare Function getResourceValue Lib "Foundation" Selector "getResourceValue:forKey:error:" ( URLRef As Ptr, ByRef value As Ptr, key As CFStringRef, ByRef error As Ptr ) As Boolean
		    Soft Declare Function boolValue Lib "Foundation" Selector "boolValue" ( ref As Ptr ) As Boolean // for converting NSNumber boolean to Xojo
		    
		    Dim NSURLClass As Ptr = NSClassFromString( "NSURL" )
		    Dim nativePath As String = target.nativePath
		    Dim myURL      As Ptr = fileURLWithPathIsDirectory( NSURLClass, nativePath, target.directory )
		    
		    Dim error As ptr
		    Dim result As ptr
		    If Not GetResourceValue( myURL, result, "NSURLVolumeIsInternalKey", error ) Then
		      Dim e As New RuntimeException
		      e.Message = "An error occurred!"
		      Raise e
		    End
		    
		    Return boolValue(result)
		    
		  #ElseIf TargetWindows
		    break
		  #EndIf
		End Function
	#tag EndMethod


	#tag Structure, Name = NSOrigin, Flags = &h0
		X as CGFloat
		Y as CGFloat
	#tag EndStructure

	#tag Structure, Name = NSRect, Flags = &h0
		Origin as NSOrigin
		RectSize as NSSize
	#tag EndStructure

	#tag Structure, Name = NSSize, Flags = &h0
		Width as CGFloat
		Height as CGFloat
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
