AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include('shared.lua')

--ENT.Pos = nil
ENT.Radius = 128
ENT.SpawnPoints = {}

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_NONE)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_NONE)
	self.Entity:DrawShadow(false)
end

function ENT:AddTelePos(vec)
	--self.Pos = vec
	table.insert( self.SpawnPoints, vec )
end

function ENT:SetTeleRadius(num)
	self.Radius = num
end

function ENT:Think()
	for i,v in ipairs(ents.FindInSphere( self:GetPos() + (self:GetUp() * 20), self.Radius )) do
		if (v!=self and v:IsPlayer() and v:Alive() and v:Team() == TEAM_BLUE and v:GetNWBool("JustDTeled",false) == false) then
			--v:SetNWInt("Drun_Wins",v:GetNWInt("Drun_Wins",0)+1)
			
			GAMEMODE:GiveWin( v )
			
			v:Give("weapon_smg1")
			v:Give("weapon_crowbar")
			v:Give("item_box_mrounds")
			v:Give("item_box_mrounds")
			v:Give("item_box_mrounds")
			v:Give("item_box_mrounds")
			
			if self.SpawnPoints and #self.SpawnPoints >= 1 then
				v:SetPos(table.Random(self.SpawnPoints) or self.SpawnPoints[1])
			end
			
			v:SetNWBool("JustDTeled",true)
			v:SetNWBool("TakeFallDamage",false)
			timer.Simple(3, function()
				if v and v:IsValid() then
					v:SetNWBool("TakeFallDamage",true)
				end		
			end)
		end
	end
	
	self:NextThink(CurTime())

	return true
end

