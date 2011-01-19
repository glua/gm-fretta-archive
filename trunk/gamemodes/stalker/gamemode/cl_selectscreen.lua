
WeaponNames = {}

function RegisterName( weaponname, nicename )

	table.insert( WeaponNames, { Weapon = weaponname, Name = nicename } )
	
end

RegisterName( "Tracker", "Tracker Bullets" )
RegisterName( "Recharger", "Improved Recharger" )

function GetNiceWeaponName( weaponname )

	for k,v in pairs( WeaponNames ) do
		
		if v.Weapon == weaponname then
			
			return v.Name
			
		end
		
	end
	
	return weaponname

end

local TeamPanel = nil

function GM:ShowTeam()

	if ( !IsValid( TeamPanel ) ) then 
	
		TeamPanel = vgui.CreateFromTable( vgui_Splash )
		TeamPanel:SetHeaderText( "Choose Team" )

		local AllTeams = team.GetAllTeams()
		for ID, TeamInfo in SortedPairs ( AllTeams ) do
		
			if ( ID != TEAM_CONNECTING && ID != TEAM_UNASSIGNED && ID != TEAM_STALKER && ( ID != TEAM_SPECTATOR || GAMEMODE.AllowSpectating ) && team.Joinable( ID ) ) then
			
				if ( ID == TEAM_SPECTATOR ) then
					TeamPanel:AddSpacer( 10 )
				end
			
				local strName = TeamInfo.Name
				local func = function() RunConsoleCommand( "changeteam", ID ) end
			
				local btn = TeamPanel:AddSelectButton( strName, func )
				btn.m_colBackground = TeamInfo.Color
				btn.Think = function( self ) 
								self:SetText( Format( "%s (%i)", strName, team.NumPlayers( ID ) ))
								self:SetDisabled( GAMEMODE:TeamHasEnoughPlayers( ID ) ) 
							end
				
				if (  IsValid( LocalPlayer() ) && LocalPlayer():Team() == ID ) then
					btn:SetDisabled( true )
				end
				
			end
			
		end
		
		TeamPanel:AddCancelButton()
		
	end
	
	TeamPanel:MakePopup()

end

local ClassChooser = nil

function GM:ShowClassChooser( TEAMID )

	if ( !GAMEMODE.SelectClass ) then return end
	if ( ClassChooser ) then ClassChooser:Remove() end

	ClassChooser = vgui.CreateFromTable( vgui_Splash )
	ClassChooser:SetHeaderText( "Choose Loadout" )

	Classes = team.GetClass( TEAMID )
	for k, v in SortedPairs( Classes ) do
		
		local displayname = v
		local Class = player_class.Get( v )
		if ( Class && Class.DisplayName ) then
			displayname = Class.DisplayName
		end
		
		local description = "Spawn with a " .. displayname
		
		if( Class and Class.Description ) then
			description = Class.Description
		end
		
		local func = function() if( cl_classsuicide:GetBool() ) then RunConsoleCommand( "kill" ) end RunConsoleCommand( "changeclass", k ) GAMEMODE:ShowPrimaries( Class ) end
		local btn = ClassChooser:AddSelectButton( displayname, func, description )
		
		btn.m_colBackground = team.GetColor( TEAM_HUMAN )
		
	end
	
	ClassChooser:AddCancelButton()
	ClassChooser:MakePopup()
	ClassChooser:NoFadeIn()

end

local PrimaryPanel = nil

function GM:ShowPrimaries( class )

	if ( !IsValid( PrimaryPanel ) ) then 
	
		PrimaryPanel = vgui.CreateFromTable( vgui_Splash )
		PrimaryPanel:SetHeaderText( "Choose Utility" )

		for k,v in pairs( class.Utilities ) do
			
			local func = function() RunConsoleCommand( "changeutility", v ) end		
			local btn = PrimaryPanel:AddSelectButton( GetNiceWeaponName( v ), func, class.UtilDescriptions[k] )
	
			btn.m_colBackground = team.GetColor( TEAM_HUMAN )
			
		end
		
	end
	
	PrimaryPanel:MakePopup()
	PrimaryPanel:NoFadeIn()

end
