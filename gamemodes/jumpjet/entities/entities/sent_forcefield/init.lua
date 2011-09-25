AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.Radius = 150
ENT.Bound = 20
ENT.Damage = 5
ENT.ForceSound = Sound( "weapons/physcannon/energy_bounce2.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/Roller.mdl" )
	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionBounds( Vector( -self.Bound, -self.Bound, -self.Bound ), Vector( self.Bound, self.Bound, self.Bound ) )
	
	self.Entity:EmitSound( self.ForceSound, 100, 150 )
	
end

function ENT:Think() 

	if not ValidEntity( self.Entity:GetOwner() ) or not self.Entity:GetOwner():Alive() then
	
		self.Entity:Remove()
	
	end

	local tbl = ents.FindByClass( "sent_rpg" )
	table.Add( tbl, ents.FindByClass( "sent_m79" ) )
	table.Add( tbl, ents.FindByClass( "sent_plasmabomb" ) )
	table.Add( tbl, ents.FindByClass( "sent_knife" ) )
	table.Add( tbl, player.GetAll() )
	
	local pos = self.Entity:GetPos()
	
	for k,v in pairs( tbl ) do
	
		if v:GetPos():Distance( pos ) < self.Radius then
		
			local norm = ( v:GetPos() - pos ):Normalize()
		
			if v:IsPlayer() and v:Team() != self.Entity:GetOwner():Team() then
			
				v:SetVelocity( norm * 800 )
				v:TakeDamage( self.Damage, self.Entity:GetOwner(), self.Entity )
				v:EmitSound( self.ForceSound, 100, math.random(90,110) )
			
			elseif not v:IsPlayer() and v:GetOwner() != self.Entity:GetOwner() then
			
				local phys = v:GetPhysicsObject()
				
				if ValidEntity( phys ) and not v.m_bHitByForce then
				
					v:SetAngles( norm:Angle() )
					v:EmitSound( self.ForceSound, 100, math.random(90,110) )
					v.m_bHitByForce = true
					
					phys:SetVelocityInstantaneous( norm * 800 )
					
				end
			
			end
		
		end
	
	end

end
