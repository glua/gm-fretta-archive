include( 'shared.lua' )
include( 'cl_postprocess.lua' )
include( 'cl_hud.lua' )

function GM:Initialize( )	

	self.BaseClass:Initialize()
	
	killicon.AddFont( "thaw", "CSKillIcons", "F", Color( 0, 255, 80 ) )	

end

function GM:RenderScreenspaceEffects()

	self.BaseClass:RenderScreenspaceEffects()
	
	if LocalPlayer():GetNetworkedBool( "Frozen", false ) then
	
		ColorModify[ "$pp_colour_addb" ]		= 0.10
		ColorModify[ "$pp_colour_mulb" ] 		= 0.50
		
	end
	
end

function GM:OnHUDPaint()

	if LocalPlayer():GetNetworkedBool( "Frozen", false ) then
	
		surface.SetTexture( surface.GetTextureID( "freezetag/icescreen" ) )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	
	end

end

function GM:HUDShouldDraw( name )

	if GAMEMODE.ScoreboardVisible then return false end
	
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end 
  	end 
	
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
		return false
	end
	
	return true
	
end