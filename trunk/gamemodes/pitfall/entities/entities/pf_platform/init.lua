AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
 
function ENT:Initialize()

	self:SetModel("models/blackops/pitfall/platform.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetColor( 0, 255, 0, 255 )
	
	local phys = self:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:EnableMotion( false )
		phys:Sleep()
	end
	
	self.MyHealth = 50

end

function ENT:OnRemove()
	local ed = EffectData()
			ed:SetEntity( Entity )
	util.Effect( "entity_remove", ed, true, true )
end

function ENT:OnTakeDamage( dmg )

	local attacker = dmg:GetAttacker()
	local damageamount = dmg:GetDamage()
	
	local living = #team.GetPlayers( TEAM_SURVIVORS )
	local dead = #team.GetPlayers( TEAM_SURVIVORS ) + #team.GetPlayers( TEAM_FALLEN )
	
	local percentalive = living/dead
	
	local dynamicdamage = ( damageamount/percentalive )
	
	--print( damageamount, percentalive, dynamicdamage )
	
	self.MyHealth = self.MyHealth - dynamicdamage
	
	local scale = math.Clamp( self.MyHealth / 50, 0, 1 )
	local r,g,b = (255 - scale * 255), (55 + scale * 200), (50)
	
	self:SetColor( r, g, b, 255 )
	
	if( self.MyHealth <= 0 ) then
	
		self.LastAttacker = attacker
		
		if !self.IsFalling then
			self.IsFalling = true
			self:SetMoveType( MOVETYPE_VPHYSICS )
			
			local phys = self:GetPhysicsObject()
			if ( phys:IsValid() ) then
				phys:EnableMotion( true ) 
				phys:Wake()
				phys:SetVelocity(Vector(0, 0, -600) )
			else
				print("Could not enable motion on entity")
			end
		end
	end
end

function ENT:GetCenter()
	return self:LocalToWorld( self:OBBCenter() )
end
 
function ENT:Think()
end
 
function ENT:PhysicsUpdate()
end

function ENT:Touch( hitEnt )
	if IsValid( hitEnt ) and hitEnt:IsPlayer() then
		hitEnt.LastPlatformTouched = self
	end
end

function ENT:EndTouch( hitEnt )
	if IsValid( hitEnt ) and hitEnt:IsPlayer() then
		hitEnt.LastPlatformTouched = self
	end
end