//Seeker class
CLASS = {};

CLASS.DisplayName			= "Seeker";
CLASS.Description			= "Seeker class"
CLASS.WalkSpeed 			= 275;
CLASS.CrouchedWalkSpeed 	= 0.34;
CLASS.RunSpeed				= 100;
CLASS.DuckSpeed				= 0.05;
CLASS.JumpPower				= 200;
CLASS.PlayerModel			= Model( "models/player/swat.mdl" );
CLASS.MaxHealth				= 100;
CLASS.StartHealth			= 100;
CLASS.StartArmor			= 0;
CLASS.DropWeaponOnDie		= false;
CLASS.TeammateNoCollide 	= false;
CLASS.AvoidPlayers			= false;

function CLASS:Loadout(pl)
	pl:Give("weapon_crowbar")
	pl:ChatPrint("Press C to open hide and seek shop")
	local plytable = pl.Loadout or {}
	for k,v in pairs(plytable) do
		pl:Give(ShopTable[v][3])
	end
//	pl:Give("hns_invis")
//	if #team.GetPlayers(TEAM_SEEKERS) == 1 then
//		pl:Give("weapon_physcannon")
//	end
end

function CLASS:OnSpawn( pl )
	pl:GodEnable()
	pl:SetNWBool("HasInvis", true)
end

function CLASS:OnDeath( pl )
	pl:GodDisable()
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
	return false
end

player_class.Register("seeker", CLASS)