' AoC 2k25, day 2 pt. 2 in VBScript.
' Question statement:
' First part:
' "Since the young Elf was just doing silly patterns,
' you can find the invalid IDs by looking for any ID
' which is made only of some sequence of digits repeated
' twice. So, 55 (5 twice), 6464 (64 twice), and 123123
' (123 twice) would all be invalid IDs.
' None of the numbers have leading zeroes; 0101 isn't
' an ID at all. (101 is a valid ID that you would ignore.)"
'
' Second part:
' "Now, an ID is invalid if it is made only of some sequence
' of digits repeated at least twice. So, 12341234 (1234 two
' times), 123123123 (123 three times), 1212121212 (12 five
' times), and 1111111 (1 seven times) are all invalid IDs."


Function CheckIfItsRepeated(number)
	Dim LenNumberString
	LenNumberString = Len(number)
	Dim CurPart, PrevPart, Factor, LenPerFactor, _
		c, i, j, ActualEdgeCase
	' We will start from the factor that
	' has the largest quotient, so we iter
	' the least amount of times possible.
	' I won't say that we "save cycles" because,
	' well, I don't know how Mid() is, in fact,
	' implemented.
	' The exeption is Mod 2, since we don't want
	' to make cases where 3 would be optimal slower.
	' Damn, VBS is already slow.
	Select Case 0
		Case (LenNumberString Mod 3)
			Factor = 3
		Case (LenNumberString Mod 5)
			Factor = 5
		Case (LenNumberString Mod 7)
			Factor = 7
		Case (LenNumberString Mod 2)
			Factor = 2
		Case Else
			' Just in case, iter one-per-one.
			' Perhaps I'm paranoic about edge-cases,
			' but we can never know, eh?
			Factor = LenNumberString
	End Select

	LenPerFactor = (LenNumberString / Factor)
	
	For c = 1 To LenNumberString Step LenPerFactor
		CurPart = Mid(number, c, LenPerFactor)
		If (PrevPart = "") Then
			PrevPart = CurPart
		End If
		If (CurPart <> PrevPart) Then
			ActualEdgeCase = False
			' Handle edge cases such as 2121212121,
			' which can't be handled per the old algorithm.
			If ((LenNumberString Mod 2) = 0) Then
				Dim Mod2CurPart, Mod2PrevPart
				For i = 2 To LenPerFactor ' Divided per 2.
					For j = 1 To LenNumberString Step i
						Mod2CurPart = Mid(number, j, i)
						If (Mod2PrevPart = "") Then
							Mod2PrevPart = Mod2CurPart
						End If
						If (Mod2CurPart <> Mod2PrevPart) Then
							ActualEdgeCase = False ' Keep it false.
							Exit For
						End If
						Mod2CurPart = ""
						Mod2PrevPart = ""
						ActualEdgeCase = True ' All good, man.
					Next
				Next
			End If
			' And the pattern has just been broken!
			' This in case of a 11223 type number.
			CheckIfItsRepeated = ActualEdgeCase
			Exit Function
		End If
		PrevPart = CurPart
		CurPart = ""
	Next
	CheckIfItsRepeated = True
End Function

Function IDRangeToArray(IDRange)
	Dim ProductIDRanges(1)
	CurID = 0
	For j = 1 To Len(IDRange)
		IDChr = Mid(IDRange, j, 1)
		If ( IDChr = "-" ) Then
			CurID = CurID + 1 ' expr vibes
		ElseIf ( IDChr <> "-" ) Then
			ProductIDRanges(CurID) = ProductIDRanges(CurID) & IDChr
		End If
	Next
	IDRange = ""
	IDChr = ""
	IDRangeToArray = ProductIDRanges
	Erase ProductIDRanges
End Function

Function ParseProductsIDRanges(line)
	Dim ProductIDRanges, IDRangeList, NIDRangeList, _
		LenLine, i, j, LChr, IDChr, IDRange, CurID
	LenLine = Len(line)
	NIDRangeList = 0
	Set IDRangeList = CreateObject("Scripting.Dictionary")
	For i = 1 To LenLine
		LChr = Mid(line, i, 1)
		If ( LChr <> "," ) Then
			IDRange = IDRange & LChr
			' Handle last value before end of string.
			If ( i = LenLine ) Then
				ProductIDRanges = IDRangeToArray(IDRange)
				IDRangeList.Add NIDRangeList, ProductIDRanges
			End If
		Else
			ProductIDRanges = IDRangeToArray(IDRange)
			IDRangeList.Add NIDRangeList, ProductIDRanges
			NIDRangeList = NIDRangeList + 1
		End If
	Next
	Set ParseProductsIDRanges = IDRangeList
End Function

Const ForReading = 1
Dim inputFile, FileObject, FILE
Dim IDRanges, NIDRanges, IDPair, IsRepeated, _
	RepeatedSum, i, k

inputFile = WScript.Arguments.Item(0)
Set FileObject = CreateObject("Scripting.FileSystemObject")
Set FILE = FileObject.OpenTextFile(inputFile)

' Since it's a single-line, we can just ReadLine() it instead of
' iterating over the file.

l = FILE.ReadLine()
WScript.Echo l

Set IDRanges = ParseProductsIDRanges(l)
NIDRanges = (IDRanges.Count - 1)
WScript.Echo "Number of ID pairs: " & NIDRanges
For i = 0 To NIDRanges
    IDPair = IDRanges(i)
	For k = IDPair(0) To IDPair(1)
		WScript.Echo k
		IsRepeated = CheckIfItsRepeated(CStr(k))
		If ( IsRepeated ) Then
			WScript.Echo "Repetido!"
			RepeatedSum = RepeatedSum + k
		End If
	Next
Next
WScript.Echo "Repetidos: " & RepeatedSum

FILE.Close()
Set FILE = Nothing
Set FileObject = Nothing
