function GM:ResetCaptureZone ()
	--print ("Resetting capture zone...")
	self.CaptureZoneTime = 0
	self.CaptureZoneActive = false
	self.CaptureZoneStatus = false
	self.CaptureZoneTeam = false
	self.CaptureZoneOccupants = {}
	self:CaptureZoneSendPosition()
end

GM:AddHook ("OnPreRoundStart", "ResetCaptureZone")

function GM:StartCaptureZoneTimer ()
	--print ("Start countdown for capture zone...")
	timer.Create ("ActivateCaptureZone", self.CaptureZoneActivationDelay, 1, function ()
		GAMEMODE:ActivateCaptureZone()
	end)
end

GM:AddHook ("OnRoundStart", "StartCaptureZoneTimer")

function GM:FreezeCaptureZone ()
	--print ("Freezing capture zone...")
	timer.Remove ("ActivateCaptureZone")
	self.CaptureZoneActive = false
end

GM:AddHook ("OnRoundEnd", "FreezeCaptureZone")

function GM:ActivateCaptureZone ()
	--print ("Activating capture zone...")
	self.CaptureZoneActive = true
	self.CaptureZone:CreateDrawHandler()
end

function GM:CaptureZoneEntered (ply)
	--print (ply, "entered!")
	self.CaptureZoneOccupants[ply] = CurTime()
	self:CaptureZoneStatusUpdate ()
end

function GM:CaptureZoneExited (ply)
	--print (ply, "exited!")
	self.CaptureZoneOccupants[ply] = nil
	self:CaptureZoneStatusUpdate ()
end

function GM:CaptureZoneStatusUpdate ()
	local teamsOccupying = {}
	for ply,time in pairs (self.CaptureZoneOccupants) do
		teamsOccupying[ply:Team()] = true
	end
	local seenTeam
	for k,v in pairs (teamsOccupying) do
		seenTeam = seenTeam or k
		if k != seenTeam then
			seenTeam = -1
			break
		end
	end
	if seenTeam == -1 then --contested
		--print ("Now contested.")
	elseif not seenTeam then
		--print ("Now unoccupied.")
	else
		--print ("Now not contested, holding", seenTeam)
	end
	self.CaptureZoneStatus = seenTeam
	if self.CaptureZoneTime == 0 then
		self.NextCaptureZoneThink = CurTime()
	end
end

function GM:CaptureZoneThink ()
	if (not self.CaptureZoneTime) or (not self.CaptureZoneActive) then return end --not started
	if (self.NextCaptureZoneThink or 0) > CurTime() then return end
	if not self.CaptureZoneStatus then
		--print ("Reducing time (no-one here)")
		self.CaptureZoneTime = math.max (0, self.CaptureZoneTime - 0.5)
		if self.CaptureZoneTime == 0 then
			self.CaptureZoneTeam = -1
		end
	elseif self.CaptureZoneStatus == -1 then
		--print ("Keeping time still (conflict!)")
	else
		--print ("One team has this, apparently")
		if self.CaptureZoneTeam == self.CaptureZoneStatus then
			--print ("Full speed capping!")
			self.CaptureZoneTime = math.min (self.CaptureZoneTimeRequired, self.CaptureZoneTime + 1)
			if self.CaptureZoneTime == self.CaptureZoneTimeRequired then
				GAMEMODE:RoundEndWithResult (self.CaptureZoneTeam)
			end
		elseif self.CaptureZoneTime > 0 then
			--print ("Full speed decapping!")
			self.CaptureZoneTime = math.max (0, self.CaptureZoneTime - 1)
		else
			--print ("This is going to be some other team's point now, boys.")
			self.CaptureZoneTeam = self.CaptureZoneStatus
		end
	end
	self:CaptureZoneSendStatus()
	self.NextCaptureZoneThink = CurTime() + 1
end

function GM:CaptureZoneSendPosition (ply)
	if not ValidEntity(self.CaptureZone) then return end
	umsg.Start ("lnl_cz_pos", ply)
		umsg.Vector (self.CaptureZone:OBBMins())
		umsg.Vector (self.CaptureZone:OBBMaxs())
	umsg.End()
end

GM:AddHook ("PlayerActive", "CaptureZoneSendPosition")

function GM:CaptureZoneSendStatus ()
	umsg.Start ("lnl_cz")
		umsg.Short (self.CaptureZoneTeam)
		umsg.Float (self.CaptureZoneTime)
		umsg.Short (self.CaptureZoneStatus or -1)
	umsg.End()
end

GM:AddHook ("Think", "CaptureZoneThink")