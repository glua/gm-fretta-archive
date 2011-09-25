
local POWERUP = {}

POWERUP.DisplayName				= "Regeneration"
POWERUP.Color                   = Color( 0, 255, 0, 255 )
POWERUP.Duration 				= 30
POWERUP.PickupSound             = Sound( "items/smallmedkit1.wav" )

function POWERUP:Start( pl )

	self.EndTime = CurTime() + self.Duration
	
	pl:EmitSound( self.PickupSound, 100, 70 )

	local ed = EffectData()
	ed:SetEntity( pl )
	util.Effect( "powerup_regen", ed, true, true )
	
end
	
function POWERUP:Think( pl )

	if ( self.HealTime or 0 ) < CurTime() and pl:Health() < 100 then
	
		self.HealTime = CurTime() + 0.25
		pl:SetHealth( pl:Health() + 1 )
	
	end

end

function POWERUP:EndThink( pl )

	if self.EndTime < CurTime() or not pl:Alive() then
		pl:SetPowerup()
	end

end

function POWERUP:End( pl )

end

function POWERUP:DamageTaken( pl, victim, dmginfo )

	self.HealTime = CurTime() + 1.25

end

powerup.Register( "Regeneration", POWERUP )