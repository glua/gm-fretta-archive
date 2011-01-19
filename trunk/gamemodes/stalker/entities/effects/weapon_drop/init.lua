
EFFECT.Models = {}
EFFECT.Models[1] = Model( "models/weapons/w_pist_fiveseven.mdl" )
EFFECT.Models[2] = Model( "models/weapons/w_smg_p90.mdl" )
EFFECT.Models[3] = Model( "models/weapons/w_rif_sg552.mdl" )
EFFECT.Models[4] = Model( "models/weapons/w_rif_famas.mdl" )
EFFECT.Models[5] = Model( "models/weapons/w_shotgun.mdl" )

function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local ang = data:GetAngle()
	local modeltype = math.Clamp( ( data:GetScale() or 2 ), 2, 5 )

	self.Entity:SetPos( pos )
	self.Entity:SetAngles( ang )
	self.Entity:SetModel( self.Models[ modeltype ] or "models/weapons/w_pist_fiveseven.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:SetMass( 50 )
		phys:SetDamping( 0, 5 )
		phys:SetVelocity( VectorRand() * 100 )
		phys:AddAngleVelocity( Angle( math.random(-300,300), math.random(-300,300), math.random(-300,300) ) )
	
	end
	
	self.LifeTime = CurTime() + 10
	self.Alpha = 255
	
end

function EFFECT:Think( )
	
	if self.LifeTime < CurTime() then
	
		self.Alpha = ( self.Alpha or 255 ) - 2
		self.Entity:SetColor( 255, 255, 255, self.Alpha )
		
	end

	return self.Alpha > 2
	
end

function EFFECT:Render()

	self.Entity:DrawModel()

end

