
local POWERUP = {}

POWERUP_FLAMER = 3

POWERUP.Description             = "PICKED UP THE IMMOLATOR"
POWERUP.ID                      = POWERUP_FLAMER
POWERUP.Color                   = Color( 0, 0, 255 )
POWERUP.Material                = "jumpjet/powerup_plasma"

function POWERUP:Start( pl )
	
	pl:StripWeapons()
	pl:Give( "jj_flamer" )
	
	local class = pl:GetPlayerClass()
	
	if not class then return end
	
	pl:SetRunSpeed( class.RunSpeed + 50 )
	pl:SetWalkSpeed( class.WalkSpeed + 50 )
	
end
	
function POWERUP:Think( pl )

end

function POWERUP:EndThink( pl )

	if not pl:Alive() then
	
		pl:SetPowerup()
		
	end

end

function POWERUP:End( pl )

	local class = pl:GetPlayerClass()
	
	if not class then return end
	
	pl:SetRunSpeed( class.RunSpeed )
	pl:SetWalkSpeed( class.WalkSpeed )
	
end

function POWERUP:DamageTaken( pl, victim, dmginfo )

end

function POWERUP:Killed( pl, victim, dmginfo )

	victim:SetModel( "models/player/charple.mdl" )
	victim:CreateRagdoll()

end

powerup.Register( "Immolator", POWERUP )