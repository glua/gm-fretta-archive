
local POWERUP = {}

POWERUP_FORCE = 4

POWERUP.Description             = "FORCE FIELD ACTIVATED"
POWERUP.ID                      = POWERUP_FORCE
POWERUP.Color                   = Color( 255, 255, 0 )
POWERUP.Material                = "jumpjet/powerup_force"

function POWERUP:Start( pl )
	
	local force = ents.Create( "sent_forcefield" )
	force:SetPos( pl:GetPos() + Vector(0,0,30) )
	force:SetParent( pl )
	force:SetOwner( pl )
	force:Spawn()
	
	pl.ForceField = force
	
end
	
function POWERUP:Think( pl )

end

function POWERUP:EndThink( pl )

	if not pl:Alive() then
	
		pl:SetPowerup()
		
	end

end

function POWERUP:End( pl )

	if ValidEntity( pl.ForceField ) then
	
		pl.ForceField:Remove()
	
	end
	
end

function POWERUP:DamageTaken( pl, victim, dmginfo )

end

function POWERUP:Killed( pl, victim, dmginfo )

	victim:CreateRagdoll()

end

powerup.Register( "Force", POWERUP )