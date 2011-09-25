
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "tables.lua" )

function GM:RoundTimerEnd( )
	GAMEMODE:RoundEndWithResult( ROUND_RESULT_DRAW )
end

function GM:OnRoundResult( )
	for k,v in pairs(player.GetAll()) do
		v:SetFrags(0)
		v:StripWeapons()
	end
end

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
	ply:StripWeapons()
		if ply:Team() == 2 then
			ply:Give( "weapon_stunstick" )
		else
			ply:Give( "weapon_crowbar" )
		end
	for k,v in pairs( Levels ) do
		if ply:Frags() == k then
			local gun = v
			ply:Give( gun )
			ply:SelectWeapon( gun )
			PrintMessage( HUD_PRINTTALK, ply:GetName().." is on: "..gun )
		end
	end
	if ply:Frags() == 20 then
		BroadcastLua( "LocalPlayer():EmitSound( 'nade_level.wav' )" )
		else if ply:Frags() == 21 then
			BroadcastLua( "LocalPlayer():EmitSound( 'knife_level.wav' )" )
			else if ply:Frags() == 22 then
				BroadcastLua( "LocalPlayer():EmitSound( \"song_credits_2\" )" )
				timer.Simple( 2, function() GAMEMODE:RoundEndWithResult( team.GetName(ply:Team()), ply:GetName().." Won this Round!" ) end )
			end
		end
	end
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:StripWeapons()
	ply:CreateRagdoll()
	ply:AddDeaths( 1 )
	if ( attacker:IsValid() and attacker:IsPlayer( ) and attacker != ply ) then
		if ( dmginfo:IsBulletDamage() == false and attacker:Frags() < 20) then
			attacker:AddFrags(1)
			UpgradeCheck(attacker)
			attacker:EmitSound( "smb3_powerup.wav" )
			ply:AddFrags(-1)
			UpgradeCheck(ply)
			attacker:EmitSound( "smb3_powerdown.wav" )
			else if ( dmginfo:IsExplosionDamage() == false and attacker:Frags() == 20) then
				ply:Give( "weapon_frag" )
				attacker:GiveAmmo(2, "grenade")
				attacker:EmitSound( "brass_bell_C.wav" )
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
	