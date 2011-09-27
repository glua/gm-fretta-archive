AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
    self.Entity:SetModel( "models/mhs/cw_crate/cw_crate.mdl" )
    self.Entity:PhysicsInitBox( Vector(-26,-26,-26), Vector(26,26,26) )
    self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
    self.Entity:SetSolid( SOLID_VPHYSICS )
    self.Entity:SetCollisionBounds( Vector(-26,-26,-26), Vector(26,26,26) )
    local physobj = self.Entity:GetPhysicsObject()
    physobj:EnableMotion(false)
	self.Entity.PropHealth = 100
	
	local entsInSpawn = ents.FindInBox( Vector(-24,-24,-24) + self.Entity:GetPos(), Vector(24,24,24)+ self.Entity:GetPos() )
    if table.Count(entsInSpawn) > 0 then
		local once = true
        for k,v in pairs(entsInSpawn) do
            if (v:IsPlayer()) or (v:GetClass() == "func_nobuild") or (v:GetClass() == "trigger_capture_area") or (v:GetClass() == "cw_flag") then
				if(once) then
					local oply = self.Entity:GetNWEntity("OwnerObj")
					oply.points = oply.points + 1
					GAMEMODE:addStat(oply, "placed", -1)
					self.Entity:Remove()
					once = false
				end
            end
        end
    end
end
 
 
function ENT:OnTakeDamage(dmg)
	local r,g,b,a = self.Entity:GetColor();
	if(g > 0)then
		return
	end
	if(b > 0)then
		b = b-((dmg:GetDamage()/100)*255)
	end
	if(r > 0)then
		r = r-((dmg:GetDamage()/100)*255)
	end
	if(self.Entity.PropHealth <= 0) then return end
	self.Entity.PropHealth = self.Entity.PropHealth - dmg:GetDamage()
	if(self.Entity.PropHealth <= 0) then
		self.Entity:Remove()
		GAMEMODE:addStat(dmg:GetInflictor(), "broken", 1)
	end
	self.Entity:SetColor(r, g, b, 255)
end