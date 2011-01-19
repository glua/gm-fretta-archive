////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Player Extensions                          //
////////////////////////////////////////////////

local meta = FindMetaTable( "Player" )
if (not meta) then return end 

meta.OldPrintMessage = meta.PrintMessage

-- Only useful when game starts since we're assuming every player is in the same environment
function meta:GetEnvironment()
	if #ents.FindByClass("func_wareroom") == 0 then
		return ware_env.Get(1)
	end
	
	for _,v in pairs(ware_env.GetTable()) do
		if v.Players[self] then
			return v
		end
	end
end

function meta:GiveOverride(class)
	local w = ents.Create(class)
	w:SetPos(self:GetPos() + Vector(0,0,24))
	w:Spawn()
end

-- Basic minigame functions
function meta:GetAchieved()
	local achieved = self:GetDTInt(DTVAR_PLAYER_ACHIEVED_INT, 0)
	if (achieved == -1) then
		return nil
	else
		return (achieved > 0)
	end
end

function meta:GetLocked()
	local locked = self:GetDTInt(DTVAR_PLAYER_LOCKED_INT, 0)
	return (locked > 0)
end

function meta:IsWarePlayer()
	return self:Team() == TEAM_HUMANS
end

function meta:IsOnHold()
	return ( (self:GetAchieved() == nil) and (self:GetLocked()) )
end

function meta:SetAchievedNoLock( hasAchieved )
	if self:GetLocked() then return false end
	if GAMEMODE:PhaseIsPrelude() then return false end
	
	self:SetAchievedSpecialInteger((hasAchieved and 1) or 0)
	return true
end

function meta:ApplyFirst( )
	self:SetDTBool( 0, true )
	return true
end

function meta:IsFirst( )
	return self:GetDTBool( 0 )
	
end

-- Special functions for game engine - not for gamemodes -
/// >>>
function meta:RemoveFirst( )
	self:SetDTBool( 0, false )
	return true
end

function meta:SetAchievedSpecialInteger( intAchieved )
	if self:GetLocked() then
		return false
	end
	self:SetDTInt(DTVAR_PLAYER_ACHIEVED_INT, intAchieved )
	return true
end

function meta:SetLockedSpecialInteger( intLocked )
	self:SetDTInt(DTVAR_PLAYER_LOCKED_INT, intLocked )
	return true
end

function meta:SetComboSpecialInteger( intCombo )
	self:SetDTInt(DTVAR_PLAYER_COMBO_INT, intCombo )
	return true
end
-- <<<
-- End

function meta:GiveAward( sAward )
	if not sAward then return end

	self.m_tokens[sAward] = (self.m_tokens[sAward] or 0) + 1

end

function meta:GiveAwards( tabVar )
	if not tabVar then return end
	
	if #tabVar > 0 then
		for _,id in pairs( tabVar ) do
			self:GiveAward( id )
			
		end
	
	end

end

function meta:ApplyLock( dontSendStatusMessage )
	if GAMEMODE:PhaseIsPrelude() then return false end
	if not self:IsWarePlayer() then return false end
	if self:GetLocked() then return end
	
	if (self:GetAchieved() == nil) then
		self:SetAchievedNoLock( false )
	end
	self:SetLockedSpecialInteger( 1 )
	
	local hasAchieved = self:GetAchieved() or false
	
	if (hasAchieved) then
		-- TOKEN_GWUPDATE_COMP
		local anim = (math.random(0, 1) > 0) and ACT_SIGNAL_FORWARD or ACT_SIGNAL_HALT
		self:DoAnimationEvent( anim ) 
		self:EmitSound(GAMEMODE.WASND.OtherWin, 100, GAMEMODE:GetSpeedPercent())
		self:AddFrags( 1 )
		local newComboVal = self:IncrementCombo()
		
		self:GiveAwards( GAMEMODE.m_ware_winawards )
		if GAMEMODE.m_ware_firstwin then
			self:GiveAward( "first_win" )
			self:ApplyFirst( )
			
			GAMEMODE.m_ware_firstwin = false
			
		end
		
		local ed = EffectData()
		ed:SetOrigin( self:GetPos() )
		util.Effect("ware_good", ed, true, true)
	
	else
		-- TOKEN_GWUPDATE_COMP
		local anim = (math.random(0, 1) > 0) and ACT_ITEM_THROW or ACT_ITEM_DROP
		self:DoAnimationEvent( anim ) 
		self:EmitSound(GAMEMODE.WASND.OtherLose, 100, GAMEMODE:GetSpeedPercent())
		self:AddDeaths( 1 )
		self:InterruptCombo()
		
		self:GiveAwards( GAMEMODE.m_ware_failawards )
		if GAMEMODE.m_ware_firstfail then
			self:GiveAward( "first_fail" )
			self:ApplyFirst( )
			
			GAMEMODE.m_ware_firstfail = false
			
		end
		
		local ed = EffectData()
		ed:SetOrigin( self:GetPos() )
		util.Effect("ware_bad", ed, true, true)
	
	end
	
	-- Message send, not if it's the end of game: CheckGlobal have been bypassed before
	-- global lock.
	
	if not(dontSendStatusMessage or false) then
		local everyoneStatusIsTheSame = GAMEMODE:CheckGlobalStatus()
		if (everyoneStatusIsTheSame) then
			GAMEMODE:SendEveryoneEvent( hasAchieved )
			return
		else
			--local rp = RecipientFilter()
			--rp:AddPlayer( self )
			umsg.Start("gw_yourstatus", self)
				umsg.Bool(hasAchieved)
				umsg.Bool(false)
			umsg.End()
		end
	end
