
local POWERUP = {}

POWERUP.DisplayName				= "Agility"
POWERUP.Color                   = Color( 0, 0, 255, 255 )
POWERUP.Duration 				= 60
POWERUP.PickupSound             = Sound( "npc/scanner/scanner_nearmiss1.wav" )

function POWERUP:Start( pl )

	self.EndTime = CurTime() + self.Duration
	
	pl:EmitSound( self.PickupSound, 100, 80 )
	
	pl:SetRunSpeed( 500 )
	pl:SetWalkSpeed( 350 )
	pl:SetCrouchedWalkSpeed( 0.75 )
	pl:SetJumpPower( 400 )
	
end
	
function POWERUP:Think( pl )

end

function POWERUP:EndThink( pl )

	if self.EndTime < CurTime() or not pl:Alive() then
		pl:SetPowerup()
	end

end

function POWERUP:End( pl )

	pl:SetRunSpeed( 400 )
	pl:SetWalkSpeed( 250 )
	pl:SetCrouchedWalkSpeed( 0.5 )
	pl:SetJumpPower( 200 )

end

function POWERUP:DamageTaken( pl, victim, dmginfo )

end

powerup.Register( "Agility", POWERUP )