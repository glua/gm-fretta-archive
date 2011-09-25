AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 1 )
	ent:Spawn()
	ent:Activate()	
	
	return ent

end


function ENT:Initialize()	

	self:SetModel( "models/devin/capturepoint.mdl" )
	self:SetSkin(0)
	
	self:PhysicsInit( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()  	
	if phys:IsValid() then  		
		phys:Wake()  	
	end
	
	self:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetNWInt("ta_progress",0)
	
	self.Progress = 0
	self.HasCapped = 0
	self.Locked = false
	self.Cooldown = 0
	self.CooldownTime = 15
	
	self:SetNWInt("ta_cooldown",self.Cooldown)

	/*self.BaseProp = ents.Create("prop_physics")
	self.BaseProp:SetPos(self:GetPos())
	self.BaseProp:SetModel("models/devin/capturepointglass.mdl")
	self.BaseProp:PhysicsInit( SOLID_VPHYSICS )
	self.BaseProp:Spawn()
	self.BaseProp:Activate()
	self.BaseProp:SetMoveType(MOVETYPE_NONE)*/
	
end


function ENT:Think()
	
	if self.Locked then return end
	if CurTime() - self.Cooldown < 0 then
		self:UpdateProgress(0)
		return
	end
	
	local on_point = {}
	local old_progress = self.Progress
	
	for _,v in ipairs(player.GetAll()) do
		
		if v:GetPos():Distance(self.Entity:GetPos()) < 175 and math.abs(v:GetPos().z - self.Entity:GetPos().z) < 100 and v:Alive() then 
		
			if v:Team() == 1 and self.Progress < 100 then
				
				
				self.Progress = math.Clamp(self.Progress + 0.7 + ( (v:GetNWString("Class") == "Runner" && 0.7) or 0 ) / 2,-100,100)
			
			
			elseif v:Team() == 2 and self.Progress > -100 then
					
				self.Progress = math.Clamp(self.Progress - 0.7 - ( (v:GetNWString("Class") == "Runner" && 0.7) or 0 ) / 2,-100,100)
				
			
			end
	
			if v:GetNWString("Class") == "Runner" then table.insert(on_point,v) end
			table.insert(on_point,v)
		end
		
	end
	
	local team1,team2 = false,false
	for _,v in ipairs(on_point) do
		if v:Team() == 1 then team1 = true
		elseif v:Team() == 2 then team2 = true
		end
	end
	
	if team1 and team2 then 
		self.Progress = old_progress
		/*umsg.Start("ta_SendProgress")
			umsg.Short(self.Entity:EntIndex())
			umsg.Short(self.Progress)
			umsg.Short(#on_point)
			umsg.String("Blocked!")
		umsg.End()*/
		self.Entity:SetNWInt("ta_progress",self.Progress)
		self.Entity:SetNWInt("ta_players",-1)
		return		
	end
	
	if self.Progress == 100 and self.HasCapped != 1 then 
		self.Entity:SetSkin(1)
		for k,v in ipairs(on_point) do if v:Team() != 1 then table.remove(on_point,k) end end
		self.Entity:SetNWInt("HasCapped",1)
		hook.Call("ta_capwon",nil,self.Entity,1,on_point)
		self.HasCapped = 1
		if GetGlobalString("ta_mode") == "bomb" then self.Locked = true
		elseif GAMEMODE.Mode == "capture" then self.Cooldown = CurTime() + self.CooldownTime end
	elseif self.Progress == -100 and self.HasCapped != 2 then 
		self.Entity:SetSkin(2) 
		for k,v in ipairs(on_point) do if v:Team() != 2 then table.remove(on_point,k) end end
		self.Entity:SetNWInt("HasCapped",2)
		hook.Call("ta_capwon",nil,self.Entity,2,on_point)
		self.HasCapped = 2
		if GetGlobalString("ta_mode") == "bomb" then self.Locked = true
		elseif GAMEMODE.Mode == "capture" then self.Cooldown = CurTime() + self.CooldownTime end
	end
	
	self:UpdateProgress(#on_point)
	
end


function ENT:UpdateProgress( numplayers )
	
	/* umsg.Start("ta_SendProgress")
		umsg.Short(self.Entity:EntIndex())
		umsg.Short(self.Progress)
		umsg.Short(numplayers)
		umsg.String("Not blocked!")
	umsg.End() */
	
	if self.Locked then self.Entity:SetNWInt("ta_players",-2) end
	
	self.Entity:SetNWInt("ta_progress",self.Progress)
	self.Entity:SetNWInt("ta_players",numplayers)
	self.Entity:SetNWInt("ta_cooldown",math.Clamp(math.ceil(self.Cooldown - CurTime()),0,self.CooldownTime))
	
end

function ENT:OnRemove()

end







