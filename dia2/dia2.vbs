' AoC 2k25, day 2 pt. 1 in VBScript.
' Question statement:
' "Since the young Elf was just doing silly patterns,
' you can find the invalid IDs by looking for any ID
' which is made only of some sequence of digits repeated
' twice. So, 55 (5 twice), 6464 (64 twice), and 123123
' (123 twice) would all be invalid IDs.
' None of the numbers have leading zeroes; 0101 isn't
' an ID at all. (101 is a valid ID that you would ignore.)"
' Personal taks' note: Where could 0101 be a case? Hmmm...

Function CheckIfItsRepeated(number)
	Dim LenNumberString, FstPart, SndPart
	LenNumberString = Len(number)
	If (Not ((LenNumberString Mod 2) = 0)) Then
		CheckIfItsRepeated = False
		Exit Function
	End If
	FstPart = Mid(number, 1, (LenNumberString/2))
	SndPart = Mid(number, ((LenNumberString/2) + 1), LenNumberString)
	If ( FstPart = SndPart ) Then
		CheckIfItsRepeated = True
	End If
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
