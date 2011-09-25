AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetDTEntity(0, self.Entity.Owner)
	self.Owner = self.Entity:GetDTEntity(0)

	if !ValidEntity(self.Owner) then
		self:Remove()
		return
	end

	self.Entity:SetModel("models/props_combine/combine_mine01.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)

	self.Entity:SetDTBool(0, self.Activated or false)
	self.Entity.Boom = false

	// Don't collide with the player
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	//While in non-activated mode the mine can be moved
	local phys = self.Entity:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	self.NextUse = CurTime()
	self.Entity:EmitSound(Sound("npc/roller/mine/combine_mine_deploy1.wav", 50, 100))

	undo.Create("Anti-Personal Mine")
		undo.AddEntity(self.Entity)
		undo.SetPlayer(self.Owner)
	undo.Finish() 
end

/*---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------*/
function ENT:Use(activator, caller)

	local trace = activator:GetEyeTrace()

	local tracedata = {}
	tracedata.start = trace.Entity:GetPos()
	tracedata.endpos = Vector(trace.Entity:GetPos().x, trace.Entity:GetPos().y, trace.Entity:GetPos().z - 2)
	tracedata.filter = trace.Entity
	local tr = util.TraceLine(tracedata)

	local phys = self.Entity:GetPhysicsObject()

	if self.NextUse < CurTime() and activator == self.Owner then
		if not self.Entity:GetDTBool(0) then
			if tr.HitWorld then
				self.Entity:SetDTBool(0, true)
				self.Entity:EmitSound(Sound("npc/roller/mine/rmine_blip1.wav", 40, 100))
				phys:EnableMotion(false)
				phys:Sleep()

				activator:PrintMessage(HUD_PRINTTALK, "Mine activated.")
			else
				activator:PrintMessage(HUD_PRINTTALK, "You can't activate a mine which is not on the ground!")
				self.Entity:EmitSound(Sound("npc/roller/mine/rmine_blip3.wav", 40, 100))
			end
		else
			self.Entity:SetDTBool(0, false)
			self.Entity:EmitSound(Sound("npc/roller/mine/rmine_blip3.wav", 40, 100))
			phys:EnableMotion(true)
			phys:Wake()
			
			activator:PrintMessage(HUD_PRINTTALK, "Mine desactivated.")
		end

		self.NextUse = CurTime() + 1
	end
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	if self.Entity.Boom then
		self:Explosion()
	end

	for _, v in pairs(ents.FindInSphere(self.Entity:GetPos(), 14)) do
		if (v:IsPlayer() or v:IsNPC() or v:IsVehicle()) and self.Entity:GetDTBool(0) then
			// Handle vehicles
			if v:IsVehicle() then
				if v:GetDriver():IsValid() == false then return false end // No driver

				v:GetPhysicsObject():SetVelocity(Vector(0, 500, 750))
			end
		
			self:Explosion()
		end
	end
end

/*---------------------------------------------------------
   Name: ENT:Explosion()
---------------------------------------------------------*/
function ENT:Explosion()

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
	util.Effect("HelicopterMegaBomb", effectdata)

	local explo = ents.Create("env_explosion")
		explo:SetOwner(self.Owner)
		explo:SetPos(self.Entity:GetPos())
		explo:SetKeyValue("iMagnitude", "150")
		explo:SetKeyValue("spawnflags", "66")
		explo:Spawn()
		explo:Activate()
		explo:Fire("Explode", "", 0)
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "2000")	// Power of the shake
		shake:SetKeyValue("radius", "250")		// Radius of the shake
		shake:SetKeyValue("duration", "2.5")	// Time of shake
		shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)

	self.Entity:EmitSound(Sound("NPC_RollerMine.Shock"))
		
	//Remove mine
	self.Entity:Remove()
end