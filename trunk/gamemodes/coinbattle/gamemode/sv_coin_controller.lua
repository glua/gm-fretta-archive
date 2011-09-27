
function GM:SpawnCoin(ply, cointype)
	
	local coin = ents.Create(cointype)
	coin:SetPos(ply:GetPos() + Vector(0,0,32))
	coin:Spawn()
	
end

local function GetNumOfUnit(coinValue, haveValue)
	local value = math.floor(haveValue/coinValue)
	if value < 0 then return 0 end
	return value
end

function GM:EntityTakeDamage(ent, inflictor, attacker, amount, dmginfo)
	
	if attacker:IsPlayer() and ent:IsPlayer() and ent:Team() ~= attacker:Team() and GAMEMODE:InRound() then
		
		local CoinNumber = 1 + math.floor((dmginfo:GetDamage()/20)*4)
		ent:AddCoins(-1 - math.floor(CoinNumber/2))
		
		local numOfCoins = #CoinTable
		for i=1, numOfCoins do
			
			local tab = CoinTable[i]
			local NumOfType = GetNumOfUnit(tab.value, CoinNumber)
			CoinNumber = CoinNumber - (NumOfType*tab.value)
			
			for i=1,NumOfType do		
				GAMEMODE:SpawnCoin(ent, tab.type)
			end
			
		end
		
		GAMEMODE:UpdateScores()
		
	end
	
	--Stop Damage from mine colliding
	if ent:IsPlayer() and attacker:GetClass() == "cb_stickymine" then
		
		dmginfo:SetDamage(0)
		
	end
	
	--Make Damage Alert
	if ent:IsPlayer() and attacker:IsPlayer() and not(ent:Team() == attacker:Team()) then
	
		local pos = ent:GetPos()
		pos.z = ent:LocalToWorld(ent:OBBMaxs()).z
		
		umsg.Start("DamageNotify", attacker)
			umsg.Vector(pos)
			umsg.Short(amount)
			umsg.Short(CurTime()+3)
		umsg.End()
		
	end
	
end

function GM:PlayerDisconnected(ply)
	
	local Team = ply:Team()
	local numOfCoins = ply:GetCoins()
	
	timer.Simple(0,function(Team, numOfCoins) GAMEMODE:AfterPlayerDisconnected(Team, numOfCoins) end,Team,numOfCoins)
	
end

function GM:AfterPlayerDisconnected(Team, numOfCoins)
	
	local numOfTeam = #team.GetPlayers(Team)
	
	for _,teammate in pairs(team.GetPlayers(Team)) do
		teammate:AddCoins(math.floor(numOfCoins/numOfTeam))
	end
	
	local extraCoins = numOfCoins - math.floor(numOfCoins/numOfTeam)*numOfTeam
	
	if extraCoins > 0 then
		
		for _,teammate in pairs(team.GetPlayers(Team)) do
			
			teammate:AddCoins(1)
			extraCoins = extraCoins - 1
			
			if extraCoins <= 0 then
				break
			end
			
		end
		
	end
	
	GAMEMODE:UpdateScores()
	
end

function GM:DoPlayerDeath(ply,attacker,dmginfo)
	
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:CreateRagdoll()
	ply:AddDeaths( 1 )
	
	for k,v in pairs(ents.FindByClass("cb_stickymine")) do
		
		if v:GetOwner() == ply then
			v:Remove()
		end
		
	end
	
	// if ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "cb_weapon_cloak" then
	// 	if ply:GetActiveWeapon().dt.Camo == true then
	// 		ply:GetActiveWeapon():SetCamo(false)
	// 	end
	// end
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == ply ) then
		
			if ( GAMEMODE.TakeFragOnSuicide ) then
			
				attacker:AddFrags( -1 )
				
				if ( GAMEMODE.TeamBased && GAMEMODE.AddFragsToTeamScore ) then
					team.AddScore( attacker:Team(), -1 )
				end
			
			end
			
		else
		
			attacker:AddFrags( 1 )
			
			if ( GAMEMODE.TeamBased && GAMEMODE.AddFragsToTeamScore ) then
				team.AddScore( attacker:Team(), 1 )
			end
			
		end
		
	end
	
	if ( GAMEMODE.EnableFreezeCam && IsValid( attacker ) && attacker != ply ) then
	
		ply:SpectateEntity( attacker )
		ply:Spectate( OBS_MODE_FREEZECAM )
		
	end
	
	if attacker:IsPlayer() and ply ~= attacker and GAMEMODE:InRound() then
		GAMEMODE:SpawnCoin(ply, "coin_gold")
	end
	
end