end

function meta:TellDone( )
	--local rp = RecipientFilter()
	--rp:AddPlayer( self )
	umsg.Start("gw_specialstatus", self)
		umsg.Char( 1 )
	umsg.End()
	
end

function meta:ApplyDone( )
	self:SetAchievedNoLock( true )
	self:TellDone()
	
end

function meta:SetAchievedAndLock( hasAchieved )
	if self:Team() ~= TEAM_HUMANS then return false end
	if self:GetLocked()            then return false end
	hasAchieved = (hasAchieved or false)
	
	self:SetAchievedNoLock( hasAchieved )
	self:ApplyLock()
	
	return true
end

function meta:GetBestCombo()
	return self:GetDTInt(DTVAR_PLAYER_BESTCOMBO_INT, 0)
end

function meta:GetCombo()
	return self:GetDTInt(DTVAR_PLAYER_COMBO_INT, 0)
end

function meta:IncrementCombo()
	local myCombo = self:GetCombo()
	myCombo = myCombo + 1
	self:SetComboSpecialInteger( myCombo )
	
	if (myCombo > self:GetBestCombo()) then
		self:SetDTInt(DTVAR_PLAYER_BESTCOMBO_INT, myCombo)
	end
	
	if (myCombo > GAMEMODE:GetBestStreak()) then
		GAMEMODE:SetBestStreak( myCombo )
		
		--local rpall = RecipientFilter()
		--rpall:AddAllPlayers( )
		umsg.Start("BestStreakEverBreached", nil)
			umsg.Long( GAMEMODE:GetBestStreak() )
		umsg.End()
	end
	
	return myCombo
end

function meta:PrintComboMessagesAndEffects( compareCombo )
	if (compareCombo == GAMEMODE:GetBestStreak()) then
		GAMEMODE:PrintInfoMessage( self:GetName(), " equalized a ", "Server Best Streak of " .. compareCombo .. " Wares!" )
		
		--self:EmitSound( GAMEMODE.WASND.TBL_LocalWon[1] , 100 , 125 )
		self:EmitSound( GAMEMODE.WASND.GlobalWareningReport , 84 )
		
	elseif (compareCombo >= 3) and (compareCombo == self:GetBestCombo()) then 
		GAMEMODE:PrintInfoMessage( self:GetName(), " scored his ", "Own Best Streak of " .. compareCombo .. " wares!" )
		
		--self:EmitSound( GAMEMODE.WASND.TBL_LocalWon[2] , 100 , 119 )
		self:EmitSound( GAMEMODE.WASND.GlobalWareningReport, 100, GAMEMODE:GetSpeedPercent())
	
	elseif (compareCombo >= 3) then 
		GAMEMODE:PrintInfoMessage( self:GetName(), " scored a ", "Streak of " .. compareCombo .. " wares." )
		
		self:EmitSound( GAMEMODE.WASND.GlobalWareningReport, 100, GAMEMODE:GetSpeedPercent())
	end
end

function meta:InterruptCombo( )
	local myOldCombo = self:GetCombo()
	self:SetComboSpecialInteger( 0 )
	
	self:PrintComboMessagesAndEffects( myOldCombo )
	
	return myOldCombo
end

function meta:ApplyWin( )
	self:SetAchievedAndLock( true )
end

function meta:ApplyLose( )
	self:SetAchievedAndLock( false )
end

function meta:SendHitConfirmation( )
	SendUserMessage( "HitConfirmation", self )
