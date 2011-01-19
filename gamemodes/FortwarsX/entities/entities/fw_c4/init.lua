
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( "shared.lua" )
 
function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/w_c4_planted.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )  
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	local teamcol = team.GetColor( self.Entity:GetNWEntity( "Owner" ):Team() )
	self.Entity:SetColor( teamcol.r, teamcol.g, teamcol.b, 255 ) //Color == Team Color!
	
	local phys = self.Entity:GetPhysicsObject()
	if ( !ValidEntity( phys ) ) then return end

end

function ENT:OnTakeDamage( dmg )

	if ( dmg:GetDamage() >= 20 and dmg:GetInflictor() != self.Entity ) then
		if ( constraint.HasConstraints( self.Entity ) and dmg:GetDamage() <= 60 ) then
			constraint.RemoveAll( self.Entity )
			self.Entity:EmitSound( "physics/metal/metal_box_break2.wav" )
		else
			self:Dud()
		end
	end
	
	self.Entity:TakePhysicsDamage( dmg )

end
 
function ENT:Think()
	
	self.Entity:SetBlip( self.Entity:GetBlip() + 1 )
	
	local warn = false
	
	if ( self.Entity:GetBlip() == 1 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/nine.wav" )
	elseif ( self.Entity:GetBlip() == 2 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/eight.wav" )
	elseif ( self.Entity:GetBlip() == 3 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/seven.wav" )
	elseif ( self.Entity:GetBlip() == 4 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/six.wav" )
	elseif ( self.Entity:GetBlip() == 5 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/five.wav" )
	elseif ( self.Entity:GetBlip() == 6 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/four.wav" )
		warn = true
	elseif ( self.Entity:GetBlip() == 7 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/three.wav" )
		warn = true
	elseif ( self.Entity:GetBlip() == 8 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/two.wav" )
		self.Entity:EmitSound( "npc/attack_helicopter/aheli_charge_up.wav" )
		warn = true
	elseif ( self.Entity:GetBlip() == 9 ) then
		self.Entity:EmitSound( "npc/overwatch/radiovoice/one.wav" )
		self.Entity:EmitSound( "npc/overwatch/radiovoice/on3.wav" )
		warn = true
	elseif ( self.Entity:GetBlip() >= 10 ) then
		self:Explode()
		return
	end
	
	if ( warn ) then
		for _, v in pairs( ents.FindInSphere( self.Entity:GetPos(), 512 ) ) do
			if ( v:IsPlayer() and v:Alive() and self.Entity:GetNWEntity( "Owner" ):Team() != v:Team() ) then
				umsg.Start( "c4warn", v )
					umsg.Entity( self.Entity )
				umsg.End()
			end
		end
	end
	
	self.Entity:NextThink( CurTime() + 1 )
    return true // Note: You need to return true to override the default next think time

end

function ENT:Explode()

	local data = EffectData()
	data:SetOrigin( self.Entity:GetPos() )
	data:SetNormal( Vector( 0, 0, -1 ) )
	util.Effect( "Explosion", data )
	util.Effect( "c4_explode", data )
	
	self.Entity:EmitSound( "explode_" .. math.random( 1, 5 ) )
	self.Entity:Remove()
	
	local radius = 512
	
	util.BlastDamage( self.Entity, self.Entity:GetNWEntity( "Owner" ), self.Entity:GetPos(), radius, 500 ) //BOOM!
	util.ScreenShake( self.Entity:GetPos(), 50, 100, 1.5, radius * 2 )

end

function ENT:Dud()
	
	local efdata = EffectData()
	efdata:SetOrigin( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
	util.Effect( "c4_dud", efdata )

	self.Entity:EmitSound( "npc/scanner/cbot_discharge1.wav" ) //Phew...
	self.Entity:Remove()
	
end
 
function ENT:PhysicsUpdate( phys )
end