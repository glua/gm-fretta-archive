ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
end

function ENT:Setup(Radius, Function)
	self.Radius = Radius or 256
	self.OnTouch = Function
	
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local Radius = Vector(self.Radius, self.Radius, self.Radius)
	
	self.Entity:PhysicsInitBox(-1 * Radius, Radius)
	self.Entity:SetCollisionBounds(-1 * Radius, Radius)
	
	self.Entity:SetTrigger(true)
	self.Entity:DrawShadow(true)
	self.Entity:SetNotSolid(true)
	
	local Phys = self.Entity:GetPhysicsObject()
	if(Phys and Phys:IsValid()) then
		Phys:EnableCollisions(false)
		Phys:Sleep()
	end
	
	self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self.Entity:SetColor(255, 255, 255, 0)
end

function ENT:StartTouch(Ent)
	if(!Ent:IsPlayer() or !Ent:Alive()) then
		return
	end
	if(self.OnTouch) then
		local Work, Err = pcall(self.OnTouch, Ent)
		if(!Work) then
			ErrorNoHalt("TouchEvent Error: "..tostring(Err).."\n")
		end
	end
end
