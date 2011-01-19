
local CLASS = {}

CLASS.DisplayName			= "Base Undead Class"
CLASS.PlayerModel			= "models/player/classic.mdl"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 150
CLASS.RespawnTime           = 5
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = false
CLASS.DrawViewModel			= true
CLASS.TeammateNoCollide 	= false //true // TODO: change these back when hulltraces are fixed properly
CLASS.AvoidPlayers			= false //true
CLASS.DieSound              = Sound( "npc/zombie/zombie_die1.wav" )

function CLASS:OnSpawn( pl )
	
	if not pl.m_bZomb and not pl:IsFirstZombie() then
		pl.m_bZomb = true
		pl:Notice( "You are now a zombie", 5, 255, 50, 0 )
		pl:Notice( "Press F1 to pick a different class", 8, 0, 100, 255 )
	end
	
	pl:ResetHull()
	pl:SetViewOffset( Vector( 0, 0, 64 ) )
	
end

function CLASS:OnDeath( pl )

	pl:EmitSound( self.DieSound )

end 

player_class.Register( "BaseUndead", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseUndead"
CLASS.DisplayName		= "Undead"
CLASS.Description       = "A reanimated corpse which can almost run as fast as a human."
CLASS.PlayerModel		= "models/player/corpse1.mdl"
CLASS.WalkSpeed 		= 250
CLASS.RunSpeed			= 250
CLASS.StartHealth		= 250
CLASS.MaxHealth			= 250
CLASS.DieSound          = Sound( "vo/npc/vortigaunt/vortigese02.wav" )

function CLASS:Loadout( pl )

	pl:Give( "claw_undead" )

end

function CLASS:Move( pl, mv )
	if pl:KeyDown(IN_BACK) then
		if pl:KeyDown(IN_SPEED) then
			mv:SetMaxSpeed(150)
		else
			mv:SetMaxSpeed(100)
		end
	end
end

player_class.Register( "Undead", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseUndead"
CLASS.DisplayName		= "Biohazard"
CLASS.Description       = "A burnt, disfigured corpse that emits hazardous radiation."
CLASS.PlayerModel		= "models/player/charple01.mdl"
CLASS.WalkSpeed 		= 200
CLASS.RunSpeed			= 200
CLASS.StartHealth		= 100
CLASS.MaxHealth			= 100
CLASS.DieSound          = Sound( "npc/stalker/breathing3.wav" )

function CLASS:Loadout( pl )

	pl:Give( "claw_biohazard" )

end

function CLASS:Move( pl, mv )
	if pl:KeyDown(IN_BACK) then
		if pl:KeyDown(IN_SPEED) then
			mv:SetMaxSpeed(150)
		else
			mv:SetMaxSpeed(100)
		end
	end
end

player_class.Register( "Biohazard", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseUndead"
CLASS.DisplayName		= "Ghoul"
CLASS.Description       = "A slower zombie which has stronger attacks and regenerates health."
CLASS.PlayerModel		= "models/zombie/classic.mdl"
CLASS.WalkSpeed 		= 120
CLASS.RunSpeed			= 120
CLASS.StartHealth		= 400
CLASS.MaxHealth			= 400
CLASS.DieSound          = Sound( "npc/zombie/zombie_die1.wav" )

function CLASS:Loadout( pl )

	pl:Give( "claw_zombie" )

end

function CLASS:Think( pl )

	if ( pl.RegenTime or 0 ) < CurTime() and pl:Alive() then
	
		pl.RegenTime = CurTime() + 1
		pl:SetHealth( math.Clamp( pl:Health() + 20, 1, 400 ) ) 
	
	end

end

player_class.Register( "Ghoul", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseUndead"
CLASS.DisplayName		= "Crawler"
CLASS.Description       = "A zombie torso which can crawl under tight spaces."
CLASS.PlayerModel		= "models/zombie/classic_torso.mdl"
CLASS.WalkSpeed 		= 130
CLASS.RunSpeed			= 130
CLASS.StartHealth		= 350
CLASS.MaxHealth			= 350
CLASS.DieSound          = Sound( "npc/zombie/zombie_die2.wav" )

function CLASS:OnSpawn( pl )
	
	pl:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 16 ) )
	pl:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 16 ) )

	pl:SetViewOffset( Vector( 0, 0, 20 ) )
	
