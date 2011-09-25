
function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local model = table.Random( GAMEMODE.CrateGibs ) 
	
	self.Entity:SetPos( pos )
	self.Entity:SetModel( model )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	self.Entity:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		local vec = VectorRand()
		vec.x = math.Clamp( vec.x, -1.0, -0.2 )
		vec.z = math.Clamp( vec.z, 0.2, 0.8 )
	
		phys:Wake()
		phys:SetMass( 100 )
		phys:AddAngleVelocity( Angle( math.random(-200,200), math.random(-200,200), math.random(-200,200) ) )
		phys:SetVelocity( vec * math.Rand( 400, 800 ) )
	
	end
	
	self.LifeTime = CurTime() + 10
	
end

function EFFECT:Think( )

	return self.LifeTime > CurTime()
	
end

function EFFECT:Render()

	self.Entity:DrawModel()

end

