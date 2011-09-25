
local CLASS = {}

CLASS.DisplayName			= "Runner"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.4
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 300
CLASS.DrawViewModel			= false
CLASS.CanUseFlashlight      = false
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.PlayerModel = { "models/player/group03/Female_01.mdl",
	"models/player/group03/Female_02.mdl",
	"models/player/group03/Female_03.mdl",
	"models/player/group03/Female_04.mdl",
	"models/player/group03/Female_06.mdl",
	"models/player/group03/Female_07.mdl",
	"models/player/group03/Male_01.mdl",
	"models/player/group03/Male_02.mdl",
	"models/player/group03/Male_03.mdl",
	"models/player/group03/Male_04.mdl",
	"models/player/group03/Male_05.mdl",
	"models/player/group03/Male_06.mdl",
	"models/player/group03/Male_07.mdl",
	"models/player/group03/Male_08.mdl",
	"models/player/group03/Male_09.mdl" }

function CLASS:Loadout( pl )
	pl:Give( "weapon_crowbar" ) //weapon_hands
end

function CLASS:OnSpawn( pl )

	pl:SendLua( "gui.EnableScreenClicker( true )" ) //Shitty coding ahoy!
	pl:CrosshairDisable() 
	pl:SetMoveType( MOVETYPE_WALK ) //To change from Gamemaster's MOVETYPE_NOCLIP
	pl:SetNoTarget( false ) //Same as above comment
	pl:SetNWBool( "Finished", false )
	pl:SetNWInt( "Stamina", 1000 )
	
end

function CLASS:OnDeath( pl, attacker, dmginfo )
end

function CLASS:Think( pl )

	if ( pl:KeyDown( IN_SPEED ) and pl:GetVelocity():Length() > 1 and ( pl:GetGroundEntity():IsWorld() or pl:GetGroundEntity():IsValid() ) ) then
		pl:SetNWInt( "Stamina", math.Clamp( pl:GetNWInt( "Stamina", 0 ) - 2, 0, 1000 ) )
	else
		pl:SetNWInt( "Stamina", math.Clamp( pl:GetNWInt( "Stamina", 0 ) + 1, 0, 1000 ) )
	end
	
	if ( !pl:GetNWBool( "Exhausted", false ) and pl:KeyDown( IN_SPEED ) and pl:GetNWInt( "Stamina", 0 ) < 5 ) then
		pl:ConCommand( "-speed" )
		pl:SetNWBool( "Exhausted", true )
		timer.Create( pl:UniqueID() .. "Exhaust", 2, 1, function( ply ) ply:SetNWBool( "Exhausted", false ) end, pl )
	end
	
	if ( pl:GetNWBool( "Exhausted", false ) ) then
		pl:ConCommand( "-speed" ) //Shitty way of disabling sprinting. Oh well...
	end
	
end

function CLASS:Move( pl, mv )
end

function CLASS:OnKeyPress( pl, key )
	if ( !pl:GetNWBool( "Exhausted", false ) and key == IN_JUMP and ( pl:GetGroundEntity():IsWorld() or pl:GetGroundEntity():IsValid() ) ) then
		pl:SetNWInt( "Stamina", math.Clamp( pl:GetNWInt( "Stamina", 0 ) - 200, 0, 1000 ) )
	end
end

function CLASS:OnKeyRelease( pl, key )
end

function CLASS:CalcView( ply, origin, angles, fov )
end

player_class.Register( "Runner", CLASS )