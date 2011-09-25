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
	
	self:SetType( 1 )
	self:SetSolid( SOLID_NONE )
	self:SetMoveType(MOVETYPE_NONE)
	self:Fire("setdamagefilter","0",0)

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
	
	self.Recharging = false
	self.RechargeTime = 12

end

function ENT:SetType( n )
	self.PickupType = n
	self:SetTrigger(true)
	
	if n == 1 then
		self:SetModel("models/Items/HealthKit.mdl")
		self:SetAngles( Angle( 60, 0, 0 ) )
		timer.Create(self.Entity:EntIndex().."angle",0.001,0,function()
			self.Entity:SetAngles( self:GetAngles() + Angle(0,2,0))
		end)
	elseif n == 2 then
		self:SetModel("models/items/boxsrounds.mdl")
		self:SetAngles( Angle( 30, 0, 0 ) )
		timer.Create(self.Entity:EntIndex().."angle",0.001,0,function()
			self.Entity:SetAngles( self:GetAngles() + Angle(0,2,0))
		end)
	end
end

function ENT:Think()
	if self.Recharging then return end

	for _,v in ipairs(ents.FindByClass("player")) do
		if v:GetPos():Distance(self:GetPos()) < 50 then
			if self.PickupType == 1 then
				local hp = v:Health()
				if hp < v:GetPlayerClass().MaxHealth then
					v:SetHealth(math.Clamp(hp + 30,0,v:GetPlayerClass().MaxHealth))
					v:EmitSound("items/smallmedkit1.wav")
					self.Entity:SetNoDraw(true)
					self.Recharging = true
					timer.Simple(self.RechargeTime,function()
						if !ValidEntity(self) then return end
						self.Entity:SetNoDraw(false)
						self.Recharging = false
					end)
				end
			elseif self.PickupType == 2 then
				local n = v:GetActiveWeapon():GetPrimaryAmmoType()
				if self.AmmoTypes[n] then self:SendAmmo(v,self.AmmoTypes[n])
				elseif v:GetActiveWeapon():GetClass() == "weapon_slam" then self:SendAmmo(v,"Slam")
				else return end
			end
			
		end
	end
end

function ENT:SendAmmo(pl,ammo)
	
	local total = pl:GetAmmoCount(ammo)
	local ammo_table = self.AmmoInfo[ammo]
	
	if total >= ammo_table.max then return end
	
	pl:GiveAmmo(math.min(ammo_table.inc,ammo_table.max - total),ammo)
	
	self.Recharging = true
	self:SetNoDraw(true)
	timer.Simple(self.RechargeTime,function()
		if !ValidEntity(self) then return end
		self:SetNoDraw(false)
		self.Recharging = false
	end)
end	

/*function ENT:Touch( v )
	print(" WHAT THE FUCK ")

	if self.Recharging then return end
	
	if v:IsPlayer() then
		
		if self.PickupType == 1 then
			local hp = v:Health()
			if hp < v:GetPlayerClass().MaxHealth then
				v:SetHealth(math.Clamp(hp + 30,0,v:GetPlayerClass().MaxHealth))
				v:EmitSound("items/smallmedkit1.wav")
				self.Entity:SetNoDraw(true)
				self.Recharging = true
				timer.Simple(self.RechargeTime,function()
					if !self.Entity then return end
					self.Entity:SetNoDraw(false)
					self.Recharging = false
				end)
			end
		elseif self.PickupType == 2 then
			local n = v:GetActiveWeapon():GetPrimaryAmmoType()
			if self.AmmoTypes[n] then v:GiveAmmo(45,self.AmmoTypes[n]) end
			self.Recharging = true
			self.Entity:SetNoDraw(true)
			timer.Simple(self.RechargeTime,function()
				if !self.Entity then return end
				self.Entity:SetNoDraw(false)
				self.Recharging = false
			end)
		end
	end
end*/

function ENT:PassesTriggerFilters( ent )
	return ent:IsPlayer()
end

function ENT:OnRemove()
	timer.Destroy(self.Entity:EntIndex().."angle")
end

