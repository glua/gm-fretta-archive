
local POWERUP = {}

POWERUP.DisplayName				= "Rage"
POWERUP.Color                   = Color( 255, 0, 0, 255 )
POWERUP.Duration 				= 20
POWERUP.PickupSound             = Sound( "npc/strider/striderx_alert2.wav" )

function POWERUP:Start( pl )

	self.EndTime = CurTime() + self.Duration
	
	pl:EmitSound( self.PickupSound )
	pl:SetDSP( 23, false )

	local ed = EffectData()
	ed:SetEntity( pl )
	util.Effect( "powerup_rage", ed, true, true )
	
end
	
function POWERUP:Think( pl )

end

function POWERUP:EndThink( pl )

	if self.EndTime < CurTime() or not pl:Alive() then
		pl:SetPowerup()
	end

end

function POWERUP:End( pl )

	pl:SetDSP( 0, false )

end

function POWERUP:DamageTaken( pl, victim, dmginfo )

	dmginfo:ScaleDamage( 2 )
	victim:EmitSound( table.Random( GAMEMODE.BulletSmash ), 100, math.random( 100, 120 ) )
	
end

powerup.Register( "Rage", POWERUP )