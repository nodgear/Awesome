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



;=======================================================================
;            Split a Hex code to indivdual RGB colors
;=======================================================================
SplitRGBColor(RGBColor)
{
  BaseHex := SubStr(RGBColor, 3)

   Red := Format("{:i}", "0x" SubStr(BaseHex, 1,2))
   Green := Format("{:i}", "0x" SubStr(BaseHex, 3,2))
   Blue := Format("{:i}", "0x" SubStr(BaseHex, 5,2))

   Return Red "," Green "," Blue

}


;=======================================================================
;      Get Luminance from RGB Color :) (COULD RETRIEVE HSL TOO)
;=======================================================================
RGB2L(RGBColor)
{
	BaseHex := SubStr(RGBColor, 3)

	R := Format("{:i}", "0x" SubStr(BaseHex, 1,2))
	G := Format("{:i}", "0x" SubStr(BaseHex, 3,2))
	B := Format("{:i}", "0x" SubStr(BaseHex, 5,2))

	var_R := ( R / 255 ) ;                    //RGB from 0 to 255
	var_G := ( G / 255 )
	var_B := ( B / 255 )

	var_Min := min( var_R, var_G, var_B ) 
	var_Max := max( var_R, var_G, var_B )
	del_Max := var_Max - var_Min          

	L := ( var_Max + var_Min ) / 2

	if ( del_Max = 0 )                  
	{
	H := 0                           
	S := 0
	}
	else                                
	{
	if ( L < 0.5 )
			S := del_Max / ( var_Max + var_Min )
	else           
			S := del_Max / ( 2 - var_Max - var_Min )
	; I HAVE NO FUCKING IDEA, FOUND THE FORMULA ON WIKIPEDIA :)
	del_R := ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
	del_G := ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
	del_B := ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max

	if      ( var_R = var_Max ) 
			H := del_B - del_G
	else
	{
			if ( var_G = var_Max ) 
				H := ( 1 / 3 ) + del_R - del_B
			else 
			{
				if ( var_B = var_Max ) 
					H := ( 2 / 3 ) + del_G - del_R
			}
		}

	if ( H < 0 ) 
			H += 1
	if ( H > 1 ) 
			H -= 1
	}
	; HSL := H . "|" . S . "|" . L
	return L
}

min(A, B, C)
{
	if (A <= B) && (A <= C)
		return A
	if (B <= A) && (B <= C)
		return B
	if (C <= A) && (C <= B)
		return C
}

max(A, B, C)
{
	if (A >= B) && (A >= C)
		return A
	if (B >= A) && (B >= C)
		return B
	if (C >= A) && (C >= B)
		return C
}