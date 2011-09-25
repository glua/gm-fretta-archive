
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "tables.lua" )

function PlayerSpawn( ply )
	for k,v in pairs( GAMEMODE.BonusLevels ) do
		if k == ( ply.level ) then
			local gun = v
			ply:Give( gun )
			ply:SelectWeapon( gun )
		end
	end
end

function UpgradeCheck( ply )
	for k,v in pairs( Levels ) do
		if ply:Frags() == k then
			for k, v in pairs( ply:GetWeapons() ) do
				ply:DropWeapon(v)
			end
			ply:Give( "weapon_real_cs_knife" )
			local gun = v
			ply:Give( gun )
			ply:SelectWeapon( gun )
			RunConsoleCommand("say", "is on: "..gun)
		end
	end
	if ply:Frags() == 20 then
		BroadcastLua( "LocalPlayer():EmitSound( 'nade_level.wav' )" )
		else if ply:Frags() == 21 then
			BroadcastLua( "LocalPlayer():EmitSound( 'knife_level.wav' )" )
			else if ply:Frags() == 22 then
				BroadcastLua( "LocalPlayer():EmitSound( \"song_credits_2\" )" )
				RunConsoleCommand("say", "WON THE GAME!!1")
				timer.Simple( 2, function() GAMEMODE:EndOfGame(true) end )
			end
		end
	end
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:CreateRagdoll()
	ply:AddDeaths( 1 )
	if ( attacker:IsValid() and attacker != ply ) then
		if ( dmginfo:GetInflictor() == "weapon_real_cs_knife" and attacker:Frags() < 20) then
			attacker:AddFrags(1)
			UpgradeCheck(attacker)
			attacker:EmitSound( "smb3_powerup.wav" )
			ply:AddFrags(-1)
			UpgradeCheck(ply)
			attacker:EmitSound( "smb3_powerup.wav" )
			else if ( dmginfo:GetInflictor() == "weapon_real_cs_knife" and attacker:Frags() == 20) then
			ply:Give( "weapon_real_cs_grenade" )
			attacker:GiveAmmo(1, "grenade")
			attacker:SelectWeapon( "weapon_real_cs_grenade" )
			attacker:EmitSound( "brass_bell_C.wav" )
			ply:AddFrags(-1)
			UpgradeCheck(ply)
			ply:EmitSound( "smb3_powerdown.wav" )
				else if ( dmginfo:GetInflictor() == "weapon_real_cs_knife" and attacker.level == 21) then
				attacker:AddFrags(1)
				UpgradeCheck(attacker)
				attacker:EmitSound( "smb3_powerup.wav" )
				ply:AddFrags(-1)
				UpgradeCheck(ply)
				ply:EmitSound( "smb3_powerdown.wav" )
				else
				attacker:AddFrags(1)
				UpgradeCheck(attacker)
				attacker:EmitSound( "smb3_powerup.wav" )
				end
			end
		end
	end
end
	