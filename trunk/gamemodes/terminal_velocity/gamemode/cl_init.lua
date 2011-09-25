include( 'shared.lua' )
include( 'ply_extension.lua' )

function GM:Initialize()

	self.BaseClass:Initialize()
	
	WindVector = Vector(math.random(-10,10),math.random(-10,10),0)

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
