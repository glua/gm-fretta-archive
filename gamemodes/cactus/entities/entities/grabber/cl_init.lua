ENT.Spawnable			= true
ENT.AdminSpawnable		= true

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
   Desc: First function called. Use to set up your entity
---------------------------------------------------------*/
function ENT:Initialize()
end

function ENT:Draw()

	self:DrawModel()
	
	local speed = 90
	
	if ValidEntity(self) then
		
		self:SetModelScale( Vector( ) * 4 )
		
		self.Rotations = self.Rotations or Angle( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) )
		
		self:SetAngles( self:GetAngles( ) + self.Rotations * ( FrameTime( ) * speed ) )
		
	end
	
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
