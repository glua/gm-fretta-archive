--largely a GMDM port, thanks GMDM folks
local HitFlesh1 = Sound("weapons/crossbow/bolt_skewer1.wav")
local HitFlesh2 = Sound("physics/flesh/flesh_impact_bullet1.wav")
local HitSound = Sound("npc/roller/blade_out.wav")

AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ('shared.lua')

util.PrecacheModel ("models/items/ar2_grenade.mdl")

local Bounce_Sound = Sound ("physics/concrete/rock_impact_hard4.wav")

function ENT:Initialize()
	self.Entity:SetModel ("models/Items/AR2_Grenade.mdl")
	
	self:DrawShadow( false )
	
	self:PhysicsInit (SOLID_VPHYSICS)
	self:SetMoveType (MOVETYPE_VPHYSICS)
	self:SetSolid (SOLID_VPHYSICS)
	
	self:StartMotionController()
	
	self:SetCollisionGroup (COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:SetTrigger(true)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableCollisions (true)
		phys:EnableDrag (false)
		phys:EnableGravity (false)
		phys:SetMass (50)
		phys:Wake()
	end
	
	self:UpdateColor()
	self.Trail = util.SpriteTrail (self, 0, self.Color, false, 2, 1, 0.20, 1/32 * 0.5, "trails/plasma.vmt")
end

function ENT:Touch(ent)
	if self.DieTime then return end
	if ent:IsPlayer() or string.find(ent:GetClass(),"prop_phys") then
		if ent == self:GetOwner() then return end
		
		if ent:IsPlayer() then
			ent:TakeDamage (self.Damage or 120, self.Entity:GetOwner(), self)
			self:EmitSound (HitFlesh1, 100, math.random(130, 140))
			
			self.DieTime = CurTime() --fix to stop multi-hits
			
			self.Trail:Remove()
			self:Remove()
		else
			self.HitWeld = self:Weld (ent)
			self.DieTime = CurTime() + 5
			self:EmitSound (HitSound, 100, math.random(130,150))
		end
	end
end

function ENT:PhysicsUpdate (phys, deltatime)
	if self.HitWeld then 
		phys:EnableGravity (true) 
		phys:EnableDrag (true)
		return SIM_NOTHING 
	end
	
	phys:Wake()
	phys:SetVelocityInstantaneous (self:GetAngles():Forward():Normalize() * self.Velocity)
	phys:AddAngleVelocity (Angle(0, 0.15 * (self.ArcMultiplier or 1), 0))
end

function ENT:PhysicsCollide (data, phys)
	if data.HitEntity:IsWorld() and not self.HitWeld then
		if self.Ricochets and self.Ricochets > 0 then
			self.Ricochets = self.Ricochets - 1
			local DotProduct = data.HitNormal:Dot (self.Entity:GetAngles():Forward() * -1)
			local Dir = (2 * data.HitNormal * DotProduct) + self.Entity:GetAngles():Forward()
			Dir:Normalize()
			self.Entity:SetAngles (Dir:Angle())
			self.Entity:SetPos (self.Entity:GetPos() + Dir * 16)
			phys:SetVelocityInstantaneous (Dir * self.Velocity)
			phys:AddAngleVelocity (phys:GetAngleVelocity() * -1)
			print ("NICO! RICO!")
			WorldSound ("weapons/fx/rics/ric4.wav", data.HitPos, 70, math.random(70, 100))
			return
		end
		self.DieTime = CurTime() + 5
		self:EmitSound (HitSound, 100, math.random(130,150))
		phys:EnableMotion (false)
		self:SetSolid (SOLID_NONE)
		self:SetCollisionGroup (COLLISION_GROUP_NONE)
		local pos = (self.ThreePosAgo or self.TwoPosAgo or self.OnePosAgo or self:GetPos())
		local ang = (self.ThreeAngAgo or self.TwoAngAgo or self.OneAngAgo or self:GetAngles())
		local trc = util.TraceHull ({start = pos, endpos = pos + (ang:Forward() * 128), filter = self.Entity, mask = MASK_SHOT, mins = Vector (-4,-4,-4), maxs = Vector (4,4,4)})
		print (pos, trc.HitPos)
		self:SetPos ((trc.HitPos - ang:Forward() * 4) or pos)
	end
end

function ENT:Weld( ent )
	return constraint.Weld (ent, self, 0, 0, 0, true)
end

function ENT:Think()
	if self.DieTime then
		if self.DieTime < CurTime() then
			self:Remove() 
		end
	end
	
	self.ThreePosAgo = self.TwoPosAgo
	self.ThreeAngAgo = self.TwoAngAgo
	self.TwoPosAgo = self.OnePosAgo
	self.TwoAngAgo = self.OneAngAgo
	self.OnePosAgo = self:GetPos()
	self.OneAngAgo = self:GetAngles()
	
	self:NextThink (CurTime())
	
	return true
end