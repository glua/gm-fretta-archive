
local CLASS = {}

CLASS.DisplayName			= "Default"
CLASS.WalkSpeed 			= 175
CLASS.CrouchedWalkSpeed 	= 0.65
CLASS.RunSpeed				= 270 // actually walking
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 250
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.Description			= "";
CLASS.Selectable			= false

function CLASS:Loadout( pl )

	pl:RemoveAllAmmo()

	if( gmdm_instagib:GetInt() == 1 ) then
		pl:Give( "gmdm_rail" );
		pl:SetCustomAmmo( "Rails", 100 );
	else
		pl:Give( "gmdm_crowbar" );
		
		pl:SetCustomAmmo( "Rails", 5 )
		pl:SetCustomAmmo( "FireBalls", 1 )
	    pl:SetCustomAmmo( "RPGs", 3 )
		pl:SetCustomAmmo( "TripMines", 3 )
		pl:SetCustomAmmo( "Bolts", 10 )
		pl:SetCustomAmmo( "ElectricityGrenades", 2 );
		
		pl:GiveAmmo( 500, "Pistol", true )	
		pl:GiveAmmo( 150, "SMG1", true )
		pl:GiveAmmo( 64, "buckshot", true )
		
		pl:Give( "gmdm_tripmine" )
		pl:Give( "gmdm_pistol" )
		pl:Give( "gmdm_smg" )
		
		pl:SelectWeapon( "gmdm_smg" ); -- smg is default weapon
	end
	

end

function CLASS:OnSpawn( pl )
	pl:SendLua( "ColorModify[ \"$pp_colour_brightness\" ] = 0.5" );
end

function CLASS:Move( pl, mv )

	if( pl.DoubleJump == nil ) then pl.DoubleJump = false end;
	
	if( !pl:IsOnGround() and pl:KeyPressed( IN_JUMP ) and !pl.DoubleJump ) then
		local vel = mv:GetVelocity();
		mv:SetVelocity( Vector( vel.x, vel.y, self.JumpPower * 1.75 ) );
		pl.DoubleJump = true;
	elseif( pl:IsOnGround() and pl.DoubleJump ) then
		pl.DoubleJump = false;
	end
	
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

player_class.Register( "Default_gmdm", CLASS )