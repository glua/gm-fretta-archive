
//Cactus Taunts
Cactus.Taunts = {}
Cactus.Taunts.normal ={
"cactus/cactus_low.mp3",
"cactus/cactus_nerd.mp3",
"cactus/5cacti.mp3",
"cactus/andcactus.mp3",
"cactus/uhcactus.mp3",
"cactus/cactuscactus.mp3",
"cactus/evilcactus.mp3"
}
for i=1,10 do
	table.insert(Cactus.Taunts.normal,"cactus/cactus"..tostring(i)..".mp3")
end
Cactus.Taunts.fast = {
"cactus/cactus_nerd.mp3",
"cactus/cactuscactus.mp3",
"cactus/andcactus.mp3",
"cactus/cactus3.mp3",
"cactus/cactus4.mp3",
"cactus/cactus5.mp3",
"cactus/cactus8.mp3",
"cactus/cactus9.mp3"
}
Cactus.Taunts.slow = {
"cactus/cactus_low.mp3",
"cactus/cactus_nerd.mp3",
"cactus/cactus1.mp3",
"cactus/cactus2.mp3",
"cactus/cactus3.mp3",
"cactus/cactus6.mp3",
"cactus/cactus7.mp3",
"cactus/cactus10.mp3",
"cactus/uhcactus.mp3",
"cactus/andcactus.mp3"
}


function GM:GetDifficulty() --shd
	
	local round = GetGlobalInt("RoundNumber")
	local convar = GetConVarNumber("c_difficulty")
	return round+convar
	
end

function GM:CaughtCactus(ply,cactus) --shd

	if !ValidEntity(ply) or !ValidEntity(cactus) then return end
	
	local cdata = cactus:GetCactusData()
	
	
	local wut = "a"
	local punc = "."
	
	if cdata:GetType() == "golden" then
		wut = "the"
	end
	if cdata.Difficulty >= 4 then
		punc = "!"
	end
	
	if SERVER then
		local notify = {} --Hint table
		notify["Type"] = "caught" --Type of notification for cactus icon to use
		notify["Urgency"] = cdata.Difficulty --Type of notification for cactus icon to use
		notify["Data"] = {} --Data table that contains info to send via usermessage
		notify["Data"][1] = cdata:GetName() --Caught type
		notify["Time"] = {}
		notify["Time"]["Notify"] = 1 --Time in seconds for notification to stop
		notify["Time"]["Hint"] = 0.5 --Time in seconds before the hint to goes away
		
		local hint = "You caught "..wut.." "..cdata:GetName().." Cactus"..punc
		
		if !cdata:OnCapture(ply,cactus) then
			hint = cdata:GetName().." cacti cannot be captured!"
			GAMEMODE:SendCactusNotification(ply,hint,notify)
			return
		end
		
		GAMEMODE:SendCactusNotification(ply,hint,notify)
	end
	
	cdata:OnCapture(ply,cactus)
	
	local score = cdata.Score
	if cactus:GetPlayerObj() then
		score = score*3
	end
	
	local difficulty = GAMEMODE:GetDifficulty()
	ply:AddScore(cdata.Score)
	
	local col_r, col_g, col_b = cactus:GetColor()
	umsg.Start( "c.CaughtCactus", ply )
		umsg.Vector( cactus:GetPos() )
		umsg.Angle( cactus:GetAngles() )
		umsg.Float( col_r )
		umsg.Float( col_g )
		umsg.Float( col_b )
	umsg.End()

	if ValidEntity(cactus:GetPlayerObj()) and cactus:GetPlayerObj():IsPlayer() then
		cactus:GetPlayerObj():TakeDamage(100, ply, ply:GetActiveWeapon())
		cactus:GetPlayerObj():PrintMessage( HUD_PRINTCENTER, "You were caught by "..ply:Nick() )
	end
	
	local caught = EffectData()
	caught:SetOrigin(cactus:GetPos()+cactus:OBBCenter())
	util.Effect( "CactusTrail",  caught )
	
	SafeRemoveEntity(cactus)
	
end



