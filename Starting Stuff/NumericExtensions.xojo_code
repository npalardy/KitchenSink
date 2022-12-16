#tag Module
Protected Module NumericExtensions
	#tag Method, Flags = &h1
		Protected Function CurrencyFromBinary(binaryString as string) As Currency
		  Dim mb As New MemoryBlock(8)
		  mb.LittleEndian = False
		  If Left(binaryString,2) <> "&b" Then
		    binaryString = "&b" + binaryString
		  End If
		  mb.Uint64Value(0) = val(binaryString)
		  
		  Return mb.CurrencyValue(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CurrencyFromHex(hexString as string) As Currency
		  Dim mb As New MemoryBlock(8)
		  mb.LittleEndian = False
		  If Left(hexString,2) <> "&h" Then
		    hexString = "&h" + hexString
		  End If
		  mb.Uint64Value(0) = Val(hexString)
		  
		  Return mb.CurrencyValue(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CurrencyFromOctal(octalString as string) As Currency
		  Dim mb As New MemoryBlock(8)
		  mb.LittleEndian = False
		  If Left(octalString,2) <> "&o" Then
		    octalString = "&o" + octalString
		  End If
		  mb.Uint64Value(0) = Val(octalString)
		  
		  Return mb.CurrencyValue(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends currencyValue as Currency) As string
		  Dim mb As New MemoryBlock(8)
		  mb.LittleEndian = False
		  mb.CurrencyValue(0) = currencyValue
		  Dim ui64 As UInt64 = mb.UInt64Value(0)
		  
		  Return Right("0000000000000000000000000000000000000000000000000000000000000000" + ui64.ToBinary, 64)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends doubleValue as Double) As string
		  Dim mb As New MemoryBlock(8)
		  mb.LittleEndian = false
		  mb.DoubleValue(0) = doubleValue
		  Dim ui64 As UInt64 = mb.UInt64Value(0)
		  
		  Return Right("0000000000000000000000000000000000000000000000000000000000000000" + ui64.ToBinary, 64)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends i16 as int16) As string
		  Return Right("0000000000000000" + i16.ToBinary, 16)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends i32 as int32) As string
		  Return Right("00000000000000000000000000000000" + i32.ToBinary, 32)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends i64 as int64) As string
		  Return Right("0000000000000000000000000000000000000000000000000000000000000000" + i64.ToBinary, 64)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends i8 as int8) As string
		  Return Right("00000000" + i8.ToBinary, 8)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends singleValue as Single) As string
		  Dim mb As New MemoryBlock(4)
		  mb.LittleEndian = false
		  mb.SingleValue(0) = singlevalue
		  Dim ui32 As UInt32 = mb.UInt32Value(0)
		  
		  Return Right("00000000000000000000000000000000" + ui32.ToBinary, 32)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends i16 as Uint16) As string
		  Return Right("0000000000000000" + i16.ToBinary, 16)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends i32 as Uint32) As string
		  Return Right("00000000000000000000000000000000" + i32.ToBinary, 32)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends i64 as Uint64) As string
		  Return Right("0000000000000000000000000000000000000000000000000000000000000000" + i64.ToBinary, 64)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToBinary(extends i8 as Uint8) As string
		  Return Right("00000000" + i8.ToBinary, 8)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends currencyValue as Currency) As string
		  Dim mb As New MemoryBlock(8)
		  mb.CurrencyValue(0) = currencyValue
		  Dim ui64 As UInt64 = mb.UInt64Value(0)
		  
		  Return Right("0000000000000000" + ui64.toHex, 16)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends doubleValue as Double) As string
		  Dim mb As New MemoryBlock(8)
		  mb.DoubleValue(0) = doubleValue
		  Dim ui64 As UInt64 = mb.UInt64Value(0)
		  
		  Return Right("0000000000000000" + ui64.toHex, 16)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends i16 as int16) As string
		  Return Right("0000" + i16.toHex, 4)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends i32 as int32) As string
		  Return Right("00000000" + i32.toHex, 8)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends i64 as int64) As string
		  Return Right("0000000000000000" + i64.toHex, 16)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends i8 as int8) As string
		  Return Right("00" + i8.toHex, 2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends singleValue as Single) As string
		  Dim mb As New MemoryBlock(4)
		  mb.SingleValue(0) = singleValue
		  Dim ui32 As UInt32 = mb.UInt32Value(0)
		  
		  Return Right("00000000" + ui32.toHex, 8)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends i16 as Uint16) As string
		  Return Right("0000" + i16.toHex, 4)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends i32 as Uint32) As string
		  Return Right("00000000" + i32.toHex, 8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends i64 as Uint64) As string
		  Return Right("0000000000000000" + i64.toHex, 16)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToHex(extends i8 as Uint8) As string
		  Return Right("00" + i8.toHex, 2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends currencyValue as Currency) As string
		  Dim mb As New MemoryBlock(8)
		  mb.currencyValue(0) = currencyValue
		  Dim ui64 As UInt64 = mb.UInt64Value(0)
		  
		  Return Right("0000000000000000000000" + ui64.toOctal, 22)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends doubleValue as Double) As string
		  Dim mb As New MemoryBlock(8)
		  mb.DoubleValue(0) = doubleValue
		  Dim ui64 As UInt64 = mb.UInt64Value(0)
		  
		  Return Right("0000000000000000000000" + ui64.toOctal, 22)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends i16 as int16) As string
		  Return Right("000000" + i16.toOctal, 6)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends i32 as int32) As string
		  Return Right("00000000000" + i32.toOctal, 11)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends i64 as int64) As string
		  Return Right("0000000000000000000000" + i64.toOctal, 22)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends i8 as int8) As string
		  Return Right("000" + i8.toOctal, 3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends singleValue as Single) As string
		  Dim mb As New MemoryBlock(4)
		  mb.SingleValue(0) = singleValue
		  Dim ui32 As UInt32 = mb.UInt32Value(0)
		  
		  Return Right("00000000000" + ui32.toOctal, 11)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends i16 as Uint16) As string
		  Return Right("000000" + i16.toOctal, 6)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends i32 as Uint32) As string
		  Return Right("00000000000" + i32.toOctal, 11)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends i64 as Uint64) As string
		  Return Right("0000000000000000000000" + i64.toOctal, 22)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProperToOctal(extends i8 as Uint8) As string
		  Return Right("000" + i8.toOctal, 3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunUnitTests()
		  Dim Logger As debug.logger = CurrentMethodName
		End Sub
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
