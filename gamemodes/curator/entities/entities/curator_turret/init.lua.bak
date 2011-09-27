
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:PhysicsInit(SOLID_NONE)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end
	
	self:TemporarilyDisable()

end

local DownAmt = Vector(0,0,-10)

function ENT:Think()
	if self.Active then
		local radius = 750
		local distance = 1000
		local ply
		local plaeyerz = player.FindInCone(self:EyePos(),self:EyePos()+(self:GetAngles():Forward()*distance),radius)
		for k,v in ipairs(plaeyerz) do
			if v:Alive() and v:IsValid() and v ~= GAMEMODE.Curator and v:Visible(self) then
				if not ply then
					ply = v
				elseif self:EyePos():Distance(v:GetPos()) > self:EyePos():Distance(ply:GetPos()) then
					ply = v
				end
			end
		end
		if ply and ply ~= nil and ply:IsValid() then
		
			local atm = self:LookupAttachment("eyes")
			local att = self:GetAttachment(atm)
			
			local tbl = {}
			tbl.Num = math.random(1,2)
			tbl.Src = att.Pos
			tbl.Dir = ((ply:GetShootPos()+DownAmt)-att.Pos):Normalize()
			tbl.Spread=Vector(0.05,0.05,0)
			tbl.Tracer=1	
			tbl.Force = 4
			tbl.Damage = 4
			tbl.Attacker = GAMEMODE.Curator
			tbl.TracerName = "GunshipTracer" --it's larger this way.
			self:FireBullets(tbl)
			self:EmitSound("MiniTurret.Shoot",SNDLVL_GUNFIRE,100)
			self:SetNWInt("FiringAt",ply:EntIndex())
		else
			self:SetNWInt("FiringAt",-1)
		end

		if not timer.IsTimer(self:EntIndex().."BeepSound") then timer.Create(self:EntIndex().."BeepSound",SoundDuration("NPC_Turret.Ping")*8,0,function() self:EmitSound("NPC_Turret.Ping", SNDLVL_VOICE, 100) end) end
	else
		timer.Remove(self:EntIndex().."BeepSound")
	end
end

function ENT:OnRemove()
	timer.Remove(self:EntIndex().."BeepSound")
	if self.Item and self.Item.OnRemove then self.Item:OnRemove() end
end
 
function ENT:ReActivate()
	self.Active = true
	self:EmitSound("HL1/fvox/activated.wav",SNDLVL_VOICE,100)
	self:SetNWBool("Active",true)
end

function ENT:DeActivate()
	self.Active = false
	self:SetNWBool("Active",false)
end 

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:TemporarilyDisable(num)
	self:DeActivate()
	self.timer = timer.Create(self:EntIndex().."Reenable",num or 5,1,function() self:ReActivate() end)
end 