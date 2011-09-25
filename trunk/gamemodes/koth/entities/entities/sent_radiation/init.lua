AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:EnableCollisions( false )
		phys:Wake()
		
	end
	
	self.BurnTime = 0
	
end

function ENT:SetDamage( amt )

	self.Damage = amt
	self.Entity:SetNWInt( "Radius", amt * 10 )
	
end

function ENT:SetPlayer( ply )

	self.Player = ply
	self.Entity:SetNWEntity( "Target", ply )
	self.Entity:SetParent( ply )
	
	if not ply then return end
	
	self.Entity:SetPos( ply:GetPos() )

end

function ENT:Think()

	if ValidEntity( self.Player ) then
		if self.Player:IsPlayer() then
			if not self.Player:Alive() then
				self.Entity:SetPlayer()
			end
		end
	else
		self.Entity:SetPlayer()
	end
	
	if self.Damage < 5 then
		self.Entity:Remove()
	end
	
	if self.BurnTime < CurTime() then
	
		self.BurnTime = CurTime() + 0.2
		self.Damage = self.Damage - 2
		self.Entity:SetNWInt( "Radius", self.Damage * 10 )
		
		local tbl = player.GetAll()
		tbl = table.Add( tbl, ents.FindByClass( "sent_beacon" ) )
		
		for k,v in pairs(tbl) do
			if v:GetPos():Distance( self.Entity:GetPos()) < self.Damage * 10 and ( ( v:IsPlayer() and v:Alive() ) or not v:IsPlayer() ) then
				v:TakeDamage( 2, self.Entity:GetOwner(), self )
				v:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random(100,110) )
			end
		end
		
	end
end

function ENT:PhysicsCollide( data, phys )
		
end