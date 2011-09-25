local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:IsBreen()
	if( GetGlobalEntity( "Breen" ) and self == GetGlobalEntity( "Breen" ) ) then
		return true;
	end
	
	return false;
end

function meta:CheckPlayerClassOnSpawn()

	if( self:IsBreen() ) then return end
	
	local Classes = team.GetClass( self:Team() )

	// The player has requested to spawn as a new class
	
	if ( self.m_SpawnAsClass ) then

		self:SetPlayerClass( self.m_SpawnAsClass )
		self.m_SpawnAsClass = nil
		
	end
	
	// Make sure the player isn't using the wrong class
	
	if ( Classes && #Classes > 0 && !table.HasValue( Classes, self:GetPlayerClassName() ) ) then
		self:SetRandomClass()
	end
	
	// If the player is on a team with only one class, 
	// make sure we're that one when we spawn.
	
	if ( Classes && #Classes == 1 ) then
		self:SetPlayerClass( Classes[1] )
	end
	
	// No defined classes, use default class
	
	if ( !Classes || #Classes == 0 ) then
		self:SetPlayerClass( "Default" )
	end

end

//
// Your head spazzes out when you get headshotted - Old CS style
//
function meta:HeadshotAngles()

	self.HeadShotStart = self.HeadShotStart or 0
	self.HeadShotRoll = self.HeadShotRoll or 0
	
	self.HeadShotRoll = math.Approach( self.HeadShotRoll, 0.0, 40.0 * FrameTime() )
	local roll = self.HeadShotRoll
	
	local Time = (CurTime() - self.HeadShotStart) * 10
	
	return Angle( math.sin( Time ) * roll * 0.5, 0, math.sin( Time * 2 ) * roll * -1 )

end


//
// Your head spazzes out when you get headshotted - Old CS style
//
function meta:ShootShakeAngles()

	self.LastShoot = self.LastShoot or 0
	if ( self.LastShoot <= 0 ) then return Angle(0,0,0) end
	
	self.LastShoot = self.LastShoot - FrameTime()

	return Angle( math.sin( CurTime() * 8 * self.LastShootSize ) * self.LastShoot, math.cos( CurTime() * 9 * self.LastShootSize ) * self.LastShoot, math.sin( CurTime() * 7 * self.LastShootSize ) * self.LastShoot )

end
