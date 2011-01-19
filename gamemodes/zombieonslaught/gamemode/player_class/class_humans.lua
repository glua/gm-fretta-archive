
local CLASS = {}

CLASS.DieSounds = {"vo/npc/male01/pain01.wav",
"vo/npc/male01/pain02.wav",
"vo/npc/male01/pain03.wav",
"vo/npc/male01/pain04.wav",
"vo/npc/male01/pain05.wav",
"vo/npc/male01/pain06.wav",
"vo/npc/male01/pain07.wav",
"vo/npc/male01/pain08.wav",
"vo/npc/male01/pain09.wav",
"vo/streetwar/sniper/male01/c17_09_help01.wav",
"vo/streetwar/sniper/male01/c17_09_help02.wav",
"vo/npc/male01/help01.wav",
"vo/npc/male01/gordead_ans06.wav",
"vo/coast/bugbait/sandy_help.wav",
"vo/coast/odessa/male01/nlo_cubdeath01.wav",
"vo/coast/odessa/male01/nlo_cubdeath02.wav",
"vo/npc/male01/ow01.wav",
"vo/npc/male01/ow02.wav",
"vo/npc/male01/no01.wav",
"vo/npc/male01/no02.wav",
"vo/npc/male01/ohno.wav"}

CLASS.DisplayName			= "Survivor"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.2
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.TeammateNoCollide 	= false//true TODO: change these back when hulltraces are fixed properly
CLASS.AvoidPlayers			= false//true

function CLASS:Loadout( pl )

	pl:Give("weapon_zo_p228")
	
end

function CLASS:Move( pl, mv )

	if pl:KeyDown(IN_BACK) then
	
		if pl:KeyDown(IN_SPEED) then
		
			mv:SetMaxSpeed(200)
			
		else
		
			mv:SetMaxSpeed(150)
			
		end
	end
end

function CLASS:Think( pl )

	pl:Think()

end

function CLASS:OnDeath( pl )
	
	pl:EmitSound( Sound( table.Random( self.DieSounds ) ) )

end

player_class.Register( "BaseSurvivor", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseSurvivor"
CLASS.DisplayName		= "Engineer"
CLASS.Description       = "Engineers can build barricades with their toolkit."
CLASS.PlayerModel       = {"models/player/Group01/male_01.mdl",
							"models/player/Group01/male_02.mdl",
							"models/player/Group01/male_03.mdl",
							"models/player/Group01/male_04.mdl",
							"models/player/Group01/male_05.mdl",
							"models/player/Group01/male_06.mdl",
							"models/player/Group01/male_07.mdl",
							"models/player/Group01/male_08.mdl",
							"models/player/Group01/male_09.mdl"}

function CLASS:Loadout( pl )

	pl:Give("weapon_zo_p228")
	pl:Give("weapon_zo_toolkit")
	
end

player_class.Register( "Engineer", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseSurvivor"
CLASS.DisplayName		= "Medic"
CLASS.Description       = "Medics can heal themselves and others periodically with their medikit."
CLASS.PlayerModel       = {"models/player/kleiner.mdl", 
							"models/player/hostage/hostage_01.mdl",
							"models/player/hostage/hostage_04.mdl"}

function CLASS:Loadout( pl )

	pl:Give("weapon_zo_p228")
	pl:Give("weapon_zo_medikit")
	
end

player_class.Register( "Medic", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseSurvivor"
CLASS.DisplayName		= "Support"
CLASS.Description       = "The support class can supply itself and other classes with ammo."
CLASS.PlayerModel       = "models/player/odessa.mdl"

function CLASS:Loadout( pl )

	pl:Give("weapon_zo_p228")
	pl:Give("weapon_zo_ammokit")
	
end

player_class.Register( "Support", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseSurvivor"
CLASS.DisplayName		= "Militant"
CLASS.Description       = "Militants start with more health than any other class and carry a melee weapon."
CLASS.StartHealth		= 125
CLASS.MaxHealth			= 125
CLASS.PlayerModel       = {"models/player/Group03/male_01.mdl", 
							"models/player/Group03/male_02.mdl", 
							"models/player/Group03/male_03.mdl", 
							"models/player/Group03/male_04.mdl", 
							"models/player/Group03/male_05.mdl", 
							"models/player/Group03/male_06.mdl"}

function CLASS:Loadout( pl )

	pl:Give("weapon_zo_p228")
	pl:Give("weapon_zo_crowbar")
	
end

player_class.Register( "Militant", CLASS )