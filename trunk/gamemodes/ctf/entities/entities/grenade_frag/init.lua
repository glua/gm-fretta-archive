AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.ExplodeTime = 0;

function ENT:Initialize()
	
	self:SetModel("models/weapons/w_eq_fraggrenade_thrown.mdl");
	self:EmitSound( Sound( "Weapon_Grenade.Throw" ) );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local phys = self:GetPhysicsObject();
	if( phys:IsValid() ) then
		phys:Wake();
	end
	
end


function ENT:Think()

	if( CurTime() >= self.ExplodeTime ) then
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 300, 270 );
		
		local effectdata = EffectData();
		effectdata:SetStart( self:GetPos() );
		effectdata:SetOrigin( self:GetPos() );
		effectdata:SetScale( 1 );
		
		util.Effect( "Explosion", effectdata ); 
		self:Remove();
	end
		
end

function ENT:KeyValue( key, value )

	if( key == "timer" ) then
		self.ExplodeTime = CurTime() + tonumber( value ) - 1;
	end
end

function ENT:PhysicsCollide( data, physobj )

	local ent = data.HitEntity
	local entclass = ent:GetClass()

	if (data.Speed > 132 && data.DeltaTime > 0.21 ) then
		self.Entity:EmitSound("physics/metal/weapon_impact_soft" .. (math.random(1,2)) .. ".wav", 52, 100)
	end
	
	physobj:SetVelocity( physobj:GetVelocity() * 0.5 );

end 
