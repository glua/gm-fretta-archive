local matScreen 	= Material( "models/weapons/v_toolgun/screen" )
local txidScreen	= surface.GetTextureID( "models/weapons/v_toolgun/screen" )
local txRotating	= surface.GetTextureID( "pp/fb" )
local txBackground	= surface.GetTextureID( "models/weapons/v_toolgun/screen_bg" )
// GetRenderTarget returns the texture if it exists, or creates it if it doesn't
local RTTexture 	= GetRenderTarget( "GModToolgunScreen", 256, 256 )

surface.CreateFont( "coolvetica", 82, 500, true, false, "GModToolScreen" )

local function DrawScrollingText( text, y, texwide )

		local w, h = surface.GetTextSize( text  )
		w = w + 64
		
		local x = math.fmod( CurTime()*150, w ) * -1;
		
		while ( x < texwide ) do
		
			surface.SetTextColor( 0, 0, 0, 255 )
			surface.SetTextPos( x + 3, y + 3 )
			surface.DrawText( text )
				
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( x, y )
			surface.DrawText( text )
			
			x = x + w
			
		end

end

/*---------------------------------------------------------
	We use this opportunity to draw to the toolmode 
		screen's rendertarget texture.
---------------------------------------------------------*/
function SWEP:ViewModelDrawn()
	
	local TEX_SIZE = 256
	local NewRT = RTTexture
	
	// Set the material of the screen to our render target
	matScreen:SetMaterialTexture( "$basetexture", NewRT )
	
	local OldRT = render.GetRenderTarget();
	
	// Set up our view for drawing to the texture
	render.SetRenderTarget( NewRT )
	render.SetViewPort( 0, 0, TEX_SIZE, TEX_SIZE )
	cam.Start2D()
	
	// Background
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( txBackground )
	surface.DrawTexturedRect( 0, 0, TEX_SIZE, TEX_SIZE )
		
	surface.SetFont( "GModToolScreen" )
	DrawScrollingText( "Remover", 64, TEX_SIZE )		

	cam.End2D()
	render.SetRenderTarget( OldRT )
	
	
end
