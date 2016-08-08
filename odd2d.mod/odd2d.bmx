Strict

Rem
bbdoc: Graphics/Odd2D
about:
All Max2D commands should work as intended with the Odd2D module.
End Rem
Module ODD.Odd2D

ModuleInfo "Version: 1.03"
ModuleInfo "Author: David Williamson"
ModuleInfo "License: Public Domain"

Import BRL.Max2D

'Const BORDER_KEEP:Int=1
Const BORDER_NONE:Int=0
Const BORDER_LETTERBOX_FILL:Int=2
Const BORDER_LETTERBOX_SOLID:Int=3
Const BORDER_BESTFIT_FILL:Int=4
Const BORDER_BESTFIT_SOLID:Int=5

Rem
bbdoc: Modulate 2x blend mode
about: Can be used with #SetBlend for mudulate 2x blending.
End Rem
Const MOD2XBLEND:Int=6

Global _odd2dDriver:TOdd2DDriver

Type TOdd2DDriver Extends TMax2DDriver
	Field _m2ddriver:TMax2DDriver
	
	Field border_red:Int, border_green:Int, border_blue:Int
	Field border_mode:Int, border_x:Float, border_y:Float
	Field full_width:Float, full_height:Float, virt_width:Float, virt_height:Float, ratio:Float
	
	Field tform_scr_rot:Float, tform_scr_zoom:Float
	Field tform_scr_ix#,tform_scr_iy#,tform_scr_jx#,tform_scr_jy#
	
	Field focus_x:Float, focus_y:Float
	
	Field adj_vp_x:Int, adj_vp_y:Int, adj_vp_width:Int, adj_vp_height:Int
	
	Field m2d_blend:Int, m2d_alpha:Float, m2d_linewidth:Float
	Field m2d_clsred:Int, m2d_clsgreen:Int, m2d_clsblue:Int
	Field m2d_red:Int, m2d_green:Int, m2d_blue:Int
	Field m2d_ix:Float, m2d_iy:Float, m2d_jx:Float, m2d_jy:Float
	
	Method GraphicsModes:TGraphicsMode[]()
		Return _m2ddriver.GraphicsModes()
	End Method
	
'	Method AttachGraphics:TGraphics( widget,flags ) Abstract
	
'	Method CreateGraphics:TGraphics( width,height,depth,hertz,flags ) Abstract
	
	Method SetGraphics( g:TGraphics )
		_m2ddriver.SetGraphics g
		
		_odd2dDriver=TOdd2DDriver(_max2dDriver)
	End Method
	
	Method Flip( sync:Int )
		ClearBorder
		_m2ddriver.Flip sync
	End Method
	
