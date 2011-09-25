
//ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.PrintName		= "SMOKE GRENADE"
ENT.Author			= "WORSHIPPER"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""


/*---------------------------------------------------------
Remove
---------------------------------------------------------*/
function ENT:OnRemove()
end

/*---------------------------------------------------------
PhysicsUpdate
---------------------------------------------------------*/
function ENT:PhysicsUpdate()
end

/*---------------------------------------------------------
PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("SmokeGrenade.Bounce"))
	end
	
	local impulse = -data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6)
	phys:ApplyForceCenter(impulse)
end
