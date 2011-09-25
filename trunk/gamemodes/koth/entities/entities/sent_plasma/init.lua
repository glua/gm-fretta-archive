AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.Damage = 40

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/items/crossbowrounds.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:StartMotionController()

	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:SetMass( 100 )
		phys:Wake()
	end
	
	self.PreExplode = Sound( "ambient/levels/citadel/portal_beam_shoot4.wav" ) 
	self.Trail = util.SpriteTrail( self.Entity, 0, Color(150,200,255,255), false, 2, 1, 0.20, 1 / 32 * 0.5, "trails/plasma.vmt" )
	self.ZapTime = 0
	
end

function ENT:Think()

	if self.ZapTime < CurTime() then 
	
		self.Entity:EmitSound( table.Random( GAMEMODE.QuietZap ), 100, math.random(90,110) )
		self.ZapTime = CurTime() + 0.2
		
	end
	
	if self.ExplodeTime and self.ExplodeTime < CurTime() then
	
		self.Entity:DoExplode()
		self.ExplodeTime = nil
	
	end
	
end

function ENT:PhysicsUpdate( phys, deltatime )

	phys:Wake()
	phys:SetVelocityInstantaneous( self.Entity:GetAngles():Forward():Normalize() * 2000 )
	phys:AddAngleVelocity( Angle( 0, 0.25, 0 ) ) // slowly arc
	
end

function ENT:DoFreeze()

	if self.Entity:GetNWBool( "Frozen", false ) then return end

	self.Entity:SetNWBool( "Frozen", true )
	self.ExplodeTime = CurTime() + 3
	
	self.Entity:EmitSound( self.PreExplode, 100, 110 )

end

function ENT:DoExplode()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "plasma_explode", ed )
	
	local pos = self.Entity:GetPos()
	local items = player.GetAll()
	table.Add( items, ents.FindByClass( "sent_beacon" ) )
	table.Add( items, ents.FindByClass( "prop_phys*" ) )

	for k,v in pairs( items ) do
		if v:GetPos():Distance( pos ) < 300 then
			v:TakeDamage( self.Damage, self.Entity:GetOwner(), self )
			if not v:IsPlayer() then
				local phys = v:GetPhysicsObject()
				if phys:IsValid() then
					v:SetPhysicsAttacker( self.Entity:GetOwner() )
					local dir = ( v:GetPos() - self.Entity:GetPos() ):Normalize()
					phys:ApplyForceCenter( dir * ( 1500 * ( phys:GetMass() / 2 ) ) )
				end
			end
		end
	end

	self.Entity:EmitSound( table.Random( GAMEMODE.PlasmaExplode ), 100, math.random(90,110) )
	self.Trail:Remove()
	self.Entity:Remove()
	
end

function ENT:PhysicsCollide( data, phys )

	if data.HitEntity:IsPlayer() then
	
		self.Entity:DoExplode()
		return
	
	end
	
	self.Entity:DoFreeze()
	phys:EnableMotion( false )
	
end