'	Method CreateFrameFromPixmap:TImageFrame( pixmap:TPixmap,flags ) Abstract
	
	Method SetBlend( blend:Int )
		m2d_blend=blend
		_m2dDriver.SetBlend blend
	End Method
	
	Method SetAlpha( alpha:Float )
		m2d_alpha=alpha
		_m2dDriver.SetAlpha alpha
	End Method
	
	Method SetColor( red:Int, green:Int, blue:Int )
		m2d_red=red;m2d_green=green;m2d_blue=blue
		_m2dDriver.SetColor red,green,blue
	End Method
	
	Method SetClsColor( red:Int, green:Int, blue:Int )
		m2d_clsred=red;m2d_clsgreen=green;m2d_clsblue=blue
		_m2dDriver.SetClsColor red,green,blue
	End Method
	
	Method SetViewport( x:Int, y:Int, width:Int, height:Int )
		Local xscale:Float=full_width/virt_width
		Local yscale:Float=full_height/virt_height
		adj_vp_x=border_x*ratio+x/xscale
		adj_vp_y=border_y*ratio+y/yscale
		adj_vp_width=width/xscale
		adj_vp_height=height/yscale
		_m2dDriver.SetViewport adj_vp_x,adj_vp_y,adj_vp_width,adj_vp_height
	End Method
	
	Method SetTransform( xx:Float, xy:Float, yx:Float, yy:Float )
		m2d_ix=xx;m2d_iy=xy;m2d_jx=yx;m2d_jy=yy
		_m2dDriver.SetTransform xx,xy,yx,yy
	End Method
	
	Method SetLineWidth( width:Float )
		m2d_linewidth=width
		_m2dDriver.SetLineWidth width
	End Method
	
	Method Cls()
		_m2dDriver.Cls
	End Method
	
	Method Plot( x#,y# )
		TransformPoint x,y
		x:+border_x+focus_x
		y:+border_y+focus_y
		
		_m2dDriver.Plot x,y
	End Method
	
	Method DrawLine( x0#,y0#,x1#,y1#,tx#,ty# )
		TransformPoint x0,y0
		TransformPoint x1,y1
		TransformPoint tx,ty
		tx:+border_x+focus_x
		ty:+border_y+focus_y
		
		_m2dDriver.DrawLine x0,y0,x1,y1,tx,ty
	End Method
	
	Method DrawRect( x0#,y0#,x1#,y1#,tx#,ty# )
		Local rot:Float=GetRotation()
		Local sclx:Float,scly:Float
		GetScale sclx,scly
		SetRotation rot-tform_scr_rot
		SetScale sclx*tform_scr_zoom,scly*tform_scr_zoom
		TransformPoint tx,ty
		tx:+focus_x+border_x
		ty:+focus_y+border_y
		
		_m2dDriver.DrawRect x0,y0,x1,y1,tx,ty
		
		SetRotation rot
		SetScale sclx,scly
	End Method
	
	Method DrawOval( x0#,y0#,x1#,y1#,tx#,ty# )
		Local rot:Float=GetRotation()
		Local sclx:Float,scly:Float
		GetScale sclx,scly
		SetRotation rot-tform_scr_rot
		SetScale sclx*tform_scr_zoom,scly*tform_scr_zoom
		TransformPoint tx,ty
		tx:+focus_x+border_x
		ty:+focus_y+border_y
		
		_m2dDriver.DrawOval x0,y0,x1,y1,tx,ty
		
		SetRotation rot
		SetScale sclx,scly
	End Method
	
	Method DrawPoly( xy#[],handlex#,handley#,originx#,originy# )
		Local rot:Float=GetRotation()
		Local sclx:Float,scly:Float
		GetScale sclx,scly
		SetRotation rot-tform_scr_rot
		SetScale sclx*tform_scr_zoom,scly*tform_scr_zoom
		TransformPoint originx,originy
		originx:+focus_x+border_x
		originy:+focus_y+border_y
		
		_m2dDriver.DrawPoly xy,handlex,handley,originx,originy
		
		SetRotation rot
		SetScale sclx,scly
	End Method
	
	Method DrawPixmap( pixmap:TPixmap, x:Int, y:Int )
		_m2dDriver.DrawPixmap pixmap,x,y
	End Method
	
	Method GrabPixmap:TPixmap( x:Int, y:Int, width:Int, height:Int )
		Return _m2dDriver.GrabPixmap(x,y,width,height)
	End Method
	
	Method SetResolution( width#,height# )
		virt_width=width;virt_height=height
		Local gwidth:Int=GraphicsWidth()
		Local gheight:Int=GraphicsHeight()
		If border_mode=BORDER_NONE
			border_x=0;border_y=0;full_width=virt_width;full_height=virt_height;ratio=1
			adj_vp_x=0;adj_vp_y=0;adj_vp_width=Ceil(gwidth);adj_vp_height=Ceil(gheight)
			_m2dDriver.SetResolution(full_width,full_height)
			_m2dDriver.SetViewport adj_vp_x,adj_vp_y,adj_vp_width,adj_vp_height
			Return
		EndIf
		ratio=Min(gwidth/virt_width,gheight/virt_height)
		If border_mode&4
			ratio=Max(Floor(ratio),1)
		EndIf
		full_height=gheight/ratio
		full_width=gwidth/ratio
		
		border_x=(full_width-virt_width)*.5
		border_y=(full_height-virt_height)*.5
		If border_mode&4
			border_x=Floor(border_x)
			border_y=Floor(border_y)
		EndIf
		_m2dDriver.SetResolution full_width,full_height
		
		adj_vp_x=0;adj_vp_y=0;adj_vp_width=Ceil(full_width)*ratio;adj_vp_height=Ceil(full_height)*ratio
		_m2dDriver.SetViewport adj_vp_x,adj_vp_y,adj_vp_width,adj_vp_height
		
	End Method
	
	Method SetBorderMode( Mode:Int )
		border_mode=Mode
		SetResolution virt_width,virt_height
	End Method
	
	Method SetBorderColor( red:Int, green:Int, blue:Int )
		border_red=red
		border_green=green
		border_blue=blue
	End Method
	
	Method ClearBorder()
		If border_mode&1
			Local rot:Float=GetRotation()
			Local ox:Float,oy:Float;GetOrigin ox,oy
			Local hx:Float,hy:Float;GetHandle hx,hy
			Local sx:Float, sy:Float;GetScale sx,sy
			_m2dDriver.SetViewport 0,0,Int(Ceil(full_width)*ratio),Int(Ceil(full_height)*ratio)
			_m2dDriver.SetColor border_red,border_green,border_blue
			_m2dDriver.SetAlpha 1
			SetRotation 0
			SetOrigin 0,0
			SetHandle 0,0
			SetScale 1,1
			_m2dDriver.SetBlend SOLIDBLEND
			_m2dDriver.DrawRect -1,-1,full_width+1,border_y,0,0
			_m2dDriver.DrawRect -1,border_y+virt_height,full_width+1,full_height+1,0,0
			_m2dDriver.DrawRect -1,border_y-1,border_x,border_y+virt_height+1,0,0
			_m2dDriver.DrawRect border_x+virt_width,border_y-1,full_width+1,border_y+virt_height+1,0,0
			SetColor m2d_red,m2d_green,m2d_blue
			_m2dDriver.SetAlpha m2d_alpha
			SetRotation rot
			SetOrigin ox,oy
			SetHandle hx,hy
			SetScale sx,sy
			SetBlend m2d_blend
			_m2dDriver.SetViewport adj_vp_x,adj_vp_y,adj_vp_width,adj_vp_height
		EndIf
	End Method
	
	Method SetScreenRotation( rot:Float )
		tform_scr_rot=rot
		UpdateTransform
	End Method
	
	Method SetZoom( zoom:Float )
		tform_scr_zoom=zoom
		UpdateTransform
	End Method
	
	Method SetFocus( x:Float, y:Float )
		focus_x=x
		focus_y=y
	End Method
	
	Method SetMidFocus()
		focus_x=virt_width*.5
		focus_y=virt_height*.5
	End Method
	
	Method OddMouse( x:Float Var, y:Float Var )
		Local ox:Float,oy:Float;GetOrigin ox,oy
		Local s#=Sin(tform_scr_rot), c#=Cos(tform_scr_rot)
		Local ix#= c/tform_scr_zoom, jx#= s/tform_scr_zoom
		Local iy#=-s/tform_scr_zoom, jy#= c/tform_scr_zoom
		Local xscale:Float=full_width/virt_width
		Local yscale:Float=full_height/virt_height
		x=VirtualMouseX()*(full_width/virt_width)-border_x-focus_x
		y=VirtualMouseY()*(full_height/virt_height)-border_y-focus_y
		Local tmp_x:Float=x
		x=x*ix+y*iy-ox
		y=tmp_x*jx+y*jy-oy
	End Method
	
	Method DrawPolyImage( xyuv#[],iframe:TImageFrame,handlex#,handley#,originx#,originy# ) Abstract

	Method UpdateTransform()
		Local s#=Sin(-tform_scr_rot)
		Local c#=Cos(-tform_scr_rot)
		tform_scr_ix= c*tform_scr_zoom
		tform_scr_iy=-s*tform_scr_zoom
		tform_scr_jx= s*tform_scr_zoom
		tform_scr_jy= c*tform_scr_zoom
	End Method
	
	Method TransformPoint( x:Float Var, y:Float Var )
		Local tmp_x:Float=x
		x=x*tform_scr_ix+y*tform_scr_iy
		y=tmp_x*tform_scr_jx+y*tform_scr_jy
	End Method
	
	Method InitFields()
		border_red=0
		border_green=0
		border_blue=0
		border_mode=BORDER_NONE
		border_x=0
		border_y=0
		full_width=GraphicsWidth()
		full_height=GraphicsHeight()
		virt_width=full_width
		virt_height=full_height
		tform_scr_rot=0
		tform_scr_zoom=1
		UpdateTransform
	
		focus_x=0
		focus_y=0
		
		m2d_blend=MASKBLEND
		m2d_alpha=1
		m2d_linewidth=1
		m2d_clsred=0;m2d_clsgreen=0;m2d_clsblue=0
		m2d_red=255;m2d_green=255;m2d_blue=255
	End Method

End Type

Rem
bbdoc: Sets how borders displayed
about: Sets how borders will be displayed if the virtual aspect ratio is not the same as the screens aspect ratio.

The available modes are:
[ @BORDER_NONE | Stretches/distorts the display to fit the screen. This is the default Max2D behaviour
* @BORDER_LETTERBOX_FILL | Scales the display to fit the screen but maintains it's aspect ratio. Any draw space left around it is @not clipped
* @BORDER_LETTERBOX_SOLID | Scales the display to fit the screen but maintains it's aspect ratio. Any draw space left around it is clipped
* @BORDER_BESTFIT_FILL | Scales the display by whole numbers only whilst maintaining it's aspect ratio. Any draw space left around it is @not clipped
* @BORDER_BESTFIT_SOLID | Scales the display by whole numbers only whilst maintaining it's aspect ratio. Any draw space left around it is clipped
]
End Rem
Function SetBorderMode( Mode:Int )
	_odd2dDriver.SetBorderMode Mode
End Function

Rem
bbdoc: Set current border color
about:
The @red, @green and @blue parameters should be in the range of 0 to 255.

The default border color is black.
End Rem
Function SetBorderColor( red:Int, green:Int, blue:Int )
	_odd2dDriver.SetBorderColor red,green,blue
End Function

Rem
bbdoc: Set screen rotation
about:
@rotation is given in degrees and should be in the range 0 to 360.

#SetScreenRotation rotates the whole display around the focus.
End Rem
Function SetScreenRotation( rot:Float )
	_odd2dDriver.SetScreenRotation rot
End Function

Rem
bbdoc: Set current screen zoom
about:
Zooms the display in or out centered upon the focus.
End Rem
Function SetZoom( zoom:Float )
	_odd2dDriver.SetZoom zoom
End Function

Rem
bbdoc: Set display focus
about:
The screen focus is a 2D offset added to the x,y location of all 
drawing commands. It is applied after all other transforms and can be thought of as the screens handle.

In Max2D the focus is allways the top lext of the screen meaning all other cammands ultimately take their origin from that,
#SetScreenFocus allows you to change this behaviour.
End Rem
Function SetScreenFocus( x:Float, y:Float )
	_odd2dDriver.SetFocus x,y
End Function

Rem
bbdoc: Sets the screen focus to the center of the display
End Rem
Function SetMidFocus()
	_odd2dDriver.SetMidFocus
End Function

Rem
bbdoc: Gets the current position of the mouse
about: Sets @x and @y to the current mouse position using the draw coordinates.
EndRem
Function OddMouse( x:Float Var, y:Float Var )
	_odd2dDriver.OddMouse x,y
End Function

Rem
bbdoc: Draw a polygon using image as a texture
about:
#DrawPolyImage draws a polygon with corners defined by an array of x#,y# and u#,v# coordinate pairs.
The u/v coordinates are measured in image pixels.

BlitzMax commands that affect the drawing of polygons include #SetColor, #SetHandle, 
#SetScale, #SetRotation, #SetOrigin, #SetViewPort, #SetBlend and #SetAlpha.
End Rem
Function DrawPolyImage( xyuv:Float[], image:TImage, frame:Int=0 )
	Local iframe:TImageFrame=image.Frame(frame)
	If Not iframe Then Return
	
	Local handle_x:Float, handle_y:Float, origin_x:Float, origin_y:Float
	GetHandle handle_x,handle_y;GetOrigin origin_x,origin_y
	Local rot:Float=GetRotation()
	Local sclx:Float,scly:Float
	GetScale sclx,scly
	SetRotation rot-_odd2dDriver.tform_scr_rot
	SetScale sclx*_odd2dDriver.tform_scr_zoom,scly*_odd2dDriver.tform_scr_zoom
	_odd2dDriver.TransformPoint origin_x,origin_y
	origin_x:+_odd2dDriver.focus_x+_odd2dDriver.border_x
	origin_y:+_odd2dDriver.focus_y+_odd2dDriver.border_y
		
	_odd2ddriver.DrawPolyImage xyuv,iframe,handle_x,handle_y,origin_x,origin_y
		
	SetRotation rot
	SetScale sclx,scly
End Function

Rem
bbdoc: Draw an image polygon to the back buffer
about:
#DrawImagePoly works the same as #DrawImage except instead of drawing the full image it draws a polygonal portion of it defined by the u,v coordinates. 
The u/v coordinates are measured in image pixels.

Drawing is affected by the current blend mode, color, scale and rotation.

If the blend mode is ALPHABLEND the image is affected by the current alpha value
and images with alpha channels are blended correctly with the background.
End Rem
Function DrawImagePoly( image:TImage, x:Float, y:Float, uv:Float[], frame:Int=0 )
	Local iframe:TImageFrame=image.Frame(frame)
	If Not iframe Then Return
	
	Local handle_x:Float, handle_y:Float, origin_x:Float, origin_y:Float
	GetOrigin origin_x,origin_y
	origin_x:+x;origin_y:+y
	Local rot:Float=GetRotation()
	Local sclx:Float,scly:Float
	GetScale sclx,scly
	SetRotation rot-_odd2dDriver.tform_scr_rot
	SetScale sclx*_odd2dDriver.tform_scr_zoom,scly*_odd2dDriver.tform_scr_zoom
	_odd2dDriver.TransformPoint origin_x,origin_y
	origin_x:+_odd2dDriver.focus_x+_odd2dDriver.border_x
	origin_y:+_odd2dDriver.focus_y+_odd2dDriver.border_y
	
	Local segs:Int=uv.length/2
	Local xyuv:Float[segs*4]
	For Local i:Int=0 Until segs
		xyuv[i*4]=uv[i*2]
		xyuv[i*4+1]=uv[i*2+1]
		xyuv[i*4+2]=uv[i*2]
		xyuv[i*4+3]=uv[i*2+1]
	Next
		
	_odd2ddriver.DrawPolyImage xyuv,iframe,image.handle_x,image.handle_y,origin_x,origin_y
		
	SetRotation rot
	SetScale sclx,scly
End Function
