
local CLASS = {}

CLASS.DisplayName			= "Cactus"
CLASS.PlayerModel			= ""
CLASS.WalkSpeed 			= 0
CLASS.CrouchedWalkSpeed 	= 0
CLASS.RunSpeed				= 0
CLASS.DuckSpeed				= 0
CLASS.JumpPower				= 0
CLASS.StartHealth			= 0
CLASS.MaxHealth				= 0
CLASS.DrawTeamRing			= false
CLASS.DrawViewModel			= false
CLASS.CanUseFlashlight      = true
CLASS.AllowFullRotation     = true

function CLASS:Loadout( ply )
	--ply:Give("weapon_cactus")
end

function CLASS:OnSpawn( ply )
	
	
end

function CLASS:Move(ply, data)

	if !SERVER then return end

	local altitude = 400 --Max altitude
	local gravity = Vector( 0, 0, GetConVarNumber("sv_gravity") * -1 ) --Server gravity

	if ply:Alive() and ply:IsCactus() and ValidEntity(ply:GetCactus()) then --Alive and valid and such
		
		ply.TooHigh = ply.TooHigh or nil -- Boolean for whether the player's too high or not
		ply.Altitude = ply.Altitude or nil -- Int Height of the cactus
		
		ply.Cactus = ply:GetCactus() -- Player's Cactus Entity
		ply.cactusObj = Cactus.GetType(ply.Cactus.CactusType) -- Cactus Meta Object
		ply.entdifficulty = ply.cactusObj.Difficulty -- Difficulty of the ent
		
		ply.Multiplier = ply.entdifficulty * 100 -- Speed multiplier
		ply.MoveVec = Vector() -- Player's MoveVec
		ply.aimvec = ply:GetAimVector() -- Player's aimvec
		
		//Altitude traces
		ply.down = vector_up * altitude * -1000
		ply.TraceDown = util.QuickTrace(ply.Cactus:GetPos(), ply.Cactus:GetPos() + ply.down, {ply, ply.Cactus})
		ply.Altitude = ply.Cactus:GetPos():Distance(ply.TraceDown.HitPos)
		
		if ply.Altitude >= altitude * ply.entdifficulty then
			ply.TooHigh = true
			ply.Multiplier = ply.Multiplier*(1/ply.Altitude)
		else
			ply.TooHigh = nil
		end
		
		ply.PressedSpam = ply.PressedSpam or nil
		ply.NextMove = ply.NextMove or nil
		local function DoSpam()
			if ply.cactusObj:OnSpam(ply,ply:GetCactus()) then
				ply.cactusObj:OnSpam(ply,ply:GetCactus())
			end
			ply.MoveVec = ply.aimvec*999*ply.entdifficulty*GAMEMODE:GetDifficulty() --ply.aimvec*ply.Multiplier*ply.entdifficulty*10
			ply.Cactus:EmitSound( table.Random(ply.cactusObj.Sounds, 100, ply.cactusObj.Pitch ) ) --Emit a sound
			ply.Cactus:SetMove(ply.MoveVec) --Do the move
		end
		if ply:KeyDown(IN_ATTACK) then --tiem to spamzors! :V
			
			if ply.cactusObj:OnPrimary(ply,ply:GetCactus()) then
				ply.cactusObj:OnPrimary(ply,ply:GetCactus())
			end
			
			if ply.TooHigh then return end
			if !ply.PressedSpam then --If timer is nil
				
				local rand = math.Rand( ply.cactusObj.RandSpam.lower, ply.cactusObj.RandSpam.upper )+2
				ply.PressedSpam = CurTime() + rand --Make new timer
				ply.NextMove = CurTime() + rand/2
				
				DoSpam()
				
				return --Stop here
				
			elseif ply.PressedSpam and ply.PressedSpam <= CurTime() then --If timer is valid and its over
				
				ply.PressedSpam = nil --Make it nil
				
				DoSpam()
				
				return
				
			end
			
		end
		
		if ply.NextMove and ply.NextMove > CurTime() then return end
		
		ply.right = ply.aimvec:Angle():Right() -- Vector to the right of aimvec
		
		ply.Dir = {} -- Direction multiplier
		
		//Set up vars that make up MoveVec
		ply.Fwd = Vector() -- Player's fwd/back movevec
		ply.Side = Vector() -- Player's left/right movevec
		ply.Vert = Vector() -- Player's up/down movevec
		
		//Conditionals to decide what direction to go
		if ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) then
			if ply:KeyDown(IN_FORWARD) then
				ply.Dir["f"] = 1.5
			end
			if ply:KeyDown(IN_BACK) then
				ply.Dir["f"] = -1
			end
			if ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_BACK) then
				ply.Dir["f"] = 0
			end
			ply.Fwd = (ply.aimvec * ply.Dir["f"]) * ply.Multiplier
		else
			ply.Fwd = Vector()
		end
		if ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT) then
			if ply:KeyDown(IN_MOVERIGHT) then
				ply.Dir["s"] = 1
			end
			if ply:KeyDown(IN_MOVELEFT) then
				ply.Dir["s"] = -1
			end
			if ply:KeyDown(IN_MOVERIGHT) and ply:KeyDown(IN_MOVELEFT) then
				ply.Dir["s"] = 0
			end
			ply.Side = (ply.right * ply.Dir["s"]) * ply.Multiplier
		else
			ply.Side = Vector()
		end
		if ply:KeyDown(IN_JUMP) then
			ply.Dir["u"] = 1.5
			ply.Vert = (vector_up * ply.Dir["u"]) * ply.Multiplier
		else
			ply.Vert = Vector()
		end
		
		--Add up vectors
		if ply.Fwd != Vector() then
			ply.MoveVec = ply.MoveVec + ply.Fwd
		end
		if ply.Side != Vector() then
			ply.MoveVec = ply.MoveVec + ply.Side
		end
		if ply.Vert != Vector() then
			ply.MoveVec = ply.MoveVec + ply.Vert
		end
		
		if ply.TooHigh then
			ply.MoveVec = ply.MoveVec + gravity
		end
		
		if ply:KeyDown(IN_FORWARD) || ply:KeyDown(IN_BACK) || ply:KeyDown(IN_MOVERIGHT) || ply:KeyDown(IN_MOVELEFT) || ply:KeyDown(IN_JUMP) then
			ply.Cactus:SetMove( ply.MoveVec )
		end
		
	end
	
	return false
	
