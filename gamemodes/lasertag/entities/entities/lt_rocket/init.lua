// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Guidable rocket

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

/*-------------------------------------------------------------------
	[ Initialize ]
	When the entity is initialized.
-------------------------------------------------------------------*/
function ENT:Initialize()
	self.ShadowParams = {}
	
	self.Entity:SetModel("models/props_combine/headcrabcannister01a_skybox.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:StartMotionController()
	self:SetNWBool("Exploded",false)
	
	// Sound effects.
	self.Sound = CreateSound(self.Entity,"npc/scanner/combat_scan_loop2.wav")
	self.Sound:Play()
	
	// Basic parameters.
	self.Radius = 200
	self.Damage = 110 // At origin. Phases out over the radius. A player on the very edge of the radius is likely to receive about 0.01% of the damage. (1 damage.)
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	
	// SpriteTrail basic settings.
	local StartWidth = 32
	local EndWidth = 0
	local Length = 2
	local LaserTex = "trails/laser"
	
	local owner = self:GetOwner()
	// print(owner and "WE HAS AN OWNER" or "FUK WE DUNT HAS AN OWNER") // MADNESS? THIS IS DEBUGGING.
	self.Color = color_white
	if owner then
		self.Color = team.GetColor(owner:Team()) 
		
		local tr = util.TraceLine({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:GetAimVector()*8000,
			filter = {owner,self.Entity}
		})
		
		self.Entity:SetAngles((tr.HitPos - self.Entity:GetPos()):Angle())
	end
	
	// The monolithic SpriteTrail call. This function has so many arguments.
	self.Trail = util.SpriteTrail(		// READY? GO!
		self.Entity,					// Entity
		nil,							// Attachment ID
		self.Color,						// Color
		false,							// Additive
		StartWidth,						// Starting width
		EndWidth,						// Ending width
		Length,							// Lifetime
		1/(StartWidth+EndWidth)*0.5,	// Texture resolution
		LaserTex..".vmt"				// Texture for the trail. Logic dictates these should be the other way around (texture, textureres) but noooo.
	)
	
	self:NextThink(CurTime()+0.1)
end


/*-------------------------------------------------------------------
	[ SetRadius ]
	Set the radius of the splash damage.
-------------------------------------------------------------------*/
function ENT:SetRadius(n) self.Radius = n end

/*-------------------------------------------------------------------
	[ SetDamage ]
	Set the damage of the splash damage.
-------------------------------------------------------------------*/
function ENT:SetDamage(n) self.Damage = n end

/*-------------------------------------------------------------------
	[ PhysicsUpdate ]
	This function does all the work - makes the rocket fly.
-------------------------------------------------------------------*/
function ENT:PhysicsUpdate(phys)
	local ply = self:GetOwner()
	if self:GetNWBool("Exploded") or not ply then return end
	
	phys:Wake()
	local tr = util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector()*8000,
		filter = {ply,self.Entity}
	})
	
	local ourpos = self.Entity:GetPos()
	local aimang = (tr.HitPos - ourpos):Angle()
	local newang = LerpAngle(0.1,self.Entity:GetAngles(),aimang)
	
	self.Entity:SetAngles(newang)
	phys:SetVelocity(self.Entity:GetForward() * 1000)


	// Here's the deal. PhysicsCollide is a slut about everything but world collisions.
	// Setting a collision box and solid doesn't seem to work.
	// Doing a trace in think (the far more efficient place to put it) fails because think isn't called fast enough.
	// So here it is. Inefficient, needless and annoying:
	local tr = util.TraceLine({
		start = self.Entity:GetPos(),
		endpos = self.Entity:GetPos() + self.Entity:GetForward()*16,
		filter = {self:GetOwner(),self.Entity}
	})
	
	if tr.Hit then self:Explode(tr) end
	
	// If I didn't have that trace, rockets would frequently bounce off players and hit an adjacent wall.
	// Worse case scenario, the rocket takes a tiki tour around the space around your target and you get 
	// shot. Best case scenario, the rocket goes into fucking orbit around the target.
end

/*-------------------------------------------------------------------
	[ PhysicsCollide ]
	Called when we hit something. Which is good.
-------------------------------------------------------------------*/
function ENT:PhysicsCollide(data,phys)
	if self:GetNWBool("Exploded") then return end
	
	self:Explode()
end

/*-------------------------------------------------------------------
	[ Explode ]
	Makes us go BEWM! :D
-------------------------------------------------------------------*/
function ENT:Explode()
	local phys,ply = self.Entity:GetPhysicsObject(),self:GetOwner()
	
	GAMEMODE:SplashDamage(ply,self.Entity:GetPos(),self.Radius,self.Damage,{self.Entity,self.Trail})
	
	local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		fx:SetMagnitude(4)
		fx:SetEntity(ply)
	util.Effect("ImpactExplode",fx,true,true)
	
	self.Entity:SetSolid(SOLID_NONE) // So we don't jam ourselves inside players and they get stuck. Bot23 is actually a girl now. Who knew?
	self.Entity:EmitSound("npc/scanner/cbot_energyexplosion1.wav",120,255) // Emit an explosion sound.
	self.Entity:SetNoDraw(true) // Hide the rocket.
	
	self.Sound:Stop()
	phys:EnableMotion(false)
	self:SetNWBool("Exploded",true)
	
	timer.Simple(3,function(self) // Delete after 3 seconds.
		if self and self:IsValid() then
			self:Remove()
		end
	end,self)
end

