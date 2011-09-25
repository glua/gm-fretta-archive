
local CLASS = {}

CLASS.DisplayName			= "Police"
CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 250
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 150
CLASS.StartHealth			= 150
CLASS.PlayerModel           = Model( "models/player/swat.mdl" )
CLASS.Weapons               = { "gta_m4", "gta_m4_silenced", "gta_ump45", "gta_mp5", "gta_tmp" }

function CLASS:Loadout( pl )

	pl:Give( table.Random( self.Weapons ) )
	pl:Give( "gta_billyclub" )
	pl:SetCash( 0 )
	
end

function CLASS:OnDeath( pl )

	local weapon = pl:GetActiveWeapon()
	local name
	
	if ValidEntity( weapon ) then
		name = weapon:GetClass()
	end

	if !name or name == "gta_billyclub" then
		name = "gta_tmp"
	end
	
	local drop = ents.Create( "sent_pickup" )
	drop:SetPos( pl:GetPos() + Vector(0,0,25) )
	drop:SetType( name )
	drop:Spawn()

end

player_class.Register( "Police", CLASS )