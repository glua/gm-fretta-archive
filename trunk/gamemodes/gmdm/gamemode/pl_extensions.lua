
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

/*

// This is the custom ammo system.
// It's too simple to explain.

*/

function meta:GetCustomAmmo( name )			return self:GetNWInt( "ammo_" .. name, 0 ) end
function meta:SetCustomAmmo( name, num )	return self:SetNWInt( "ammo_" .. name, num ) end
function meta:TakeCustomAmmo( name, num )	return self:SetCustomAmmo( name, self:GetCustomAmmo( name ) - num ) end
function meta:AddCustomAmmo( name, num )	return self:SetCustomAmmo( name, self:GetCustomAmmo( name ) + num ) end

meta.OldPrintMessage = meta.PrintMessage;

function meta:PrintMessage( t, m )

	if( t == HUD_PRINTCENTER ) then
		if( CLIENT ) then
			GAMEMODE:AddCenterMessage( m );
		else
			local rp = RecipientFilter();
			rp:AddPlayer( self );
					
			-- send our user message
			umsg.Start( "gmdm_printcenter", rp );
			umsg.String( m );
			umsg.End();		
		end
		
		return;
	end
	
	return self:OldPrintMessage( t, m );
end

// dopple jump module
function meta:HasDoubleJump( ) return self:GetNWBool( "DoubleJump", false ); end
function meta:SetDoubleJump( b ) self:SetNWBool( "DoubleJump", b ); end

//
// Called by weapons to add recoil
//
function meta:Recoil( pitch, yaw )

	// On the client it can sometimes process the same usercmd twice
	// This function returns true if it's the first time we're doing this usercmd
	if ( !SinglePlayer() && !IsFirstTimePredicted() ) then return end

	// People shouldn't really be playing in SP
	// But if they are they won't get recoil because the weapons aren't predicted
	// So the clientside stuff never fires the recoil
	if ( SERVER && SinglePlayer() ) then 
	
		// Please don't call SendLua in multiplayer games. This uses a lot of bandwidth
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


//
// Called when shot in the head
//
function meta:HeadShot()

	self.HeadShotRoll = 45
	self.HeadShotStart = CurTime()
	
	MotionBlur = 0.85
	ColorModify[ "$pp_colour_colour" ] = 0
	ColorModify[ "$pp_colour_addr" ] = 1
//	ColorModify[ "$pp_colour_mulr" ] = 2
	Sharpen = 3

end

//
// Called when shot in the body
//
function meta:BodyShot()

	self.HeadShotRoll = math.Clamp( self.HeadShotRoll + 10, 0, 45 )
	self.HeadShotStart = CurTime()
	
	Sharpen = 2
	ColorModify[ "$pp_colour_addr" ] = math.Clamp( ColorModify[ "$pp_colour_addr" ] + 0.5, 0, 1 )

end


//
// Shot attacked
//
function meta:DoRecoilThink( pitch, yaw )

	if ( SERVER ) then return end
	if ( self != LocalPlayer() ) then return end
	
	local pitch 	= self.RecoilPitch	or 0
	local yaw 		= self.RecoilYaw  	or 0
	
	pitch = pitch
	yaw = yaw
	
	local pitch_d	= math.Approach( pitch, 0.0, 20.0 * FrameTime() * math.abs(pitch) )
	local yaw_d		= math.Approach( yaw, 0.0, 20.0 * FrameTime() * math.abs(yaw) )
	
	self.RecoilPitch 	= pitch_d
	self.RecoilYaw 		= yaw_d
		
	// Update eye angles
	local eyes = self:EyeAngles()
		eyes.pitch = eyes.pitch + ( pitch - pitch_d )
		eyes.yaw = eyes.yaw + ( yaw - yaw_d )
		eyes.roll = 0
	self:SetEyeAngles( eyes )

end