end

function meta:EjectWeapons( vectForce, fRandomness )
	for k,weapon in pairs( self:GetWeapons() ) do
		if weapon.WorldModel then
			local weaponSim = ents.Create( "prop_physics" )
			weaponSim:SetPos( self:GetPos() + Vector(0, 0, 32) )
			weaponSim:SetAngles( Angle(math.random(0,360),math.random(0,360),math.random(0,360)) )
			
			weaponSim:SetModel( weapon.WorldModel )
			weaponSim:SetCollisionGroup(COLLISION_GROUP_WORLD)
			weaponSim:Spawn()
			--construct.SetPhysProp( nil, weaponSim, 0, nil,  { GravityToggle = true, Material = "weapon" } ) 
			
			local physobj = weaponSim:GetPhysicsObject()
			if physobj:IsValid() then
				physobj:ApplyForceCenter( physobj:GetMass() * (vectForce or Vector(0,0,0) + VectorRand() * fRandomness) )
				physobj:AddAngleVelocity( Angle(math.random(-128,128),math.random(-128,128),math.random(-128,128)) ) 
			end
			
			GAMEMODE:AppendEntToBin( weaponSim )
			
		end
		
	end
	self:StripWeapons( )
end

function meta:SimulateDeath( optvectPush, optiObjNumber )
	if self:IsSimDead() then return nil end
	
	self._SimDead = true
	
	self:SetColor(255, 255, 255, 64)
	self:CreateRagdoll( )
	
	if optvectPush then
		umsg.Start("PlayerRagdollEffect")
			umsg.Entity( self )
			umsg.Vector( optvectPush )
			umsg.Char( optiObjNumber or -1 )
		umsg.End()
	end
	
	return ragdoll
end

function meta:RestoreDeath()
	if not self:IsSimDead() then return false end
	
	self._SimDead = false
	
	self:SetColor(255, 255, 255, 255)
	if self:GetRagdollEntity() then
		self:GetRagdollEntity():Remove()
		
	end
		
	return true
end

function meta:IsSimDead()
	return self._SimDead or false
end

-- Imported from GMDM
-- Called by weapons to add recoil
--
function meta:Recoil( pitch, yaw )

	-- On the client it can sometimes process the same usercmd twice
	-- This function returns true if it's the first time we're doing this usercmd
	if ( not SinglePlayer() and not IsFirstTimePredicted() ) then return end

	-- People shouldn't really be playing in SP
	-- But if they are they won't get recoil because the weapons aren't predicted
	-- So the clientside stuff never fires the recoil
	if ( SERVER and SinglePlayer() ) then 
	
		-- Please don't call SendLua in multiplayer games. This uses a lot of bandwidth
		self:SendLua( "LocalPlayer():Recoil("..pitch..","..yaw..")" )
		return 
		
	end
	
	self.LastShoot = 0.5
	self.LastShootSize = math.abs(yaw) + math.abs(pitch)
	
	self.RecoilYaw = self.RecoilYaw or 0
	self.RecoilPitch = self.RecoilPitch or 0
	
	self.RecoilYaw = self.RecoilYaw 		+ yaw
	self.RecoilPitch = self.RecoilPitch 	+ pitch

end

--
-- Shot attacked
--
function meta:DoRecoilThink( pitch, yaw )

	if ( SERVER ) then return end
	if ( self ~= LocalPlayer() ) then return end
	
	local pitch 	= self.RecoilPitch	or 0
	local yaw 		= self.RecoilYaw  	or 0
	
	pitch = pitch
	yaw = yaw
	
	local pitch_d	= math.Approach( pitch, 0.0, 20.0 * FrameTime() * math.abs(pitch) )
	local yaw_d		= math.Approach( yaw, 0.0, 20.0 * FrameTime() * math.abs(yaw) )
	
	self.RecoilPitch 	= pitch_d
	self.RecoilYaw 		= yaw_d
		
	-- Update eye angles
	local eyes = self:EyeAngles()
		eyes.pitch = eyes.pitch + ( pitch - pitch_d )
		eyes.yaw = eyes.yaw + ( yaw - yaw_d )
		eyes.roll = 0
	self:SetEyeAngles( eyes )

end

--
-- Think
--
function meta:Think( )

	-- We spread the recoil out over a few frames to make it less of a shock
	-- This function adds the recoil
	self:DoRecoilThink()

end

function meta:IsObserver()
	return ( self:Team() == TEAM_SPECTATOR and self:GetObserverMode() > OBS_MODE_NONE )
end
