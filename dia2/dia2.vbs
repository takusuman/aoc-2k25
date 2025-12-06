' AoC 2k25, day 2 pt. 1 in VBScript.
' Question statement:
'
'

Function ParseProductsIDRanges(line)
	Dim ProductIDRanges(1), IDRangeList, NIDRangeList, i, j, LChr, IDChr, IDRange, CurID
	NIDRangeList = 0
	Set IDRangeList = CreateObject("Scripting.Dictionary")
	For i = 1 To Len(line)
		LChr = Mid(line, i, 1)
		If ( LChr = "," ) Then
			CurID = 0
			For j = 1 To Len(IDRange)
				IDChr = Mid(IDRange, j, 1)
				If ( IDChr = "-" ) Then
					CurID = CurID + 1 ' expr vibes
				ElseIf ( IDChr <> "-" ) Then
					ProductIDRanges(CurID) = ProductIDRanges(CurID) & IDChr
				End If
			Next
			IDRangeList.Add NIDRangeList, ProductIDRanges
			NIDRangeList = NIDRangeList + 1
			Erase ProductIDRanges
			IDRange = ""
			IDChr = ""
		Else
			IDRange = IDRange & LChr
		End If
	Next
	Set ParseProductsIDRanges = IDRangeList
End Function

Const ForReading = 1
Dim inputFile, FileObject, FILE
Dim result, arr, i, j

inputFile = WScript.Arguments.Item(0)
Set FileObject = CreateObject("Scripting.FileSystemObject")
Set FILE = FileObject.OpenTextFile(inputFile)

' Since it's a single-line, we can just ReadLine() it instead of
' iterating over the file.

l = FILE.ReadLine()

WScript.Echo l

' Debug
Set result = ParseProductsIDRanges(l)

WScript.Echo "Count: " & result.Count

For i = 0 To result.Count - 1
    arr = result(i)
    WScript.Echo "Item " & i & ": "

    For j = 0 To UBound(arr)
        WScript.Echo "  [" & j & "] = " & arr(j)
    Next
Next

FILE.Close()