//
// Think
//
function meta:Think( )

	// We spread the recoil out over a few frames to make it less of a shock
	// This function adds the recoil
	self:DoRecoilThink()

end

//
// 
//
function meta:OnTakeDamage( inflictor, attacker, amount, dmginfo )
	
	// Half damage if you're blowing yourself up, to aid rocket jumping
	if ( attacker && attacker == self ) then
	
		dmginfo:ScaleDamage( 0.1 )
		
	end
	
	if ( dmginfo:IsExplosionDamage() ) then
	
		//local Force = dmginfo:GetDamageForce()
		local Pos = dmginfo:GetDamagePosition()
		
		// Move center down to encourage blowing upwards
		Pos = Pos + Vector( 0, 0, -100 )
		
		// Scale the force by the distance away from the center of the explosion
		// We're assuming the explosion radius is about 768, which is usually about right.
		local Force = self:GetPos() - Pos
		local Dist = Force:Length()
		Force:Normalize()
		Force = Force * math.Clamp( 512 - Dist, 0, 512 )
		
		// Add the velocity to our current velocity
		self:SetVelocity( self:GetVelocity() + Force )
	
	end
	
end

//
// Player's traceline
//
function meta:TraceLine( distance )

	local vStart = self:GetShootPos()
	local vForward = self:GetAimVector()

	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (vForward * distance)
	trace.filter = self
		
	return util.TraceLine( trace )

end

//
// Gib the player
//
function meta:Gib( dmginfo )

	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetNormal( dmginfo:GetDamageForce() )
	util.Effect( "gib_emitter", effectdata )

end

-- Some stuff from Rambo_6's simple game base which adds some easy sound stuff
function meta:SetupPlayerTable()
	

end

function meta:GetPlayerTable()
	return {}
end

function meta:Taunt()
	if( self.Info ) then
		self:VoiceSound( ChooseRandom( self.Info.Taunt ) );
	end
end

function meta:RandomQuip( soundtab )
	if( soundtab ) then
		if( math.random( 1, 3 ) == 1 ) then
			self:VoiceSound( ChooseRandom( soundtab ) );
		end
	end
end

function meta:VoiceSound(sound,vol,delay)
	if not self:Alive() then return end
	vol = vol or 100
	self.Pitch = self.Pitch or {95,105}
	if self.SoundDelay then
		if self.SoundDelay < CurTime() then
			if delay != nil then
				timer.Simple(delay, function(self,sound,vol) 
				if self.SoundDelay < CurTime() then
					if self:IsValid() then
						self:EmitSound(sound,vol,100) end
						self.SoundDelay = CurTime() + 2
					end
				end, self, sound, vol)
			else
				self.SoundDelay = CurTime() + 2
				self:EmitSound(sound,vol,100)
			end
		end
	else
		self.SoundDelay = CurTime() + 2
		if delay != nil then
			timer.Simple(delay, function(self,sound,vol) 
			if self.SoundDelay < CurTime() then
				if self:IsValid() then
					self:EmitSound(sound,vol,100) end
					self.SoundDelay = CurTime() + 2
				end
			end, self, sound, vol)
		else
			self.SoundDelay = CurTime() + 2
			self:EmitSound(sound,vol,100)
		end
	end
end

local meta = FindMetaTable( "Entity" )
if (!meta) then return end 

//
// Shot attacked
//
function meta:TraceAttack( dmginfo, dir, trace )

	if( dmginfo:GetDamage() < 1 ) then return end
	
	if ( trace.HitGroup == HITGROUP_HEAD ) then
	
		local effectdata = EffectData()
			effectdata:SetEntity( self )
			effectdata:SetOrigin( trace.HitPos )
			effectdata:SetNormal( dir )
		util.Effect( "headshot", effectdata )
		return
		
	end
	
	local effectdata = EffectData()
		effectdata:SetEntity( self )
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
	util.Effect( "bodyshot", effectdata )
	
	self:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 120, 100 )

end