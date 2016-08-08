SuperStrict

Framework ODD.GLOdd2D
?Win32
Import ODD.D3D9Odd2D
Import ODD.D3D7Odd2D
?
Import brl.random

SetGraphicsDriver GLOdd2DDriver()
'Uncomment a driver to try it (Windows only)
'SetGraphicsDriver D3D9Odd2DDriver()
'SetGraphicsDriver D3D7Odd2DDriver()

Graphics 800,600
SetVirtualResolution 400,300
SetClsColor 127,127,127

Local dw:Int=DesktopWidth()-50,dh:Int=DesktopHeight()-50
Local x:Float,y:Float,rot:Float,zoom:Float=1

Repeat
	
	SeedRnd MilliSecs()
	
	If KeyDown(KEY_LEFT) Then rot:-5
	If KeyDown(KEY_RIGHT) Then rot:+5
	If KeyDown(KEY_UP)
		x:+Cos(rot)*10
		y:+Sin(rot)*10
	EndIf
	
	If KeyHit(KEY_1) Then SetBorderMode BORDER_NONE
	If KeyHit(KEY_2) Then SetBorderMode BORDER_LETTERBOX_FILL
	If KeyHit(KEY_3) Then SetBorderMode BORDER_LETTERBOX_SOLID
	If KeyHit(KEY_4) Then SetBorderMode BORDER_BESTFIT_FILL
	If KeyHit(KEY_5) Then SetBorderMode BORDER_BESTFIT_SOLID
	
	If KeyHit(KEY_B) Then SetBorderColor Rand(0,255),Rand(0,255),Rand(0,255)
	
	If KeyHit(KEY_G)
		Graphics Rand(400,dw),Rand(300,dh)
		SetVirtualResolution 400,300
		SetClsColor 127,127,127
	EndIf
	
	If KeyHit(KEY_EQUALS) Then zoom:+.1
	If KeyHit(KEY_MINUS) Then zoom:-.1
	
	Cls
	SetScreenRotation rot+90
	SetOrigin -x,-y
	SetRotation 0
	SetScreenFocus 200,250
	SetZoom zoom
	
	Local mx:Float, my:Float
	OddMouse mx,my
	mx=10.0/0.0
	
	SeedRnd 0
	For Local count:Int=0 To 10
		SetColor Rand(0,255),Rand(0,255),Rand(0,255)
		DrawPoly([Float(Rnd(-400,400)),Float(Rnd(-400,400)),Float(Rnd(-400,400)),Float(Rnd(-400,400)),Float(Rnd(-400,400)),Float(Rnd(-400,400))])
	Next
	
	SetColor 255,0,0
	SetRotation rot+90
	DrawText "'-Focus",x,y
	
	SetScreenRotation 0
	SetScreenFocus 0,0
	SetZoom 1
	SetOrigin 0,0
	SetRotation 0
	
	DrawText "[1] Border mode NONE",5,5
	DrawText "[2] Border mode LETTERBOX FILL",5,20
	DrawText "[3] Border mode LETTERBOX SOLID",5,35
	DrawText "[4] Border mode BESTFIT FILL",5,50
	DrawText "[5] Border mode BESTFIT SOLID",5,65
	DrawText "[B] Random border color",5,80
	DrawText "[G] Random window size",5,95
	DrawText "[+/-] Zoom in/out",5,110
	DrawText "[Cursor keys] Rotate/scroll display",5,125
	
	Flip
	
Until KeyHit(KEY_ESCAPE) Or AppTerminate()

EndGraphics

End