
if SERVER then

	AddCSLuaFile("shared.lua")
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel = "models/Zed/weapons/v_disease.mdl"

SWEP.Primary.Voice          = Sound("npc/zombie_poison/pz_throw3.wav")
SWEP.Primary.Sound			= Sound("npc/zombie/claw_miss1.wav")
SWEP.Primary.Hit            = Sound("npc/zombie/claw_strike1.wav")
SWEP.Primary.Damage			= 20
SWEP.Primary.HitForce       = 1200
SWEP.Primary.Delay			= 1.50
SWEP.Primary.FreezeTime     = 0.45
SWEP.Primary.Automatic		= false

function SWEP:MeleeTrace( dmg )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 50
	local ent = self.Owner:TraceHullAttack( pos, pos + aim, Vector(-16,-16,-16), Vector(32,32,32), dmg, DMG_SLASH, self.Primary.HitForce, false )

	if not ent or not ent:IsValid() then 
	
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(90,100) )
		return 
		
	end
	
	self.Owner:EmitSound( self.Primary.Hit, 100, math.random(90,100) )
	
	if string.find( ent:GetClass(), "prop_phys" ) then
		ent:SetPhysicsAttacker( self.Owner )
	elseif string.find( ent:GetClass(), "npc" ) then
		GAMEMODE:CreateZombie( ent:GetClass() )
		ent:Remove()
	end
	
	if not ent:IsPlayer() or ent:Team() == TEAM_DEAD then return end
	
	ent:DoPoison( self.Owner )

end