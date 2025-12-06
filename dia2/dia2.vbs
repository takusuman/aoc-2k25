' AoC 2k25, day 2 pt. 1 in VBScript.
' Question statement:
'
'

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
Dim IDRanges, IDPair, i, j, k

inputFile = WScript.Arguments.Item(0)
Set FileObject = CreateObject("Scripting.FileSystemObject")
Set FILE = FileObject.OpenTextFile(inputFile)

' Since it's a single-line, we can just ReadLine() it instead of
' iterating over the file.

l = FILE.ReadLine()

WScript.Echo l

' Debug
Set IDRanges = ParseProductsIDRanges(l)
WScript.Echo "Number of ID pairs: " & IDRanges.Count

For i = 0 To (IDRanges.Count - 1)
    IDPair = IDRanges(i)
    WScript.Echo "Item " & i & ": "

    For j = 0 To UBound(IDPair)
        WScript.Echo "  [" & j & "] = " & IDPair(j)
    Next
	
	For k = IDPair(0) To IDPair(1)
		WScript.Echo k
	Next
Next

FILE.Close()
