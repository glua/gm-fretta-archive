
function OnSpawn( ply )
	SetClientFlag(ply, false)
end
hook.Add("PlayerSpawn", "ResetFlagOnSpawn", OnSpawn)

function OnDeath( ply )
	if(ply.hasFlag) then
	
		SafeRemoveEntity(ply.Trail)
		local num
		if(ply:Team() == TEAM_RED) then
			num = 2
		else
			num = 1
		end
		Pos = ply:GetPos() + Vector(0,0,20)
		local flag = ents.Create("cw_flag")
		flag:SetPos(Pos)
		if(num == 1) then
			flag:SetteamNum(1)
		else
			flag:SetteamNum(2)
		end
		flag:SetNWInt("team", num)
		flag:Spawn()
		
		timer.Create("ResetFlagPos", 30, 1, function()
			flag:Remove()
			flag = ents.Create("cw_flag")
			if (ply:Team() == TEAM_RED ) then
				flag:SetPos(BlueFlagSp)
				flag:SetNWInt("team", 2)
				flag.oFlagSp = BlueFlagSp
			else flag:SetPos(RedFlagSp)
				flag.oFlagSp = RedFlagSp
				flag:SetNWInt("team", 1)
			end 
			flag:Spawn()
			flag:GetPhysicsObject():AddVelocity(Vector(0,0,-15))
		end)
	end
end
hook.Add("PlayerDeath", "ResetFlagOnDeath", OnDeath)
hook.Add("PlayerDisconnected", "ResetFlagOnDisconnect", OnDeath)

function GM:SpawnFlag(SpawnteamNum, Pos)
	local flag = ents.Create("cw_flag")
	flag:SetPos(Pos)
	if(SpawnteamNum == 1) then
		flag:SetteamNum(1)
		RedFlagSp = Pos
	else
		flag:SetteamNum(2)
		BlueFlagSp = Pos
	end
	flag:SetNWInt("team", SpawnteamNum)
	flag:Spawn()
end

function GM:CaptureFlag(ent, CZNum)
	if(ent:IsPlayer()) then
		if (ent:Team() == CZNum) and (ent.hasFlag) then
			SetClientFlag(ent, false)
			SafeRemoveEntity(ent.Trail)
			ent:AddFrags( 5 )
			GAMEMODE:addStat(ent, "caps", 1)
			team.AddScore(ent:Team(), 5)
			if(ent:Team() == TEAM_RED)then
				umsg.Start( "FlagCaptured" )
					umsg.String( "Blue Flag" )
					umsg.String( "Captured" )
					umsg.Entity( ent )
				umsg.End()
			else
				umsg.Start( "FlagCaptured" )
					umsg.String( "Red Flag" )
					umsg.String( "Captured" )
					umsg.Entity( ent )
				umsg.End()
			end
			for k,v in pairs(player.GetAll()) do
				if(v:Team() == ent:Team()) then
					if(v != ent)then
						GAMEMODE:addpoints(v, 10)
						v:SendLua('PlaySound("'..SOUND_SUCCESS..'")')
					else
						GAMEMODE:addpoints(v, 25)
						ent:SendLua('PlaySound("'..SOUND_YEAH..'")')
					end
				else
					if(v:Team() != TEAM_SPECTATOR) and (v:Team() != TEAM_UNASSIGNED)then
						v:SendLua('PlaySound("'..SOUND_FAIL..'")')
					end
				end
			end
			if(ent:Team() == TEAM_RED) then
				GAMEMODE:SpawnFlag(2, BlueFlagSp)
			else
				GAMEMODE:SpawnFlag(1, RedFlagSp)
			end
		end
	end
end
	
function GM:GrabFlag(ent, teamNum, flag)
	if(ent:IsPlayer()) then
		if !(ent:Team() == teamNum) then
			SetClientFlag(ent, true)
			SetTrail(ent, teamNum)
			flag:Remove()
			timer.Destroy("ResetFlagPos")
			ent:SendLua('PlaySound("'..SOUND_GRAB..'")')
		end
	end
end

function GM:RefreshFlag()
	for _, ply in pairs(player.GetAll()) do
		umsg.Start( "ChangeFlagHolder" );
			umsg.Entity(ply);
			umsg.Bool(ply.hasFlag);
		umsg.End();
	end
end

function SetTrail(ply, pteam)
	if(pteam == TEAM_RED) then
		teamc = 1
	else
		teamc = 2
	end
		ply.Trail = util.SpriteTrail(ply, ply:LookupBone("ValveBiped.Bip01_Spine2"), team.GetColor(teamc), false, 100, 1, 5, 1/(100+1)*0.5, "trails/laser.vmt")
end

function SetClientFlag(ply, bool)
	ply.hasFlag = bool
	GAMEMODE:RefreshFlag()
end