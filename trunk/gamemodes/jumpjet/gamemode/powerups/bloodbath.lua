
local POWERUP = {}

POWERUP_BLOODBATH = 1

POWERUP.Description				= "BLOODBATH MODE ENABLED"
POWERUP.ID                      = POWERUP_BLOODBATH
POWERUP.Color                   = Color( 255, 0, 0 )
POWERUP.Material                = "jumpjet/powerup_blood"
POWERUP.PickupSound             = Sound( "npc/strider/striderx_alert2.wav" )

function POWERUP:Start( pl )
	
	pl:SetDSP( 23, false )
	pl:EmitSound( self.PickupSound )

	local ed = EffectData()
	ed:SetEntity( pl )
	util.Effect( "powerup_bloodbath", ed, true, true )
	
end
	
function POWERUP:Think( pl )

end

function POWERUP:EndThink( pl )

	if not pl:Alive() then
	
		pl:SetPowerup()
		
	end

end

function POWERUP:End( pl )

	pl:SetDSP( 0, false )

end

function POWERUP:DamageTaken( pl, victim, dmginfo )

	dmginfo:ScaleDamage( 2 )
	victim:EmitSound( table.Random( GAMEMODE.PlayerGore ), 100, math.random( 90, 110 ) )
	
	local ed = EffectData()
	ed:SetOrigin( victim:GetPos() + Vector(0,0,30) )
	util.Effect( "bloodbath_hit", ed, true, true )
	
end

function POWERUP:Killed( pl, victim, dmginfo )

	local ed = EffectData()
	ed:SetOrigin( victim:GetPos() + Vector(0,0,50) )
	util.Effect( "gore_explosion", ed, true, true )

end

powerup.Register( "Bloodbath", POWERUP )