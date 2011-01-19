
include('shared.lua')


function SWEP:CustomAmmoDisplay()

	if ( !ValidEntity( self.Owner ) ) then return 0 end
	
	self.AmmoDisplay = self.AmmoDisplay or {}
	
	self.AmmoDisplay.Draw = true
	
	self.AmmoDisplay.PrimaryClip 	= self.Owner:GetCustomAmmo( "egonenergy" )
	self.AmmoDisplay.PrimaryAmmo 	= -1
	self.AmmoDisplay.SecondaryAmmo 	= -1
	
	return self.AmmoDisplay

end
