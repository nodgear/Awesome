OnExit("ExitFunc")

Gdip_Startup()
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	pToken := 0

	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}

Gdip_Shutdown(pToken)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)
	return 0
}

If !pToken := Gdip_Startup()
{
	MsgBox "Gdiplus failed to start. Please ensure you have gdiplus on your system"
	ExitApp
}

ExitFunc()
{
   global pToken
   Gdip_Shutdown(pToken)
}

Gdip_CreateBitmapFromHICON(hIcon)
{
	pBitmap := ""
	DllCall("gdiplus\GdipCreateBitmapFromHICON", A_PtrSize ? "UPtr" : "UInt", hIcon, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}

Gdip_GetPixels(pBitmap, size:=16)
{
	ARGB := 0
	x:=0
	pixelString := ""
	while x < size
	{
		y:=0
		while y < size
		{
			DllCall("gdiplus\GdipBitmapGetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "uint*", ARGB)
			y+=1
			if(ARGB)
			{
				pixelString := pixelString . ARGB
			}
		}
		x+=1
	}
	return pixelString
}

SaveHICONtoRainmeter(hicon, iconFile, icoMD5)
{
	workFile := EnvGet("TMP") "\wwing\" icoMD5 ".ico"
	;FileDelete iconFile
	SaveHICONtoFile( hicon, workFile )

	while(!FileExist(workFile))
	{
		Sleep 10
	}

	renderSystrayIconTheme(workFile,iconFile)
}

SaveHICONtoFile( hicon, iconFile ) ; By SKAN | 06-Sep-2017 | goo.gl/8NqmgJ
{                                
	Static CI_FLAGS:=0x2008                                             ; LR_CREATEDIBSECTION | LR_COPYDELETEORG
	Local  File, Var, mDC, sizeofRGBQUAD, ICONINFO:=[], BITMAP:=[], BITMAPINFOHEADER:=[]

	File := FileOpen( iconFile,"rw" )
	If ( ! IsObject(File) )
	{
		Return 0
	}
	Else File.Length := 0                                             ; Delete (any existing) file contents                                                   
	
	VarSetCapacity(Var,32,0)                                      ; ICONINFO Structure
	If ! DllCall( "GetIconInfo", "Ptr",hicon, "Ptr",&Var )
		Return ( File.Close() >> 64 , 0)

	ICONINFO.fIcon      := NumGet(Var, 0,"UInt")
	ICONINFO.xHotspot   := NumGet(Var, 4,"UInt")
	ICONINFO.yHotspot   := NumGet(Var, 8,"UInt")
	ICONINFO.hbmMask    := NumGet(Var, A_PtrSize=8 ? 16:12, "UPtr")
	ICONINFO.hbmMask    := DllCall( "CopyImage"                       ; Create a DIBSECTION for hbmMask
									, "Ptr",ICONINFO.hbmMask 
									, "UInt",0                          ; IMAGE_BITMAP
									, "Int",0, "Int",0, "UInt",CI_FLAGS, "Ptr" ) 
	ICONINFO.hbmColor   := NumGet(Var, A_PtrSize=8 ? 24:16, "UPtr") 
	ICONINFO.hbmColor   := DllCall( "CopyImage"                       ; Create a DIBSECTION for hbmColor
									, "Ptr",ICONINFO.hbmColor
									, "UInt",0                          ; IMAGE_BITMAP
									, "Int",0, "Int",0, "UInt",CI_FLAGS, "Ptr" ) 

	VarSetCapacity(Var,A_PtrSize=8 ? 104:84,0)                        ; DIBSECTION of hbmColor
	DllCall( "GetObject", "Ptr",ICONINFO.hbmColor, "Int",A_PtrSize=8 ? 104:84, "Ptr",&Var )

	BITMAP.bmType       := NumGet(Var, 0,"UInt") 
	BITMAP.bmWidth      := NumGet(Var, 4,"UInt")
	BITMAP.bmHeight     := NumGet(Var, 8,"UInt")
	BITMAP.bmWidthBytes := NumGet(Var,12,"UInt")
	BITMAP.bmPlanes     := NumGet(Var,16,"UShort")
	BITMAP.bmBitsPixel  := NumGet(Var,18,"UShort")
	BITMAP.bmBits       := NumGet(Var,A_PtrSize=8 ? 24:20,"Ptr")
	
	BITMAPINFOHEADER.biClrUsed := NumGet(Var,32+(A_PtrSize=8 ? 32:24),"UInt")
																		
	File.WriteUINT(0x00010000)                                        ; ICONDIR.idReserved and ICONDIR.idType 
	File.WriteUSHORT(1)                                               ; ICONDIR.idCount (No. of images)
	File.WriteUCHAR(BITMAP.bmWidth  < 256 ? BITMAP.bmWidth  : 0)      ; ICONDIRENTRY.bWidth
	File.WriteUCHAR(BITMAP.bmHeight < 256 ? BITMAP.bmHeight : 0)      ; ICONDIRENTRY.bHeight 
	File.WriteUCHAR(BITMAPINFOHEADER.biClrUsed < 256                  ; ICONDIRENTRY.bColorCount
					? BITMAPINFOHEADER.biClrUsed : 0)
	File.WriteUCHAR(0)                                                ; ICONDIRENTRY.bReserved
	File.WriteUShort(BITMAP.bmPlanes)                                 ; ICONDIRENTRY.wPlanes
	File.WriteUSHORT(BITMAP.bmBitsPixel)                              ; ICONDIRENTRY.wBitCount
	File.WriteUINT(0)                                                 ; ICONDIRENTRY.dwBytesInRes (filled later) 
	File.WriteUINT(22)                                                ; ICONDIRENTRY.dwImageOffset  


	NumPut( BITMAP.bmHeight*2, Var, 8+(A_PtrSize=8 ? 32:24),"UInt")   ; BITMAPINFOHEADER.biHeight should be 
																		; modified to double the BITMAP.bmHeight  

	File.RawWrite( &Var + (A_PtrSize=8 ? 32:24), 40)                  ; Writing BITMAPINFOHEADER (40  bytes)               
	File.RawWrite(BITMAP.bmBits, BITMAP.bmWidthBytes*BITMAP.bmHeight) ; Writing BITMAP bits (hbmColor)

	VarSetCapacity(Var,A_PtrSize=8 ? 104:84,0)                        ; DIBSECTION of hbmMask
	DllCall( "GetObject", "Ptr",ICONINFO.hbmMask, "Int",A_PtrSize=8 ? 104:84, "Ptr",&Var )

	BITMAP := []
	BITMAP.bmHeight     := NumGet(Var, 8,"UInt")
	BITMAP.bmWidthBytes := NumGet(Var,12,"UInt")
	BITMAP.bmBits       := NumGet(Var,A_PtrSize=8 ? 24:20,"Ptr")

	File.RawWrite(BITMAP.bmBits, BITMAP.bmWidthBytes*BITMAP.bmHeight) ; Writing BITMAP bits (hbmMask)
	File.Seek(14,0)                                                   ; Seeking ICONDIRENTRY.dwBytesInRes
	File.WriteUINT(File.Length()-22)                                  ; Updating ICONDIRENTRY.dwBytesInRes
	File.Close()
	DllCall( "DeleteObject", "Ptr",ICONINFO.hbmMask  )  
	DllCall( "DeleteObject", "Ptr",ICONINFO.hbmColor )
	Return True
}

extractIconFromExe(FileName)
{
	ptr := A_PtrSize =8 ? "ptr" : "uint" 
	hIcon := DllCall("Shell32\ExtractAssociatedIcon" (A_IsUnicode ? "W" : "A"), ptr, DllCall("GetModuleHandle", ptr, 0, ptr), str, FileName, "ushort*", lpiIcon, ptr)   ;only supports 32x32

	return hIcon
}


;=======================================================================
;            Split a Hex code to indivdual RGB colors
;=======================================================================
SplitRGBColor(RGBColor)
{
  BaseHex := SubStr(RGBColor, 3)

   Red := Format("{:i}", "0x" SubStr(BaseHex, 1,2))
   Green := Format("{:i}", "0x" SubStr(BaseHex, 3,2))
   Blue := Format("{:i}", "0x" SubStr(BaseHex, 5,2))

   Return Red "," Green "," Blue ",255"

}