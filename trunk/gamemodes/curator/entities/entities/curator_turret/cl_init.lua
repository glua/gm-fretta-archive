include('shared.lua')

local bMat = Material( "cable/redlaser" )
local Red = Color( 255, 0, 0, 255 )

ENT.AutomaticFrameAdvance = true 

function ENT:Initialize()
	
	self.BaseClass.Initialize(self)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
end

function ENT:OnRemove()
	
end 

function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetNWBool("Active") then
		render.SetMaterial(bMat)
		
		local atm = self:LookupAttachment("eyes")
		local tbl = self:GetAttachment(atm)
		local tr = util.QuickTrace(tbl.Pos,tbl.Ang:Forward()*1000,self,MASK_SOLID_BRUSHONLY)
		self:SetRenderBoundsWS(tbl.Pos,tr.HitPos)
		render.DrawBeam( tbl.Pos, tr.HitPos, 5, 0, 0, Red )
	end
end 

local DownAmt = Vector(0,0,-10)

function ENT:Think() 
	if self:GetNWBool("Active") then
		if self:GetNWInt("FiringAt") > 0 then
			local atm = self:LookupAttachment("eyes")
			local tbl = self:GetAttachment(atm)
			local ply = player.GetByID(self:GetNWInt("FiringAt"))
			local possibleAng = self:WorldToLocal((ply:GetShootPos()+DownAmt)-tbl.Pos+self:GetPos()):Angle()
			
			possibleAng.y =math.wrap(possibleAng.y,-180,180)
			possibleAng.p =math.wrap(possibleAng.p,-180,180)
			
			self.Entity:SetPoseParameter( "aim_yaw", math.wrap(possibleAng.y,-60,60) )
			
			--local WhatWorked = (ply:GetShootPos()-tbl.Pos):Angle()+self:GetAngles()
			
			self.Entity:SetPoseParameter( "aim_pitch", math.Clamp(possibleAng.p,-15,15))
			local fire = self:LookupSequence("fire")
			self:SetSequence(fire)
		else
			local idle = self:LookupSequence("idle")
			self:ResetSequence(idle)
			
			self.Entity:SetPoseParameter( "aim_yaw", math.sin( CurTime() ) * self.degr )
			self.Entity:SetPoseParameter( "aim_pitch", 0 )
		end
	end
	self:NextThink(CurTime())
	return true
end 

function math.wrap(number,mins,maxs)
	if mins > maxs then mins,maxs = maxs,mins assert(not mins > maxs) end
	if mins == maxs then return maxs end
	if number > maxs or number < mins then
		return ((number - mins)  % (maxs - mins)) + mins
	else
		return number
	end
end 

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if LocalPlayer():GetNWBool("Curator") then
		RunConsoleCommand("CuratorUpdateEnt",self:EntIndex())
	end
	self.degr = math.Rad2Deg(math.atan(750/1000))
end 