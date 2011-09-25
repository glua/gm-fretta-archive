
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.DieTime = CurTime() + 1
	self.EffectTime = CurTime() + .01
	
	self:SetMoveType( MOVETYPE_NONE ) 
	self:SetSolid( SOLID_NONE )
	self:DrawShadow( false )
	
end

function ENT:Think()

	if self.DieTime < CurTime() then
		self.Entity:Remove()
	end
	
	if self.EffectTime and self.EffectTime < CurTime() then
	
		self.EffectTime = nil
		
		for i=1, table.Count( GAMEMODE.Gibs[ self.Gibs ] ) do
		
			local ed = EffectData()
			ed:SetEntity( self.Entity )
			ed:SetOrigin( self:GetPos() )
			ed:SetScale( i )
			util.Effect( "prop_gib", ed, true, true ) 
			
		end
		
	end
	
end

function ENT:SetGibs( name )
	self.Gibs = name
end

function ENT:OnTakeDamage( dmg )
	
end 

function ENT:PhysicsCollide( data, physobj )
	
end