
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

GM.GlassHit = {"physics/glass/glass_impact_bullet1.wav",
"physics/glass/glass_impact_bullet2.wav",
"physics/glass/glass_impact_bullet3.wav",
"physics/glass/glass_impact_bullet4.wav"}

GM.GlassBreak = {"physics/glass/glass_largesheet_break1.wav",
"physics/glass/glass_largesheet_break2.wav",
"physics/glass/glass_largesheet_break3.wav",
"physics/glass/glass_sheet_break1.wav",
"physics/glass/glass_sheet_break2.wav",
"physics/glass/glass_sheet_break3.wav"}

function meta:IsJailed()
	return self.jailed
end

function meta:OpposingTeam()
	if self:Team() == 1 then
		return 2
	elseif self:Team() == 2 then
		return 1
	end
end

function meta:PutInPlayer( jail )
	self.jailed = jail
	
	if self:Team() == 1 or self:Team() == 2 then
		self:UnSpectate() //Make sure he isn't in spec mode
		self:Spawn() //This is required for unspectating for some reason
	else
		self:Spectate( OBS_MODE_ROAMING )
	end
	
	local spawn = self:GetSpawn( )
	self:SnapEyeAngles( spawn:GetAngles() )
	self:SetPos( spawn:GetPos() )
	
	player_pup.EndPlayer( self )
end

function meta:GetSpawn( )
	local dteam = self:Team() //Localized variables read faster, this variable is called a lot
	GAMEMODE:PlayerLoadout( self ) //Let the player have his weapon/take weapon
	if dteam == 1 or dteam == 2 then //red or blue
		if self:IsJailed() then
			return table.Random( GAMEMODE.Spawns[dteam].jail )
		else
			return table.Random( GAMEMODE.Spawns[dteam].play )
		end
	end
	self:Spectate( OBS_MODE_ROAMING )
	return table.Random( GAMEMODE.Spawns[TEAM_SPECTATOR] )
end

function meta:Thaw( playsounds )

	if not self:IsFrozen() then return end
	
	self:SetMaterial(self.OriginalMaterial)
	self:Freeze(false)
	self:SetColor(255,255,255,255)
	self:SetNetworkedBool("Frozen",false)
	
	local rp = RecipientFilter()
	rp:AddPlayer( self )
	
	umsg.Start( "DBFreeze", rp )
		umsg.Bool( false )
	umsg.End( )
	
	if playsounds then
	
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect( "ice_break", ed, true, true )
		
		self:EmitSound(table.Random(GAMEMODE.GlassBreak),100,math.random(90,110))
		
	end
	
end


function meta:IceFreeze() //Rambo!

	self:Freeze(true)
	self.OriginalMaterial = self:GetMaterial()
	self:SetMaterial("ice")
	self:SetNetworkedBool("Frozen",true)
	
	self:EmitSound(table.Random(GAMEMODE.GlassHit),100,math.random(90,110))
	
	local col = team.GetColor(self:Team())
	self:SetColor(math.Max(col.r,150),math.Max(col.g,150),math.Max(col.b,150),255)
	
	self:ChatPrint("The ball you threw was caught (this makes you FREEZE!!)") //Make sure they see this before they say wtf
	
	local rp = RecipientFilter()
	rp:AddPlayer( self )
	
	umsg.Start( "DBFreeze", rp )
		umsg.Bool( true )
	umsg.End( )
	
	local ed = EffectData()
	ed:SetOrigin(self:GetPos())
	util.Effect( "ice_poof", ed, true, true )
	
end

function meta:IsFrozen()

	return self:GetNetworkedBool("Frozen",false)
	
end

function meta:Jail( killer )
	
	player_pup.EndPlayer( self )
	self:PutInPlayer( true )
	
	if !killer then return spawn end
	
	if killer:IsPlayer() then --If the killer is a player
		
		local rp = RecipientFilter()
		rp:AddAllPlayers( )
		
		umsg.Start( "DBOut" )
			
			umsg.Entity( self )
			umsg.Entity( killer )
			
		umsg.End()
		
	elseif killer:GetClass() == "gmod_dodgeball" then --We allow either the actual owner or the ball
		
		killer = killer.eOwner or killer.Punter --Get the owner
		if thrower then --If there really is an owner continue
			
			local rp = RecipientFilter()
			rp:AddAllPlayers( )
			
			umsg.Start( "DBOut" )
				
				umsg.Entity( self )
				umsg.Entity( killer )
				
			umsg.End()
			
			
		end
		
	end
	
	if killer != self then
		killer:AddFrags( 1 )
	else
		killer:AddFrags( -1 )
	end
	self:AddDeaths( 1 )
	
	
	GAMEMODE:CheckPlayerDeathRoundEnd()
end

function meta:OnPlayerModel()
	
	local cl_playermodel = self:GetInfo( "cl_playermodel" )
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	util.PrecacheModel( modelname )
	self:SetModel( modelname )

end

function meta:OnSpawn()
	GAMEMODE:SetPlayerSpeed(self, 400, 400)
	self:SetJumpPower( 250 )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
end
