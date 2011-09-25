AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.weaponList = {"weapon_ar2", "weapon_crossbow", "weapon_frag", "weapon_pistol", "weapon_shotgun", "weapon_smg1", "item_kbhealth"}

ENT.itemList = {"item_ammo_ar2", "item_ammo_ar2_large", "item_ammo_crossbow", "item_ammo_pistol", "item_ammo_pistol_large", 
				"item_ammo_smg1", "item_ammo_smg1_grenade",	"item_ammo_smg1_large", "item_box_buckshot"}


ENT.aHealth = 70
ENT.aModel = "models/props_junk/wood_crate001a.mdl"
ENT.gib = 1
ENT.brkOnUse = 1
ENT.dieTime = 0

function ENT:Initialize()

	self.Entity:SetModel(self.aModel)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.Entity:SetNetworkedBool("dying",false,false)
end

function ENT:GetCenterPos()
	return self:GetPos()
end

function ENT:Use(activator, caller)
	return
end

function ENT:Think()
	if self.Entity:GetNetworkedBool("dying") then
		self.dieTime = self.dieTime - .4
		if self.dieTime <= 0 then
			self.Entity:Remove()
		end
	end
end

function ENT:OnTakeDamage(dmg)
	self.aHealth = self.aHealth - dmg:GetDamage()
	if self.aHealth <= 0 then
		if self.gib == 1 then self:SpawnGibs() end
		self:Die()
	end
end

function ENT:SpawnGibs()
	local expEffect = EffectData()
	expEffect:SetStart(self:GetPos())
	expEffect:SetOrigin(self:GetPos())
	expEffect:SetScale(0.5)
	util.Effect("cball_explode", expEffect)
	self:EmitSound("Wood_Box.Break")
	
	local breakProp = ents.Create("prop_physics")
	breakProp:SetModel(self.aModel)
	breakProp:SetPos(self:GetPos())
	breakProp:SetName("gibee")
	breakProp:Spawn()
	local brkPhys = breakProp:GetPhysicsObject()
	if brkPhys:IsValid() then
		brkPhys:EnableGravity(false)
		brkPhys:EnableDrag(false)
		brkPhys:EnableCollisions(false)
	end
	
	local phyEx = ents.Create("env_physexplosion")
	phyEx:SetPos(self:GetCenterPos())
	phyEx:SetKeyValue("magnitude", "25000")
	phyEx:SetKeyValue("targetentityname","gibee")
	phyEx:SetKeyValue("spawnflags",1)
	phyEx:Spawn()
	breakProp:Fire("break","",0)
	phyEx:Fire("explode","",0)
	breakProp:Remove()
	phyEx:Remove()
end

function ENT:Die()
	self.Entity:SetNetworkedBool("dying",true,true)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_NONE)
	self.Entity:DrawShadow(false)
end

function ENT:OnRemove()
	
	if self.Entity.aHealth <= 0 then
	local spawnList = {}
	local spawnSize = 0
	local rand = math.random(1,30)
	if rand <= 20 then
		spawnList = table.Copy(self.weaponList)
	else
		spawnList = table.Copy(self.itemList)
	end
	rand = math.random(1,#spawnList)
	local item = ents.Create(spawnList[rand])
	local spawnPos = self.Entity:GetPos()+Vector(0,0,item:BoundingRadius())
	
	item:SetPos(spawnPos)
	item:Spawn()
	itemPhysObj = item:GetPhysicsObject()
	itemPhysObj:ApplyForceCenter( Vector(math.random(0, 100), math.random(0, 100), math.random(0, 100)))
	itemPhysObj:AddAngleVelocity(Angle(math.random(-100, 100),math.random(-100, 100),math.random(-100, 100)))
	item:Activate()
	end
end
