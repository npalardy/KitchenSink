#tag Module
Protected Module HiDPIImage
	#tag Method, Flags = &h1
		Protected Function ImageFromResources(imageName as string) As Picture
		  // currently assumes you pass in JUST the base name (no extension no @1x @2x etc)
		  
		  // to do
		  //     eventually if imagename is a path (ie/ macOS/subfoldername/imagename) we load that
		  
		  Dim resourcesFolder As FolderItem = SpecialFolder.Resources
		  If resourcesFolder Is Nil Then
		    Dim tmp As New NilObjectException
		    tmp.message = "Resources folder is nil or not readable"
		    Raise tmp
		  End If
		  
		  Dim image1xFile As folderitem = resourcesFolder.child(imageName+".png")
		  Dim image2xFile As folderitem = resourcesFolder.child(imageName+"@2x.png")
		  Dim image3xFile As folderitem = resourcesFolder.child(imageName+"@3x.png")
		  
		  Dim images() As picture
		  If image1xFile <> Nil And image1xFile.exists Then
		    images.Append picture.Open(image1xfile)
		  end if
		  
		  If image2xFile <> Nil And image2xFile.exists Then
		    images.Append picture.Open(image2xfile)
		  End If
		  
		  If image3xFile <> Nil And image3xFile.exists Then
		    images.Append picture.Open(image3xfile)
		  End If
		  
		  // remove any nil pictures
		  For i As Integer = images.ubound DownTo 0
		    If images(i) Is Nil then
		      images.remove i
		    End If
		  Next
		  
		  If images.ubound < 0 Then
		    Return Nil
		  End If
		  
		  Dim width As Integer = images(0).Width
		  Dim height As Integer = images(0).height
		  
		  Return New Picture(width, height, images)
		  
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
