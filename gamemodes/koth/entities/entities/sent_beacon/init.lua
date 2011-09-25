AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

util.PrecacheModel( "models/weapons/w_stunbaton.mdl" )

ENT.Explode = Sound( "npc/scanner/scanner_explode_crash2.wav" )
ENT.Stick = Sound( "physics/metal/sawblade_stick1.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/w_stunbaton.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS ) 
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	
	self.Entity:PhysicsInitSphere( 1 )
	self.Entity:SetCollisionBounds( Vector( -5, -5, -5 ), Vector( 5, 5, 5 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:SetMass( 200 )
		phys:Wake()
	end
	
	self.Entity:StartMotionController()
	
	self.Trail = util.SpriteTrail( self, 0, Color(200,200,255,200), false, 2, 1, 0.20, 1 / 32 * 0.5, "trails/plasma.vmt" )
	self.ZapTime = 0
	
end

function ENT:DrawBeams( ent1, ent2 )

	ent2:EmitSound( table.Random( GAMEMODE.SmallZap ), 100, math.random(90,110) )
	
	local target = ents.Create( "info_target" )
	target:SetPos( ent1:LocalToWorld( ent1:OBBCenter() ) )
	target:SetParent( ent1 )
	target:SetName( tostring( ent1 )..math.random(1,900) )
	target:Spawn()
	target:Activate()
	
	local target2 = ents.Create( "info_target" )
	target2:SetPos( ent2:LocalToWorld( ent2:OBBCenter() ) )
	target2:SetParent( ent2 )
	target2:SetName( tostring( ent2 )..math.random(1,900) )
	target2:Spawn()
	target2:Activate()
	
	local laser = ents.Create( "env_beam" )
	laser:SetPos( ent1:GetPos() )
	laser:SetKeyValue( "spawnflags", "1" )
	laser:SetKeyValue( "rendercolor", "200 200 255" )
	laser:SetKeyValue( "texture", "sprites/laserbeam.spr" )
	laser:SetKeyValue( "TextureScroll", "1" )
	laser:SetKeyValue( "damage", "0" )
	laser:SetKeyValue( "renderfx", "6" )
	laser:SetKeyValue( "NoiseAmplitude", ""..math.random(5,15) )
	laser:SetKeyValue( "BoltWidth", "1" )
	laser:SetKeyValue( "TouchType", "0" )
	laser:SetKeyValue( "LightningStart", target:GetName())
	laser:SetKeyValue( "LightningEnd", target2:GetName())
	laser:SetOwner( self.Entity:GetOwner() )
	laser:Spawn()
	laser:Activate()
	
	laser:Fire("kill","",0.2)
	target:Fire("kill","",0.2)
	target2:Fire("kill","",0.2)

end 

function ENT:Think()

	if self.ZapTime < CurTime() and self.Entity:GetNWBool( "Frozen", false ) then
	
		self.ZapTime = CurTime() + math.random(5,20)
		
		for	k,v in pairs( ents.FindByClass( "sent_beacon" ) ) do
			if v != self.Entity and v:GetPos():Distance( self.Entity:GetPos() ) < 150 then
				if math.random(1,50) == 1 then
				
					self.Entity:DrawBeams( self.Entity, v )
					self.Entity:DoExplode()
					return
				
				end
				if math.random(1,25) == 1 then
				
					self.Entity:DrawBeams( self.Entity, v )
				
				end
			end
		end
	end
end

function ENT:PhysicsUpdate( phys, deltatime )

	phys:Wake()
	phys:SetVelocityInstantaneous( self.Entity:GetAngles():Forward():Normalize() * 800 )
	phys:AddAngleVelocity( Angle( 0, 0.5, 0 ) ) // slowly arc
	
end

function ENT:DoExplode()

	local pos = self.Entity:GetPos()

	local ed = EffectData()
	ed:SetOrigin( pos )
	util.Effect( "beacon_explode", ed )

	for k,v in pairs( player.GetAll() ) do
		if v:GetPos():Distance( pos ) < 100 then
			v:TakeDamage( math.random(5,20), self.Entity:GetOwner(), self.Entity )
		end
	end

	self.Entity:EmitSound( self.Explode, 100, math.random(110,130) )
	
	self.Trail:Remove()
	self.Entity:Remove()
	
end

function ENT:OnTakeDamage( dmginfo )

	if dmginfo:GetInflictor():GetClass() == "sent_tesla" then return end

	self.Entity:DoExplode()
	
end

function ENT:PhysicsCollide( data, phys )

	if ( data.HitEntity:IsPlayer() or string.find( data.HitEntity:GetClass(), "prop" ) ) and not self.Entity:GetNWBool( "Frozen", false ) then
	
		self.Entity:DoExplode()
		return
	
	end
	
	self.Entity:EmitSound( self.Stick, 100, math.random(100,120) )
	self.Entity:SetNWBool( "Frozen", true )
	phys:EnableMotion( false )
	
end

