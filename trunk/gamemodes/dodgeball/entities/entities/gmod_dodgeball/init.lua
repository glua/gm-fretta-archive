//Incase you have no idea the dodgeball is based off of the bouncy ball

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	// Use the helibomb model just for the shadow (because it's about the same size)
	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
	
	// Don't use the model's physics - create a sphere instead
	self.Entity:PhysicsInitSphere( 16, "metal_bouncy" )
	
	// Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	// Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	phys:EnableGravity( false ) //We're going to make our own gravity below cause we're cool
end

function ENT:PhysicsUpdate( phys )
	vel = Vector( 0, 0, ( ( -9.81 * phys:GetMass() ) * 0.65 ) )
	phys:ApplyForceCenter( vel )
end 

/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
	
	if self.Entity.Punter then  --If it's a player or map object
		if data.HitEntity:IsPlayer() then --The ball hit a player
			if data.HitEntity:Team() != self.Entity.Punter:Team() then --Differant teams
				data.HitEntity:Jail( self.Entity.Punter ) -- jail
				self.Entity.kills = self.Entity.kills or 0
				self.Entity.kills = self.Entity.kills + 1
				if self.Entity.kills == 2 then
					player_pup.Obtain( self.Entity.Punter, "jailbreak" )
					GAMEMODE:Alert( self.Entity.Punter:Name() .. " got a double kill, JAILBREAK!" )
				elseif self.Entity.kills == 3 then
					player_pup.Obtain( self.Entity.Punter, "speed" )
					player_pup.Obtain( self.Entity.Punter, "jump" )
					player_pup.Obtain( self.Entity.Punter, "point" )
					GAMEMODE:Alert( self.Entity.Punter:Name() .. " got a triple kill!!" )
				end
				if self.Entity.NoGrabPunt then
					player_pup.Obtain( self.Entity.Punter, "jump" )
					player_pup.Obtain( self.Entity.Punter, "point" )
					GAMEMODE:Alert( self.Entity.Punter:Name() .. " did a no-grab punt kill on " .. data.HitEntity:Name() )
				end
				if self.Entity.wallkill then
					player_pup.Obtain( self.Entity.Punter, "speed" )
					player_pup.Obtain( self.Entity.Punter, "jump" )
					GAMEMODE:Alert( self.Entity.Punter:Name() .. " killed " .. data.HitEntity:Name() .. " off the wall" )
				end
			elseif data.HitEntity.frozen then
				player_pup.EndPup(pl, name)
				player_pup.Obtain( self.Entity.Punter, "speed" )
			end
		else --Didn't hit the player, note this isn't called when it hits the player (allows for double bounce kills)
			if data.HitNormal.y > 0.6 or data.HitNormal.z > 0.6 then --Hit the roof or walls!
				self.Entity.wallkill = true
			else
				self.Entity.kills = 0
				self.Entity.wallkill = false
				self.Entity.Punter = nil --Nothing epic happened, no longer active
			end
		end
		self.Entity.NoGrabPunt = false --Don't allow double punt kills even though its cool
	end
	
	if (data.Speed > 70 ) then
		self.Entity:EmitSound( "Rubber.BulletImpact" )
	end
	
	// Bounce like a crazy bitch
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * 0.6
	
	physobj:SetVelocity( TargetVelocity )
end