end

function CLASS:Loadout( pl )

	pl:Give( "claw_crawler" )

end

player_class.Register( "Crawler", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseUndead"
CLASS.DisplayName		= "Wretch"
CLASS.Description       = "A weaker, more agile zombie which can leap into the air and climb walls."
CLASS.PlayerModel		= "models/zombie/fast.mdl"
CLASS.WalkSpeed 		= 250
CLASS.RunSpeed			= 250
CLASS.StartHealth		= 150
CLASS.MaxHealth			= 150
CLASS.DieSound          = Sound( "npc/fast_zombie/fz_alert_close1.wav" )

function CLASS:Loadout( pl )

	pl:Give( "claw_fastzombie" )

end

player_class.Register( "Wretch", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseUndead"
CLASS.DisplayName		= "Contagion"
CLASS.Description       = "A slower zombie which releases a cloud of toxic vapors upon dying."
CLASS.PlayerModel		= "models/zombie/poison.mdl"
CLASS.WalkSpeed 		= 110
CLASS.RunSpeed			= 110
CLASS.StartHealth		= 550
CLASS.MaxHealth			= 550

function CLASS:Loadout( pl )

	pl:Give( "claw_poisonzombie" )

end

function CLASS:OnSpawn( pl )
	
	pl:SetViewOffset( Vector( 0, 0, 55 ) )
	
end

function CLASS:OnDeath( pl, attacker, dmginfo )
	
	util.PrecacheModel( "models/Zombie/Classic_legs.mdl" )
	pl:SetModel( "models/Zombie/Classic_legs.mdl" )
	
	pl:PoisonCloud()
	
end

player_class.Register( "Contagion", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseUndead"
CLASS.DisplayName		= "Zombie Soldier"
CLASS.Description       = "An armored zombie which drops a grenade upon dying."
CLASS.PlayerModel		= "models/player/zombie_soldier.mdl"
CLASS.WalkSpeed 		= 150
CLASS.RunSpeed			= 150
CLASS.StartHealth		= 600
CLASS.MaxHealth			= 600
CLASS.DieSound          = Sound( "npc/zombine/zombine_die2.wav" )

CLASS.TalkSounds        = {"npc/zombine/zombine_alert1.wav",
"npc/zombine/zombine_alert2.wav",
"npc/zombine/zombine_alert3.wav",
"npc/zombine/zombine_alert4.wav",
"npc/zombine/zombine_alert5.wav",
"npc/zombine/zombine_alert6.wav",
"npc/zombine/zombine_alert7.wav",
"npc/zombine/zombine_charge1.wav",
"npc/zombine/zombine_charge2.wav",
"npc/zombine/zombine_idle1.wav",
"npc/zombine/zombine_idle2.wav",
"npc/zombine/zombine_idle3.wav",
"npc/zombine/zombine_idle4.wav",
"npc/zombine/zombine_pain1.wav",
"npc/zombine/zombine_pain4.wav",
"npc/zombine/zombine_readygrenade1.wav",
"npc/zombine/zombine_readygrenade2.wav"}

function CLASS:Loadout( pl )

	pl:Give( "claw_zombiesoldier" )

end

function CLASS:Think( pl )
	
	if ( pl.TalkTime or 0 ) < CurTime() and pl:Alive() then
	
		pl.TalkTime = CurTime() + math.random( 4, 6 )
		pl:EmitSound( Sound( table.Random( self.TalkSounds ) ) )
	
	end
	
end

function CLASS:OnDeath( pl, attacker, dmginfo )
	
	pl:DropGrenade()
	pl:EmitSound( self.DieSound )
	
end

player_class.Register( "Soldier", CLASS )
