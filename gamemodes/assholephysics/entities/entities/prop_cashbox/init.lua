
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetColor( 100, 255, 100, 255 )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		
		phys:Wake()
		
	end
	
	self.HealthAmount = 20
	self.BreakSound = Sound( "Wood_Solid.Break" )
	self.HitSound = Sound( "Wood.BulletImpact" )
	self.BounceSound = Sound( "Wood.ImpactHard" )
	self.Gibs = "cashcrate"
	
end

function ENT:Think()
	
end
 
function ENT:DropCash()

	self.Entity:EmitSound( self.BreakSound, 100, math.random(90,110) )
	
	for i=1, 20 do
	
		local cash = ents.Create( "sent_cash" )
		cash:SetPos( self.Entity:GetPos() )
		cash:Spawn()
		
	end
	
	local handler = ents.Create( "gib_handler" )
	handler:SetPos( self.Entity:GetPos() )
	handler:SetAngles( self.Entity:GetAngles() )
	handler:SetModel( self.Entity:GetModel() )
	handler:SetGibs( self.Gibs )
	handler:Spawn()
	
	self.Entity:Remove()
	
end
 
function ENT:OnTakeDamage( dmg )

	dmg:ScaleDamage( 0 )
	
	if dmg:GetAttacker():IsPlayer() then
	
		self.HealthAmount = self.HealthAmount - 1
		self.Entity:EmitSound( self.HitSound, 100, math.random(90,110) )
		
		if self.HealthAmount < 1 then
			self.Entity:DropCash()
		end
	
	end
	
end

function ENT:PhysicsCollide( data, phys )

	if ( data.Speed > 50 && data.DeltaTime > 0.1 ) then
	
		self.Entity:EmitSound( self.BounceSound, 100, math.random(90,110) )
		
	end

end
