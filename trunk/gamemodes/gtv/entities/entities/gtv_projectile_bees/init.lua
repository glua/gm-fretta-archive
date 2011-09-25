AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.target = NULL
ENT.LifeTime = 2
ENT.LastSting = 0
ENT.MaxSpeed = 400
ENT.MaxTurnSpeed = 300
function ENT:OnTakeDamage()
end

local ang = Angle(0,0,0)

function ENT:FindTarget()
	local target = NULL
	local closest = 600
	for k,v in ipairs(player.GetAll()) do
		if (v != self.Owner) && (v:GetPos():Distance(self:GetPos()) < closest) && v:Alive() then
			closest = v:GetPos():Distance(self:GetPos())
			target = v
		end
	end
	return target
end

function ENT:PhysicsCollide(data,physobj)
	//self:SetMoveType(MOVETYPE_NONE)
	//self:SetPos(data.HitPos)
	//self:Fire("Kill",0,0.1)
end 

function ENT:StartTouch()
end

function ENT:EndTouch()
end

local ang = Angle(0,0,0)

function ENT:Touch(hitent)
	if (hitent:GetSolid() != SOLID_NONE) && (hitent:GetSolid() != SOLID_VPHYSICS) && (hitent != self:GetOwner()) && !self.expl && (self.LastSting < CurTime()-1) then
		if hitent:IsPlayer() && (hitent != self.Owner) then
			local dmg = DamageInfo()
			dmg:SetDamage(4)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
			dmg:SetDamagePosition(self:GetPos())
			dmg:SetDamageForce(vector_origin)
			dmg:SetDamageType(DMG_ENERGYBEAM)
			hitent:TakeDamageInfo(dmg)
			self.LastSting = CurTime()
			self:EmitSound("ambient/creatures/flies"..math.random(1,5)..".wav",100,100)
			local edata = EffectData()
			edata:SetOrigin(self:GetPos())
			edata:SetNormal(self:GetAngles():Forward()*-1)
			util.Effect("bloodimpact",edata)
		end
		//self:Remove()
	end
end

function ENT:Think()
	if self.Created+self.LifeTime < CurTime() then
		self:Remove()
	end
	if !(self.target:IsValid()) || (self.target:IsPlayer() && !self.target:Alive()) then
		self.target = self:FindTarget()
		if self.target:IsValid() then
			self.LifeTime = self.LifeTime+2
		end
	end
end	

function ENT:OnRemove()
end

function ENT:OnTakeDamage(dmginfo)
	if !dmginfo:IsDamageType(DMG_CRUSH) then
		self:Remove()
	end
end

hook.Add("ShouldCollide","NoCollideBees",function(ent1,ent2) if (ent1:GetClass() == "gtv_projectile_bees") && (ent2:GetClass() == "gtv_projectile_bees") then return false end end)