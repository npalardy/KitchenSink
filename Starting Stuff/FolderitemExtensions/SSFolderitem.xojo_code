#tag Class
Protected Class SSFolderitem
Inherits FolderItem
	#tag CompatibilityFlags = not TargetWeb
	#tag Method, Flags = &h1000
		Sub constructor()
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From FolderItem
		  // Constructor(source As FolderItem) -- From FolderItem
		  // Constructor(Path As String, pathMode As Integer = 0) -- From FolderItem
		  Super.Constructor
		  
		  Declare Function CFURLCreateWithFileSystemPath Lib "CoreFoundation.Framework" (allocator as ptr, filePath as cfstringref, pathStyle as integer, isDirectory as Boolean) As ptr
		  
		  if me.CFURL=nil then me.CFURL=CFURLCreateWithFileSystemPath(nil,me.NativePath,0,me.Directory)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub constructor(source As FolderItem,SecurityScoped as Boolean=true)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From FolderItem
		  // Constructor(source As FolderItem) -- From FolderItem
		  // Constructor(Path As String, pathMode As Integer = 0) -- From FolderItem
		  Super.Constructor(source)
		  
		  Declare Function CFURLCreateWithFileSystemPath Lib "CoreFoundation.Framework" (allocator as ptr, filePath as cfstringref, pathStyle as integer, isDirectory as Boolean) As ptr
		  
		  if me.CFURL=nil then me.CFURL=CFURLCreateWithFileSystemPath(nil,me.NativePath,0,me.Directory)
		  me.SecurityScoped=SecurityScoped
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(source As SSFolderitem)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From FolderItem
		  // Constructor(source As FolderItem) -- From FolderItem
		  // Constructor(Path As String, pathMode As Integer = 0) -- From FolderItem
		  if source<>nil then 
		    Super.Constructor(source)
		    me.CFURL=source.CFURL
		  else
		    super.Constructor
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(bookmark As String,SecurityScoped As Boolean=true)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From FolderItem
		  // Constructor(source As FolderItem) -- From FolderItem
		  // Constructor(Path As String, pathMode As Integer = 0) -- From FolderItem
		  Super.Constructor
		  me.SecurityScoped=SecurityScoped
		  me.Bookmark=bookmark
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(Path As String, pathMode As Integer)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From FolderItem
		  // Constructor(source As FolderItem) -- From FolderItem
		  // Constructor(Path As String, pathMode As Integer = 0) -- From FolderItem
		  Super.Constructor(path,pathMode)
		  
		  Declare Function CFURLCreateWithFileSystemPath Lib "CoreFoundation.Framework" (allocator as ptr, filePath as cfstringref, pathStyle as integer, isDirectory as Boolean) As ptr
		  
		  if me.CFURL=nil then me.CFURL=CFURLCreateWithFileSystemPath(nil,me.NativePath,0,me.Directory)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  #if TargetMacOS
		    Declare sub CFRelease lib "CoreFoundation.Framework" (obj as ptr)
		    if CFURL<>nil then CFRelease(CFURL)
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FromBookmark(Bookmark As MemoryBlock) As SSFolderitem
		  #if TargetMacOS
		    dim isStale as Boolean
		    dim err as ptr
		    dim flags As integer
		    const kResolutionWithSecurityScope=1024
		    Declare Function CFDataCreate Lib "CoreFoundation.Framework" (allocator as ptr, bytes as ptr, length As Integer) As ptr
		    Declare Function CFURLCreateByResolvingBookmarkData Lib "CoreFoundation.Framework" (allocator as ptr, bookmark as ptr, options as integer, relativeToURL as ptr, resourcePropertiesToInclude as ptr, byref isStale as Boolean, byref error as ptr) As ptr
		    Declare Function CFURLCopyFileSystemPath Lib "CoreFoundation.Framework" (anURL as ptr, pathStyle as Integer) As CFStringRef
		    Declare Function CFErrorCopyFailureReason Lib "CoreFoundation.Framework" (err as ptr) As CFStringRef
		    Declare Sub CFRelease Lib "CoreFoundation.Framework" (obj as ptr)
		    Declare Sub CFRetain Lib "CoreFoundation.Framework" (obj as ptr)
		    dim options as integer
		    if SecurityScoped then options= kResolutionWithSecurityScope
		    
		    
		    dim bmd As ptr=CFDataCreate(nil,Bookmark,Bookmark.Size)
		    dim cfu As ptr=CFURLCreateByResolvingBookmarkData(nil,bmd, options, nil, nil, isStale,err)
		    if err<>nil then MsgBox CFErrorCopyFailureReason(err)
		    if cfu=nil then Return nil
		    CFRelease(bmd)
		    CFRetain(cfu)
		    dim f As new SSFolderItem(GetFolderItem(CFURLCopyFileSystemPath(cfu,0),FolderItem.PathTypeNative))
		    if f.CFURL<>nil then CFRelease(f.CFURL)
		    f.CFURL=cfu
		    
		    Return f
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StartAccess() As Boolean
		  #if TargetMacOS
		    Declare Function CFURLStartAccessingSecurityScopedResource Lib "CoreFoundation.Framework" (url as ptr) As Boolean
		    if me.CFURL=nil then 
		      MsgBox "no cfurl"
		      Return False
		    end if
		    Return CFURLStartAccessingSecurityScopedResource(me.CFURL)
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopAccess()
		  #if TargetMacOS
		    Declare Sub CFURLStopAccessingSecurityScopedResource Lib "CoreFoundation.Framework" (url as ptr)
		    if CFURL=nil then Return
		    CFURLStopAccessingSecurityScopedResource(me.CFURL)
		  #endif
		  
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = From PiDog
		
		https://www.pidog.com/share/SSBookmarks.zip
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetMacOS
			    const kCFURLBookmarkCreationWithSecurityScope =2048
			    const kCreationMinimalBookmarkMask=512
			    const kCFURLBookmarkCreationPreferFileIDResolutionMask=256
			    Declare Sub CFRelease Lib "CoreFoundation.Framework" (obj as ptr)
			    Declare Sub CFDataGetBytes Lib "CoreFoundation.Framework" (theData as ptr, range as CFRange,  buffer As ptr)
			    Declare Function CFDataGetBytePtr Lib "CoreFoundation.Framework" (theData as ptr) As INTEGER
			    Declare Function CFDataGetLength Lib "CoreFoundation.Framework" (theData as ptr) As integer
			    Declare Function CFURLCreateBookmarkData Lib "CoreFoundation.Framework" (allocator as ptr, URL as ptr,options as integer, props as ptr, baseURL as ptr, byref errorRef as ptr) As ptr
			    Declare Function CFURLCreateWithFileSystemPath Lib "CoreFoundation.Framework" (allocator as ptr, filePath as cfstringref, pathStyle as integer, isDirectory as Boolean) As ptr
			    
			    if me.CFURL=nil then me.CFURL=CFURLCreateWithFileSystemPath(nil,me.NativePath,0,me.Directory)
			    
			    dim options as integer
			    if SecurityScoped then options=kCFURLBookmarkCreationWithSecurityScope+kCFURLBookmarkCreationPreferFileIDResolutionMask
			    
			    dim err As ptr
			    dim data As ptr=CFURLCreateBookmarkData(nil,me.CFURL, options,nil,nil,err)
			    if data=nil then Return ""
			    dim res As new MemoryBlock(CFDataGetLength(data))
			    dim range As CFRange
			    range.Length=CFDataGetLength(data)
			    CFDataGetBytes(data,range,res)
			    CFRelease(data)
			    Return  res.StringValue(0,res.Size)
			  #endif
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #if TargetMacOS
			    Declare Sub CFRelease Lib "CoreFoundation.Framework" (obj as ptr)
			    if me.CFURL<>nil then CFRelease (me.CFURL)
			    me.Constructor(me.FromBookmark(value))
			  #endif
			End Set
		#tag EndSetter
		Bookmark As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private CFURL As ptr
	#tag EndProperty

	#tag Property, Flags = &h0
		SecurityScoped As Boolean = true
	#tag EndProperty


	#tag Structure, Name = CFRange, Flags = &h0, Attributes = \"StructureAlignment \x3D 1"
		Start as int32
		Length as int32
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsFolder"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Uint64"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsAlias"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DisplayName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Exists"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ExtensionVisible"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Group"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="IsReadable"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsWriteable"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="Locked"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="Owner"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShellPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="URLPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NativePath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bookmark"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SecurityScoped"
			Visible=false
			Group="Behavior"
			InitialValue="true"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
