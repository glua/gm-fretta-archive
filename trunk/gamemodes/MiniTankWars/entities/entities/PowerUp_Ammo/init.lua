 /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
PowerUp_Ammo init.lua
	-Ammo Powerup Entity serverside init
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	
	self.Entity:SetModel( "models/BMCha/MiniTanks/Powerups/Crate.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local chute = ents.Create( "Powerup_Chute" )
	chute:SetPos( self.Entity:GetPos() )
	chute:SetAngles(self.Entity:GetAngles())
	chute:Spawn()
	chute:SetParent(self.Entity)
	self.Entity.Chute=chute
	self.Entity.Dropping=true
	
	timer.Simple(300, function() if self.Entity then if self.Entity:IsValid() then self.Entity:Die() end end end)
end

function ENT:Think()
	if (self.Entity.Dropping==true) then
		local TD = util.QuickTrace(self.Entity:GetPos(), Vector(0,0,-64), {self.Entity, self.Entity.Chute})
		if (TD.HitWorld == true and self.Entity:GetVelocity().z < 10) then
			if (self.Entity.Chute:IsValid()) then
				self.Entity.Chute:Remove()
			end
			local card=ents.Create("PowerupCard")
			card:SetPos(self.Entity:GetPos())
			card:Spawn()
			card:SetParent(self.Entity)
			card:SetMaterial("MiniTankWars/Powerups/Ammo")
			self.Entity.Card=card
			self.Entity.Dropping=false
		end
		local phys = self.Entity:GetPhysicsObject()
		phys:ApplyForceCenter(Vector(0,0, 10000))
	end
end

function ENT:StartTouch( ent )
	if ent:IsValid() then
		if ent:IsValid() and ent.MyPlayer then
			ent.MyPlayer:GetActiveWeapon():SetClip1(ent.MyPlayer:GetActiveWeapon():Clip1()+25)
			ent.MyPlayer:ChatPrint("+25 Shells")
			self.Entity:Die()
		end
	end
end

function ENT:Die()
	SetGlobalInt("ActivePowerups",GetGlobalInt("ActivePowerups")-1)
	if (self.Entity.Chute:IsValid()) then
		self.Entity.Chute:Remove()
	end
	if (self.Entity.Card:IsValid()) then
		self.Entity.Card:Remove()
	end
	self.Entity:Remove()
end