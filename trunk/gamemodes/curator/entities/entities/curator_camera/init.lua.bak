
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end

	self.FlashlightTexture = "effects/flashlight001"
	self:TemporarilyDisable()
end

--MiniTurret.Shoot

local red = Color(255,0,0,255)

function ENT:Think()
	if not self.LastPos then self.LastPos = self:GetPos() end
	if self.LastPos ~= self:GetPos() then --we've moved
		self.LastPos = self:GetPos()
		if self.flashlight then
			self.flashlight:SetAngles( self:GetAngles() )
			self.flashlight:SetPos(self:GetPos()+(self:GetAngles():Forward()*20))
		end
	end
	if self.Active == true then
		for k,v in ipairs(player.FindInCone(self:GetPos(),self:GetPos()+(self:GetAngles():Forward()*1000),500)) do
			--if v ~= GAMEMODE.Curator and self:Visible(v) and self:GetPos():Distance(v:GetPos()) <= 2000 then
			if v:IsPlayer() and v ~= GAMEMODE.Curator and self:Visible(v) then
				v:SetNWInt("Detection",math.Clamp(v:GetNWInt("Detection")+25,0,1000))
			end
		end
	end
	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:OnRemove()
	if self.Item and self.Item.OnRemove then self.Item:OnRemove() end
end
 
function ENT:ReActivate()
	self.Active = true
	self:EmitSound("HL1/fvox/activated.wav",SNDLVL_VOICE,100)
	print("Activated")
	
	local angForward = self.Entity:GetAngles()
	
	self.flashlight = ents.Create( "env_projectedtexture" )
	
		self.flashlight:SetParent( self.Entity )
		
		self.flashlight:SetLocalPos( Vector( 0, 0, 0 ) )
		self.flashlight:SetLocalAngles( Angle(90,90,90) )
		self.flashlight:SetAngles( self:GetAngles() )
		self.flashlight:SetPos(self:GetPos()+(self:GetAngles():Forward()*20))
		
		self.flashlight:SetKeyValue( "enableshadows", 0 )
		self.flashlight:SetKeyValue( "farz", 2048 )
		self.flashlight:SetKeyValue( "nearz", 8 )
		
		self.flashlight:SetKeyValue( "lightfov", 45 )

		self.flashlight:SetKeyValue( "lightcolor", "255 255 255" )
		
		
	self.flashlight:Spawn()
	
	self.flashlight:Input( "SpotlightTexture", NULL, NULL, self.FlashlightTexture )
end

function ENT:DeActivate()
	self.Active = false
	
	if ( self.flashlight ) then
		SafeRemoveEntity( self.flashlight )
		self.flashlight = nil
		return
	end
end 

function ENT:TemporarilyDisable(num)
	self:DeActivate()
	self.timer = timer.Create(self:EntIndex().."Reenable",num or 5,1,function() self:ReActivate() end)
end 