AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 15 )
	ent:Spawn()
	ent:Activate()	
	
	return ent
end


function ENT:Initialize()	
	
	self:SetModel("models/Items/HealthKit.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = self:GetPhysicsObject()  	
	if phys:IsValid() then  		
		phys:Wake()  	
	end
	
	self.AmmoTypes = {
		[1] = "AR2",
		[4] = "SMG1",
		[3] = "Pistol",
		[5] = "357",
		[7] = "Buckshot",
		[6] = "XBowBolt",
		[10] = "Grenade",
		[8] = "RPG_Round",
		[20] = "AirboatGun",
	}
	
	self.AmmoInfo = {
		["AR2"] = {max = 150,inc=50},
		["SMG1"] = {max=180,inc=60},
		["Pistol"] = {max=90,inc=30},
		["357"] = {max=45,inc=15},
		["Buckshot"] = {max=50,inc=15},
		["XBowBolt"] = {max=35,inc=10},
		["Grenade"] = {max=6,inc=2},
		["RPG_Round"] = {max=6,inc=2},
		["Slam"] = {max=6,inc=2},
		["AirboatGun"] = {max=200,inc=50},
	}
	
	timer.Simple(20,function() if ValidEntity(self) then self:Remove() end end)
end

function ENT:SendAmmo(pl,ammo)
	
	local total = pl:GetAmmoCount(ammo)
	local ammo_table = self.AmmoInfo[ammo]
	
	if total >= ammo_table.max then return end
	
	pl:GiveAmmo(math.min(ammo_table.inc,ammo_table.max - total),ammo)

end	

function ENT:DoStuff( v )
	if v:IsPlayer() then
		for k,info in pairs(self.AmmoInfo) do
			self:SendAmmo( v, k )
			v:SetHealth( math.Clamp( v:Health() + 50,0,v:GetPlayerClass().MaxHealth) )
		end
		self:Remove()
	end
end

function ENT:Think()
	if self:GetMoveType() == MOVETYPE_NONE then
		self:SetAngles( self:GetAngles() + Angle(0,1.5,0) )
	end
	self:NextThink(CurTime())
	return true
end

function ENT:Touch( v )
	self:DoStuff(v)
end

function ENT:Use( v )
	self:DoStuff( v)
end

function ENT:PassesTriggerFilters( ent )
	return ent:IsPlayer()
end