end

function CLASS:CalcView( ply, origin, angles, fov )
	
	local view = {}
	ply.changedcolor = changedcolor or nil
	ply.offset = ply.offset or GetConVarNumber("cl_cactus_thirdperson_offset")
	ply.thirdperson = ply.thirdperson or GetConVarNumber("cl_cactus_thirdperson")
	ply.hasfired = ply.hasfired or nil
	
	if ply:IsCactus() then
		if input.IsMouseDown( MOUSE_WHEEL_UP ) then
			ply.offset = ply.offset - 1
			print("lol")
			RunConsoleCommand("cl_cactus_thirdperson_offset",ply.offset)
		elseif input.IsMouseDown( MOUSE_WHEEL_DOWN ) then
			ply.offset = ply.offset + 1
			print("lol")
			RunConsoleCommand("cl_cactus_thirdperson_offset",ply.offset)
		end
		if !ply.hasfired then
			if input.IsKeyDown(KEY_LCONTROL) then
				if ply.thirdperson > 0 then
					ply.thirdperson = 0
				else
					ply.thirdperson = 1
				end
				RunConsoleCommand("cl_cactus_thirdperson",ply.thirdperson)
				ply.hasfired = CurTime()+1
			end
		elseif ply.hasfired <= CurTime() and !input.IsKeyDown(KEY_LCONTROL) then
			ply.hasfired = nil
		end
		if ValidEntity(ply:GetCactus()) then
			local cactus = ply:GetCactus()
			local r,g,b,a = cactus:GetColor()
			local pos = cactus:GetPos()+cactus:OBBCenter()
			if ply.thirdperson > 0 then
				local tr = util.QuickTrace(pos,angles:Forward()*-ply.offset,{cactus})
				local tr2 = util.QuickTrace(tr.HitPos,tr.HitPos*vector_up*-3,{cactus})
				local endpos = tr.HitPos+tr.HitNormal*10
				if tr2.Hit then
					endpos = tr2.HitNormal*10
				end
				view.origin = endpos --or origin
				if CLIENT and ply == LocalPlayer() then
					local dist = endpos:Distance(pos)
					a = math.Clamp( dist*(255/ply.offset), 0, 255 )
					cactus:SetColor(r,g,b,a)
				end
			else
				view.origin = pos+ply:GetAimVector()
				if CLIENT and ply == LocalPlayer() then
					cactus:SetColor(r,g,b,0)
				end
			end
		end
	end
	view.angles = angles
	view.fov = 115
	
	return view
	
end

player_class.Register( "Cactus", CLASS )
