WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "hexaprism"
 
WARE.CircleRadius = 0
WARE.HeightLimit = 0

WARE.CenterEntity = nil

function WARE:IsPlayable()
	if team.NumPlayers(TEAM_HUMANS) >= 2 then
		return true
	end
	return false
end

function WARE:Initialize()
	GAMEMODE:SetFailAwards( AWARD_VICTIM )
	self.LastThinkDo = 0
	
	GAMEMODE:RespawnAllPlayers( true, true )
	
	GAMEMODE:SetWareWindupAndLength(2, 6)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Don't contact!" )
	
	do
		local centerpos = GAMEMODE:GetEnts("center")[1]:GetPos()
		local apos      = GAMEMODE:GetEnts("land_a")[1]:GetPos()
		self.CircleRadius = (centerpos - apos):Length() - 24
		

		local effectdata = EffectData()
		effectdata:SetOrigin( centerpos )
		effectdata:SetStart( apos )
		effectdata:SetRadius( self.CircleRadius )
		effectdata:SetMagnitude( 15 )
		effectdata:SetAngle( Angle( 119, 199, 255 ) )
		effectdata:SetScale( 9 )
		util.Effect( "ware_prisma_harmonics", effectdata , true, true )
		
		self.CenterPos = centerpos
	end
	
end

function WARE:StartAction()	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "sware_rocketjump" )
	end
	return
end

function WARE:EndAction()

end

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		if v:IsWarePlayer() and not v:GetLocked() then
			local calctor = v:GetPos()
			local bactor  = self.CenterPos
			calctor.z = self.CenterPos.z
			
			if (calctor - bactor):Length() > self.CircleRadius then
				v:ApplyLose( )
				local dir = (self.CenterPos - v:GetPos() + Vector(0,0,100)):Normalize()
				v:SimulateDeath( dir * 100000 )
				v:EjectWeapons(dir * 300, 100)
				
				v:EmitSound("ambient/levels/labs/electric_explosion1.wav")
				
				local effectdata = EffectData( )
					effectdata:SetOrigin( v:GetPos() )
					effectdata:SetNormal( (v:GetPos() - self.CenterPos):Normalize() )
				util.Effect( "waveexplo", effectdata, true, true )
			end
		end
	end


end
