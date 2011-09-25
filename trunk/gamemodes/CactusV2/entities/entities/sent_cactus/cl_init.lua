ENT.Spawnable			= true
ENT.AdminSpawnable		= true

include('shared.lua')

ENT.Glow = Material("sprites/light_glow02_add")

/*---------------------------------------------------------
   Name: Initialize
   Desc: First function called. Use to set up your entity
---------------------------------------------------------*/
function ENT:Initialize()
end

/*---------------------------------------------------------
   Name: Think
   Desc: Client Think - called every frame
---------------------------------------------------------*/
function ENT:Think()
end

/*---------------------------------------------------------
   Name: OnRestore
   Desc: Called immediately after a "load"
---------------------------------------------------------*/
function ENT:OnRestore()
end

function ENT:DrawOrbit(offset)
	local amount = 5
	local radius = 10
	local height = (30)/2
	if !self then return end
	local divisor = 360/amount
	for a=0,amount do
		local T = CurTime() + (divisor * a)
		local localpos = Vector(0,0,0)
		localpos.x = math.sin(T) * radius
		localpos.y = math.cos(T) * radius
		localpos.z = math.sin(T/100) * height
		--draw sprite at object:GetPos() + localpos
		render.SetMaterial( self.Glow )
		render.DrawSprite( self:LocalToWorld(self:GetPos()+localpos+offset), math.sin(5*FrameTime()), math.sin(5*FrameTime()), color_white)
	end
end

function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetCactusType() != nil and string.lower(self:GetCactusType()) == "golden" then
		print("lol")
		render.SetMaterial( self.Glow )
		render.DrawSprite( self:LocalToWorld(self:GetPos()+self:OBBCenter()), math.sin(16*FrameTime()), math.sin(16*FrameTime()), color_white)
		for i=0,3 do
			self:DrawOrbit(self:LocalToWorld(self:GetPos()+Vector(i+2,i-2,i*2)))
		end
	end
end
