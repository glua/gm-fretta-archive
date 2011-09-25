AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )

CTF_STOLEN = 1
CTF_RETURNED = 2
CTF_CAPTURED = 3
CTF_DROPPED = 4

ENT.TeamSounds = { Sound( "HL1/fvox/buzz.wav" ), 
Sound( "ui/buttonclick.wav" ),
Sound( "buttons/button19.wav" ),
Sound( "buttons/button15.wav" ) }  

ENT.EnemySounds = { Sound( "ambient/alarms/warningbell1.wav" ),
Sound( "buttons/button18.wav" ),
Sound( "buttons/button24.wav" ),
Sound( "HL1/fvox/fuzz.wav" ) }  

ENT.Team = 0
ENT.Bounds = 30
ENT.Size = 50

function ENT:Initialize()
	
	self.Entity:SetModel( "models/Roller.mdl" )

	self.Entity:SetSolid( SOLID_BBOX )
	self.Entity:PhysicsInitBox( Vector( -self.Size, -self.Size, -self.Size ), Vector( self.Size, self.Size, self.Size ) )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	
	self.Entity:SetCollisionBounds( Vector( -self.Bounds, -self.Bounds, -self.Bounds ), Vector( self.Bounds, self.Bounds, self.Bounds ) )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self.Entity:SetTrigger( true )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:SetMass( 9000 )
		phys:SetDamping( 100, 50000 )
	
	end
	
	self.LastAlivePos = self.Entity:GetPos()

end

function ENT:BroadcastSounds( soundtype )

	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() == self.Entity:GetTeam() then
		
			v:SendLua( "LocalPlayer():EmitSound( \""..self.TeamSounds[ soundtype ].."\" )" )
		
		else
		
			v:SendLua( "LocalPlayer():EmitSound( \""..self.EnemySounds[ soundtype ].."\" )" )
		
		end
	
	end

end

function ENT:AddFlagActionMessage( ply, action )

	local rp = RecipientFilter()
	rp:AddAllPlayers()
	
	umsg.Start( "PlayerFlagAction", rp )
		umsg.Entity( ply )
		umsg.Short( ply:Team() )
		umsg.Short( self.Entity:GetTeam() )
		umsg.String( action )
	umsg.End()
	
end

function ENT:AddFlagAutoMessage( action )

	local rp = RecipientFilter()
	rp:AddAllPlayers()
	
	umsg.Start( "PlayerFlagScoreReturn", rp )
		umsg.Short( self.Entity:GetTeam() )
		umsg.String( action )
	umsg.End()
	
end

function ENT:TimeOutReturn()

	self.Entity:BroadcastSounds( CTF_RETURNED )
	
	self.Entity:AddFlagAutoMessage( "returned" )
	self.Entity:SetColor( 255, 255, 255, 255 )
	self.Entity:PositionFlag()
	self.ReturnTime = nil
	
end

function ENT:FlagReturned( pl )

	self.Entity:BroadcastSounds( CTF_RETURNED )

	self.Entity:AddFlagActionMessage( pl, "has returned" )
	self.Entity:SetColor( 255, 255, 255, 255 )
	self.Entity:PositionFlag()	
	self.Carried = false
	self.ReturnTime = nil
	
end

function ENT:Score( t )

	self.Entity:BroadcastSounds( CTF_CAPTURED )

	self.Entity:AddFlagAutoMessage( "captured" )
	self.Entity:SetColor( 255, 255, 255, 255 )
	self.Entity:SetParent( NULL )
	self.Entity:SetOwner( NULL )
	self.Entity:PositionFlag()
	self.Carried = false
	
	team.AddScore( t, 1 )

end

function ENT:FlagStolen( pl )

	self.Entity:BroadcastSounds( CTF_STOLEN )

	self.Entity:AddFlagActionMessage( pl, "has stolen" )
	self.Entity:SetColor( 255, 255, 255, 0 )
	self.Carried = true
	self.ReturnTime = nil
	
end

function ENT:FlagDropped( pos )

	self.Entity:BroadcastSounds( CTF_DROPPED )

	self.Entity:AddFlagAutoMessage( "dropped" )
	self.Entity:SetColor( 255, 255, 255, 255 )
	self.Entity:SetParent( NULL )
	self.Entity:SetOwner( NULL )
	self.Entity:PositionFlag( pos, true )
	self.Carried = false
	self.ReturnTime = CurTime() + 20

end

function ENT:PositionFlag( start, noteleport )

	if noteleport then
	
		local pos = start + Vector(0,0,55)
		self.Entity:SetPos( pos )
		
		local phys = self.Entity:GetPhysicsObject()
		
		if ValidEntity( phys ) then
			
			phys:EnableMotion( true )
			phys:SetVelocityInstantaneous( Vector(0,0,0) )
			
		end
		
		return
	
	end

	if not start then
		start = self.SpawnPoint
	end

	local trace = {}
	trace.start = start
	trace.endpos = trace.start + Vector( 0, 0, -500 )
	
	local tr = util.TraceLine( trace )
	local pos = tr.HitPos + Vector( 0, 0, 50 )
	
	self.Entity:SetPos( pos )
	
end

function ENT:CanReturn()

	if self.SpawnPoint:Distance( self.Entity:GetPos() ) > 50 then
		return true
	end
	
	return false

end

function ENT:StartTouch( ent )

	if self.Carried then return end

	if ValidEntity( ent ) and ent:IsPlayer() and ent:Alive() then
	
		if ent:Team() == self.Entity:GetTeam() then
		
			if self.Entity:CanReturn() then
				
				self.Entity:FlagReturned( ent )
				
			end
		
		else
		
			self.Entity:SetPos( ent:GetPos() )
			self.Entity:SetParent( ent )
			self.Entity:SetOwner( ent )
			self.Entity:FlagStolen( ent )
			
			local phys = ent:GetPhysicsObject()
			
			if ValidEntity( phys ) then
				
				phys:EnableMotion( false )
				
			end
		
		end
	
	end
	
end

function ENT:Think()

	if self.Entity:GetPos().x != self.X then
	
		local pos = self.Entity:GetPos()
		pos.x = self.X
	
		self.Entity:SetPos( pos )
		
	end

	if self.Carried then
	
		if not ValidEntity( self.Entity:GetParent() ) or not self.Entity:GetParent():Alive() then
		
			self.Entity:FlagDropped( self.LastAlivePos )
		
		elseif ValidEntity( self.Entity:GetParent() ) and self.Entity:GetParent():Alive() then
		
			self.LastAlivePos = self.Entity:GetParent():GetPos()
		
		end
	
	end

	if not self.ReturnTime then return end
	
	if self.ReturnTime < CurTime() then
	
		self.Entity:TimeOutReturn()
	
	end

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS
	
end

function ENT:SetTeam( t )

	self.Entity:SetNWInt( "Team", t )
	
end

function ENT:GetTeam()

	return self.Entity:GetNWInt( "Team", TEAM_RED )

end

function ENT:SetSpawn( pos )

	self.SpawnPoint = pos
	
end

function ENT:SetX( xpos )

	self.X = xpos

end
