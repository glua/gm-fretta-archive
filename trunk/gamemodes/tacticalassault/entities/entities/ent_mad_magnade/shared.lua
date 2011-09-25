ENT.Type 			= "anim"
ENT.PrintName		= "Sticky Grenade"
ENT.Author			= "Worshipper"
ENT.Contact			= "Josephcadieux@hotmail.com"
ENT.Purpose			= ""
ENT.Instructions		= ""

/*---------------------------------------------------------
   Name: ENT:OnRemove()
---------------------------------------------------------*/
function ENT:OnRemove()
end

/*---------------------------------------------------------
   Name: ENT:PhysicsUpdate()
---------------------------------------------------------*/
function ENT:PhysicsUpdate()
end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollide()
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, phys)

	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("Grenade.ImpactHard"))
	end

//	local impulse = -data.Speed * data.HitNormal * 0.2 + (data.OurOldVelocity * -0.3)
//	phys:ApplyForceCenter(impulse)
end
