Strict

Rem
bbdoc: Graphics/OpenGL Odd2D
about:
The OpenGL Odd2D module provides an OpenGL driver for #Odd2D.
End Rem
Module ODD.GLOdd2D

ModuleInfo "Version: 1.03"
ModuleInfo "Author: David Williamson"
ModuleInfo "License: Public Domain"

Import ODD.Odd2D
Import BRL.GLMax2D

Private

Global _driver:TGLOdd2DDriver

Public

Type TOGLImageFrame Extends TImageFrame
	Field glif:TGLImageFrame
	
	Method Draw( x0#,y0#,x1#,y1#,tx#,ty#,sx#,sy#,sw#,sh# )
		Local rot:Float=GetRotation()
		Local sclx:Float,scly:Float
		GetScale sclx,scly
		SetRotation rot-_odd2dDriver.tform_scr_rot
		SetScale sclx*_odd2dDriver.tform_scr_zoom,scly*_odd2dDriver.tform_scr_zoom
		_odd2dDriver.TransformPoint tx,ty
		tx:+_odd2dDriver.focus_x+_odd2dDriver.border_x
		ty:+_odd2dDriver.focus_y+_odd2dDriver.border_y
		
		glif.Draw x0,y0,x1,y1,tx,ty,sx,sy,sw,sh
		
		SetRotation rot
		SetScale sclx,scly
	End Method
	
	Method DrawPoly( xyuv:Float[],handle_x:Float,handle_y:Float,origin_x:Float,origin_y:Float )
		If xyuv.length<12 Or (xyuv.length Mod 4<>0) Return
		
		Local x:Float, y:Float, u:Float, v:Float
		
		glif.Draw 0,0,0,0,0,0,0,0,0,0	'KLUDGE - Note to Mr. Sibly please make EnableTex public
		glBegin GL_POLYGON
		For Local i:Int=0 Until xyuv.length Step 4
			x=xyuv[i+0]-handle_x
			y=xyuv[i+1]-handle_y
			u=xyuv[i+2]*glif.uscale
			v=xyuv[i+3]*glif.vscale
			
			glTexCoord2f u,v
			glVertex2f x*_driver.m2d_ix+y*_driver.m2d_iy+origin_x,x*_driver.m2d_jx+y*_driver.m2d_jy+origin_y
		Next
		glEnd
	End Method
		
	Function CreateFromPixmap:TOGLImageFrame( pixmap:TPixmap,flags:Int )
		Local frame:TOGLImageFrame=New TOGLImageFrame
		frame.glif=TGLImageFrame(GLMax2DDriver().CreateFrameFromPixmap(pixmap,flags))
		Return frame
	End Function
End Type

Type TGLOdd2DDriver Extends TOdd2DDriver
	
	Method Create:TGLOdd2DDriver()
		_m2ddriver=GLMax2DDriver()
		
		InitFields
		
		If Not _m2ddriver Then Return Null Else Return Self
	End Method
	
'	Method GraphicsModes:TGraphicsMode[]() Abstract
	
	Method AttachGraphics:TMax2DGraphics( widget:Byte Ptr, flags:Int )
		Local g:TGLGraphics=GLGraphicsDriver().AttachGraphics( widget,flags )
		If g Return TMax2DGraphics.Create( g,Self )
	End Method
	
	Method CreateGraphics:TGraphics( width:Int, height:Int ,depth:Int, hertz:Int, flags:Int, x:Int, y:Int )
		Local g:TGLGraphics=GLGraphicsDriver().CreateGraphics( width,height,depth,hertz,flags,x,y )
		If g Return TMax2DGraphics.Create( g,Self )
	End Method
	
'	Method SetGraphics( g:TGraphics ) Abstract
	
'	Method Flip( sync ) Abstract
	
	Method CreateFrameFromPixmap:TOGLImageFrame( pixmap:TPixmap, flags:Int )
		Return TOGLImageFrame.CreateFromPixmap(pixmap,flags)
	End Method
	
	Method SetBlend( blend:Int )
		Super.SetBlend blend
		Select m2d_blend
		Case MOD2XBLEND
			glEnable GL_BLEND
			glBlendFunc GL_DST_COLOR,GL_SRC_COLOR
			glDisable GL_ALPHA_TEST
		End Select
	End Method
	
'	Method SetAlpha( alpha# ) Abstract
'	Method SetColor( red,green,blue ) Abstract
'	Method SetClsColor( red,green,blue ) Abstract
'	Method SetViewport( x,y,width,height ) Abstract
'	Method SetTransform( xx#,xy#,yx#,yy# ) Abstract
'	Method SetLineWidth( width# ) Abstract
	
'	Method Cls() Abstract
'	Method Plot( x#,y# ) Abstract
'	Method DrawLine( x0#,y0#,x1#,y1#,tx#,ty# ) Abstract
'	Method DrawRect( x0#,y0#,x1#,y1#,tx#,ty# ) Abstract
'	Method DrawOval( x0#,y0#,x1#,y1#,tx#,ty# ) Abstract
'	Method DrawPoly( xy#[],handlex#,handley#,originx#,originy# ) Abstract
		
'	Method DrawPixmap( pixmap:TPixmap,x,y ) Abstract
'	Method GrabPixmap:TPixmap( x,y,width,height ) Abstract
	
'	Method SetResolution( width#,height# ) Abstract

	Method DrawPolyImage( xyuv#[],iframe:TImageFrame,handlex#,handley#,originx#,originy# )
		TOGLImageFrame(iframe).DrawPoly xyuv,handlex,handley,originx,originy
	End Method

End Type

Rem
bbdoc: Get OpenGL Odd2D Driver
about:
The returned driver can be used with #SetGraphicsDriver to enable OpenGL Odd2D 
rendering.
End Rem
Function GLOdd2DDriver:TGLOdd2DDriver()
	If Not _driver Then
		_driver=New TGLOdd2DDriver.Create()
	EndIf
	Return _driver
End Function
