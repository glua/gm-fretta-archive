
//Server

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

 	self:SetModel( "models/props_lab/cactus.mdl" ) 
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

 	local phys = self:GetPhysicsObject()
 	if (phys:IsValid()) then
		phys:Sleep()
		phys:Wake() 
 	end
	
	self.CactusType = self.CactusType or "normal"
	self.PlayerObj = self.PlayerObj or nil
	self.Trail = self.Trail or nil
	self.IsSpamming = true
	
	local level = GAMEMODE:GetDifficulty()/5
	local speed = 1/(level)
	timer.Create("spamtimer_"..self:EntIndex(), speed, 0, self.Spam, self)
	
end

function ENT:OnTakeDamage( dmginfo )

 	self:TakePhysicsDamage( dmginfo )
	--GAMEMODE:CaughtCactus(dmginfo:GetAttacker(),self)
	
end

function ENT:StartTouch( ent )
	
	if !self:GetPlayerObj() then return end
	if ent:IsPlayer() and !ent:IsCactus() then
		local entdifficulty = self:GetCactusData().Difficulty
		local speed = self:GetVelocity():Length()
		if speed >= 100*entdifficulty*GAMEMODE:GetDifficulty() then
			local dmg = speed/100
			ent:TakeDamage( dmg, self:GetPlayerObj(), ent )
			print("lololol")
		end
		
	end

end

function ENT:Remove()
	
	if timer.IsTimer("spamtimer_"..self:EntIndex()) then
		timer.Destroy("spamtimer_"..self:EntIndex())
	end
	if timer.IsTimer("bombtick_"..self:EntIndex()) then
		timer.Destroy("bombtick_"..self:EntIndex())
	end
	SafeRemoveEntity(self.Trail)

end

function ENT:Think()

	if ValidEntity(self:GetPlayerObj()) then 
		if self:GetPlayerObj():IsPlayer() then
			GAMEMODE:PlayerCactusThink(self:GetPlayerObj())
		end
	end

end
/*
function ENT:Use(caller,ply)


end*/

