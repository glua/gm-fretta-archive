AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include('shared.lua')

ENT.PickUpDelay = 0

function ENT:Initialize()
	self.Entity:SetModel("models/oddball/oddball.mdl")
	util.PrecacheModel("models/oddball/oddball.mdl")

	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:SetTrigger(true)
	self.Entity:DrawShadow(true)

	local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.PickUpDelay = CurTime() + 1 --Set that pickup time, mainly for when it's getting dropped
end

function ENT:Touch(toucher)
	if toucher:IsValid() and toucher:IsPlayer() and toucher:Alive() and CurTime() >= self.PickUpDelay then --Delay the pick ups by a second so you don't instantly pick it up after drop
		toucher:SetNWBool("HasOddBall",true) --Mark them as having the ball
		toucher:DoThatConCommand("use weapon_oddball") --Switch to the oddball SWEP (Why is this before the give? Like I know, but it works.)
		toucher:Give("weapon_oddball") --Give them the oddball SWEP
		GAMEMODE:BallPickUp(toucher) --Play them sounds
		self:Remove()
	end
end