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

Function ParseProductsIDRanges(line)
	Dim ProductIDRanges, IDRange, IDRangeList, CrudeIDRanges, i
	CrudeIDRanges = Split(line, ",")
	IDRangeList = Array()
	For i = 0 To UBound(CrudeIDRanges)
		ReDim Preserve IDRangeList(UBound(IDRangeList) + 1)
		IDRange = CrudeIDRanges(i)
		ProductIDRanges	= Split(IDRange, "-")
		WScript.Echo ProductIDRanges(0), ProductIDRanges(1)
		IDRangeList(UBound(IDRangeList)) = ProductIDRanges
		IDRange = ""
	Next
	ParseProductsIDRanges = IDRangeList
End Function

Function CheckIfItsRepeated(number)
	Dim CurPart, PrevPart, Factor, _
		LenNumberString, LenPerFactor, c
	LenNumberString = Len(number)

	' For single-digit numbers. Yes, this was necessary.
	If (LenNumberString = 1) Then
		CheckIfItsRepeated = False
		Exit Function
	End If

	' We will start from the factor that
	' has the largest quotient, so we iter
	' the least amount of times possible.
	' I won't say that we "save cycles" because,
	' well, I don't know how Mid() is, in fact,
	' implemented.
	Select Case 0
		Case (LenNumberString Mod 3)
			Factor = 3
		Case (LenNumberString Mod 5)
			Factor = 5
		Case (LenNumberString Mod 7)
			Factor = 7
		Case Else
			' Just in case, iter one-per-one.
			' Perhaps I'm paranoic about edge-cases,
			' but we can never know, eh?
			' Don't be preoccupied, we'll be handling
			' the Mod 2 below for sure.
			Factor = LenNumberString
	End Select

	LenPerFactor = (LenNumberString / Factor)
	For c = 1 To LenNumberString Step LenPerFactor
		CurPart = Mid(number, c, LenPerFactor)
		If (PrevPart = "") Then
			PrevPart = CurPart
		End If
		If (CurPart <> PrevPart) Then
			If ((LenNumberString Mod 2) = 0) Then
				Dim FstPart, SndPart
				Factor = 2
				LenPerFactor = (LenNumberString / Factor)
				FstPart = Mid(number, 1, LenPerFactor)
				SndPart = Mid(number, (LenPerFactor + 1), LenNumberString)
				If (FstPart = SndPart) Then
					CheckIfItsRepeated = True
					Exit Function
				Else
					Dim FstElem, k
					' Handle edge cases such as 2121212121, which
					' is 5 times a two-digit number, which can't
					' be handled per the old algorithm.
					Select Case LenPerFactor
						Case 5
							Factor = 2
						Case Else
							Factor = 1
					End Select
					FstElem = Mid(number, 1, Factor)
					For k = (Factor + 1) To Len(number) Step Factor
						If (FstElem <> Mid(number, k, Factor)) Then
							CheckIfItsRepeated = False
							Exit Function
						End If
					Next
				End If
			End If
			' And the pattern has just been broken!
			' This in case of a 11223 type number.
			CheckIfItsRepeated = False
			Exit Function
		End If
		PrevPart = CurPart
		CurPart = ""
	Next
	CheckIfItsRepeated = True
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

IDRanges = ParseProductsIDRanges(l)

NIDRanges = (UBound(IDRanges))
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