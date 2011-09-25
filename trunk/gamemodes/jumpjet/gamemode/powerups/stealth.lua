
local POWERUP = {}

POWERUP_STEALTH = 2

POWERUP.Description             = "STEALTH MODE ENABLED"
POWERUP.ID                      = POWERUP_STEALTH
POWERUP.Color                   = Color( 0, 255, 255 )
POWERUP.Material                = "jumpjet/powerup_stealth"
POWERUP.PickupSound             = Sound( "physics/nearmiss/whoosh_large4.wav" )

function POWERUP:Start( pl )
	
	pl:EmitSound( self.PickupSound, 100, 150 )
	pl:DrawWorldModel( false )
	pl:DrawShadow( false )
	pl:SetMaterial( "sprites/heatwave" )
	pl:SetColor( 0, 0, 0, 50 )
	
	local ed = EffectData()
	ed:SetEntity( pl )
	util.Effect( "powerup_stealth", ed, true, true )
	
	local class = pl:GetPlayerClass()
	
	if not class then return end
	
	pl:SetRunSpeed( class.RunSpeed + 100 )
	pl:SetWalkSpeed( class.WalkSpeed + 100 )
	pl:SetJumpPower( class.JumpPower + 50 )
	
end
	
function POWERUP:Think( pl )

	pl:DrawWorldModel( false )

end

function POWERUP:EndThink( pl )

	if not pl:Alive() then
	
		pl:SetPowerup()
		
	end

end

function POWERUP:End( pl )

	pl:DrawWorldModel( true )
	pl:DrawShadow( true )
	pl:SetMaterial( "" )
	pl:SetColor( 255, 255, 255 ,255 )

	local class = pl:GetPlayerClass()
	
	if not class then return end
	
	pl:SetRunSpeed( class.RunSpeed )
	pl:SetWalkSpeed( class.WalkSpeed )
	pl:SetJumpPower( class.JumpPower )
	
end

function POWERUP:DamageTaken( pl, victim, dmginfo )

end

function POWERUP:Killed( pl, victim, dmginfo )

	victim:CreateRagdoll()

end

powerup.Register( "Stealth", POWERUP )