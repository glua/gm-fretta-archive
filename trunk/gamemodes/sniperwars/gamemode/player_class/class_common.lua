local CLASS = {}

CLASS.DisplayName			= "SniperCommon"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true

function CLASS:OnSpawn( ply )

	ply:SetDeathCamTarget()
	ply:Cloak( false )
	ply:SpawnArmor( 5 )
	
	local model = ply:GetInfo( "cl_playermodel" )
	
	if string.find( model, "zombine" ) or string.find( model, "charple" ) then
		ply:SetModel( "models/player/breen.mdl" )
	end
	
end

player_class.Register( "SniperCommon", CLASS )