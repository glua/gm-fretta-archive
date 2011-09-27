
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
 
 
	self:SetModel("models/props_borealis/borealis_door001a.mdl")
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:StartMotionController()
	self.ShadowParams = {}
	
	self.mine = constraint.NoCollide(self, GetWorldEntity(), 0, 0)
 
end
function ENT:PhysicsSimulate( phys, deltatime )
 
	phys:Wake()
 
	self.ShadowParams.secondstoarrive = 0.00001 -- How long it takes to move to pos and rotate accordingly - only if it _could_ move as fast as it want - damping and max speed/angular will make this invalid (Cannot be 0! Will give errors if you do)
	self.ShadowParams.pos = self.pos -- Where you want to move to
	self.ShadowParams.angle = self.ang -- Angle you want to move to
	self.ShadowParams.maxangular = 50000000000000000000 --What should be the maximal angular force applied
	self.ShadowParams.maxangulardamp = 100 -- At which force/speed should it start damping the rotation
	self.ShadowParams.maxspeed = 10000000000000000000 -- Maximal linear force applied
	self.ShadowParams.maxspeeddamp = 100-- Maximal linear force/speed before  damping
	self.ShadowParams.dampfactor = 1 -- The percentage it should damp the linear/angular force if it reaches it's max amount
	self.ShadowParams.teleportdistance = 300 -- If it's further away than this it'll teleport (Set to 0 to not teleport)
	self.ShadowParams.deltatime = deltatime -- The deltatime it should use - just use the PhysicsSimulate one
 
	phys:ComputeShadowControl(self.ShadowParams)
 
end

function ENT:SetDestPos(pos)
	self.pos = pos
end

function ENT:SetDestAng(ang)
	self.ang = ang
end