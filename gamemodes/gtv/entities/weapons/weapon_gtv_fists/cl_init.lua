SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.PrintName = "Your bare hands"
SWEP.Slot = 0
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.HoldType = "slam"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Cooldown = 0.1
SWEP.Color = Color(255,0,0,255)
SWEP.tex = surface.GetTextureID("gtv/weapons/weapon_gtv_fists")
killicon.Add("weapon_gtv_fists","gtv/weapons/weapon_gtv_fists",SWEP.Color)

local tracep = {}
tracep.mask = MASK_SHOT
tracep.mins = Vector(-8,-8,-8)
tracep.mins = Vector(8,8,8)

function SWEP:Shoot()
	tracep.filter = self.Owner
	tracep.start = self.Owner:GetShootPos()
	tracep.endpos = self.Owner:GetShootPos()+self.Owner:GetAimVector()*100
	local tr = util.TraceHull(tracep)
	if tr.Entity && tr.Entity:IsValid() then
		self.Owner:EmitSound("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav")
		if (tr.Entity:IsPlayer() || tr.Entity:IsNPC()) then
			ParticleEffect("gtv_impact_blood",tr.HitPos,tr.Normal:Angle(),nil)
		end
	else
		self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end	
end