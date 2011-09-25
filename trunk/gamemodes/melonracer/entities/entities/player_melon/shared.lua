 	
ENT.Type 		= "anim"

ENT.PrintName	= ""
ENT.Author		= ""
ENT.Contact		= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

AddCSLuaFile( "shared.lua" )

AccessorFunc( ENT, "m_pPlayer", 		"Player" )
AccessorFunc( ENT, "m_fJumpPower", 		"JumpPower" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	if ( SERVER ) then
		self:SetModel( "models/props_junk/watermelon01.mdl" )

		self:PrecacheGibs()
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		self:StartMotionController()
		
		self:SetJumpPower( 1 )
	end

end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Think()

	if ( SERVER ) then
	
		if ( !IsValid(self.m_pPlayer) ) then self:Remove() return end
	
		self:GetPhysicsObject():Wake()
	
		self.m_fJumpPower = math.Approach( self.m_fJumpPower, 1, 0.1 )
		
		// Shouldn't Observer mode automatically do this???
		self.m_pPlayer:SetPos( self:GetPos() )
	
	end

end

/*---------------------------------------------------------
   Name: Simulate
---------------------------------------------------------*/
function ENT:PhysicsSimulate( phys, deltatime )

	if ( !IsValid(self.m_pPlayer) ) then return SIM_NOTHING end

	local ply = self.m_pPlayer
	local vMove = Vector(0,0,0)
	local aEyes = ply:EyeAngles()
	
	if ( ply:KeyDown( IN_FORWARD ) ) then vMove = vMove + aEyes:Forward() end
	if ( ply:KeyDown( IN_BACK) ) then vMove = vMove - aEyes:Forward() end
	if ( ply:KeyDown( IN_MOVELEFT ) ) then vMove = vMove - aEyes:Right() end
	if ( ply:KeyDown( IN_MOVERIGHT ) ) then vMove = vMove + aEyes:Right() end
	
	vMove.z = 0;
	
	vMove:Normalize()
	vMove = vMove * 200000 * deltatime
	
	if ( ply:KeyDown( IN_JUMP ) ) then 
		local Speed = Vector( 0, 0, 6000 ) * deltatime
		self.m_fJumpPower = math.Approach( self.m_fJumpPower, 0, Speed.z * 0.001 )
		phys:AddVelocity( Speed * self.m_fJumpPower )
	end
	
	return Vector(0,0,0), vMove, SIM_GLOBAL_FORCE
	
end

/*---------------------------------------------------------
   Name: PhysicsCollide
   Desc: Called when physics collides. The table contains 
			data on the collision
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )

	if ( IsValid( data.HitEntity ) && data.HitEntity:GetClass() == "prop_physics" ) then
	
		data.HitEntity:Fire( "break", "", 0 )
		physobj:SetVelocityInstantaneous( data.OurOldVelocity )
	
	return end

	// How head on was the collide?
	local MoveDir = data.OurOldVelocity:Normalize()
	local Dot = MoveDir:Dot( data.HitNormal )
	if ( Dot < 0.3 ) then return end
	
	local HitSpeed = data.Speed * Dot
	
	if ( HitSpeed < 600 ) then return end
	
	self:GibBreakClient( data.OurOldVelocity )
	//self:GibBreakServer( data.OurOldVelocity )
	self:Remove()
	
	if ( IsValid(self.m_pPlayer) ) then
		self.m_pPlayer:Kill()
	end
				
end
