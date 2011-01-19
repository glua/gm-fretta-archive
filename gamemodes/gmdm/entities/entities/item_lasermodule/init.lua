
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local sndOnline = Sound( "hl1/fvox/activated.wav" )

ENT.InitEntity = nil

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self:DrawShadow( false )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetTrigger( true )
	
	-- below saves the entity we hit when this is activated and is ignored by the trigger
	local trace = {}
		trace.start = self:GetPos()
		trace.endpos = self:GetEndPos()
		trace.filter = { self, self:GetOwner() }
		
	local tr = util.TraceLine( trace )
	
	if( tr.Hit and tr.Entity ) then
		self.InitEntity = tr.Entity;
	end
	
	
end

function ENT:Think()

	if ( self:GetActiveTime() == 0 || self:GetActiveTime() > CurTime() ) then return end
	if ( self.Activated ) then return end
	
	self.Activated = true
	self:GetOwner():EmitSound( sndOnline )

end


function ENT:Touch( entity )

	// Is the laser touching?
	local trace = {}
		trace.start = self:GetPos()
		trace.endpos = self:GetPos()+(self:GetAngles()*1024)
	if( self.InitEntity and self.InitEntity:IsValid() ) then
		trace.filter = { self, self:GetOwner(), self.InitEntity }
	else
		trace.filter = { self, self:GetOwner() }
	end
	
	local tr = util.TraceLine( trace )
	


end

