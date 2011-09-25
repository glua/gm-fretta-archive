
include('shared.lua')

ENT.SpriteColor = Color( 50, 150, 50, 250 )
ENT.Model = "models/weapons/w_crowbar.mdl"

function ENT:Initialize()

	self.Model = Model( PickupTypes[ self.Entity:GetNWInt("PickupType",1) ].Model )
	self.Entity:SetModel( self.Model )
	
	self.Entity:SetCollisionBounds( Vector( -30, -30, -30 ), Vector( 30, 30, 0 ) )
	self.Entity:SetSolid( SOLID_NONE )
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-100)
	trace.filter = self.Entity
	local tr = util.TraceLine( trace )
	
	self.GroundPos = tr.HitPos
	self.Entity:SetPos( self.GroundPos + Vector(0,0,25) )
	
	self.Center = self.Entity:GetPos()
	
end

function ENT:Think()

	self.Model = Model( PickupTypes[ self.Entity:GetNWInt( "PickupType", 1 ) ].Model )
	self.Entity:SetModel( self.Model )

end

local PickupMat = Material( "effects/select_ring" )

function ENT:Draw( nodraw )

	if self.Entity:GetActiveTime() <= CurTime() then
		self.Entity:SetMaterial( "" )
		self.Entity:DrawModel()
	end
	
	self.Entity:SetModelScale( Vector( 1.1, 1.1, 1.1 ) ) //draw a glow over top
	self.Entity:SetMaterial( "models/props_combine/portalball001_sheet" )
	self.Entity:DrawModel()
	
	local ang = Angle( 0, TimedSin( 0.2, 0, 360, 0 ), 0 )
	self.Entity:SetAngles( ang )
	
	render.SetMaterial( PickupMat )
	render.DrawQuadEasy( self.GroundPos, Vector(0,0,1), 20, 20, self.SpriteColor )
	
end

function ENT:DrawTranslucent( nodraw )

	if nodraw then return end
	
	self.Entity:Draw()
	
end
