-- Flashbang Entity originally made by Cheesylard but modified by me. Cheesy, if you really don't appreciate what I take from you, just tell me, I'll remove this flash.

AddCSLuaFile( "shared.lua" )
include("shared.lua")

local FLASH_INTENSITY = 3000

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/w_eq_flashbang_thrown.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	
	-- Don't collide with the player
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetNetworkedString("Owner", "World")
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	timer.Simple(2,
	function()
		if self.Entity then 
			self:Explode() 
		end
	end)
end

/*---------------------------------------------------------
Explode
---------------------------------------------------------*/
function ENT:Explode()

	self.Entity:EmitSound(Sound("Flashbang.Explode"));

	for _,pl in pairs(player.GetAll()) do

		local ang = (self.Entity:GetPos() - pl:GetShootPos()):Normalize():Angle()

		local tracedata = {};

		tracedata.start = pl:GetShootPos();
		tracedata.endpos = self.Entity:GetPos();
		tracedata.filter = pl;
		local tr = util.TraceLine(tracedata);

		if (!tr.HitWorld) then
			local dist = pl:GetShootPos():Distance( self.Entity:GetPos() )  
			local endtime = FLASH_INTENSITY / (dist * 2);

			if (endtime > 6) then
				endtime = 6;
			elseif (endtime < 1) then
				endtime = 0;
			end

			simpendtime = math.floor(endtime);
			tenthendtime = math.floor((endtime - simpendtime) * 10);

--			if (pl:GetNetworkedFloat("FLASHED_END") > CurTime()) then
--				pl:SetNetworkedFloat("FLASHED_END", endtime + pl:GetNetworkedFloat("FLASHED_END") + CurTime() - pl:GetNetworkedFloat("FLASHED_START"));
--			else
				pl:SetNetworkedFloat("FLASHED_END", endtime + CurTime());
--			end

			pl:SetNetworkedFloat("FLASHED_END_START", CurTime());
		end
	end
	self.Entity:Remove();
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
end

/*---------------------------------------------------------
OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage()
end

/*---------------------------------------------------------
Use
---------------------------------------------------------*/
function ENT:Use()
end

/*---------------------------------------------------------
StartTouch
---------------------------------------------------------*/
function ENT:StartTouch()
end

/*---------------------------------------------------------
EndTouch
---------------------------------------------------------*/
function ENT:EndTouch()
end

/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch()
end