//Seeker class
CLASS = {};

CLASS.DisplayName			= "Hider";
CLASS.Description			= "Default hider class"
CLASS.WalkSpeed 			= 250;
CLASS.CrouchedWalkSpeed 	= 0.34;
CLASS.RunSpeed				= 100;
CLASS.DuckSpeed				= 0.05;
CLASS.JumpPower				= 400;
CLASS.PlayerModel			= Model( "models/player/leet.mdl" );
CLASS.MaxHealth				= 1;
CLASS.StartHealth			= 1;
CLASS.StartArmor			= 0;
CLASS.DropWeaponOnDie		= false;
CLASS.TeammateNoCollide 	= false;
CLASS.AvoidPlayers			= false;

function CLASS:Loadout(pl)
//	pl:Give("weapon_crowbar")
//	pl:Give("hns_invis")
//	if #team.GetPlayers(TEAM_SEEKERS) == 1 then
//		pl:Give("weapon_physcannon")
//	end
end

function CLASS:OnSpawn( pl )
//	pl:GodEnable()
	pl:SetNWBool("HasInvis", true)
end

function CLASS:OnDeath( pl )
//	pl:GodDisable()
end

function CLASS:Think( pl )
end

function CLASS:Move( pl, mv )
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

function CLASS:Footstep( ply, pos, foot, sound, volume, rf )
//	return false
end

player_class.Register("hider", CLASS)