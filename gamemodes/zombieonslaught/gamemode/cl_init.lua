include( 'shared.lua' )
include( 'cl_postprocess.lua' )
include( 'admin.lua' )
include( 'cl_notice.lua' )
include( 'cl_splashscreen.lua' )
include( 'cl_hud.lua' )
include( 'cl_endgamesplash.lua' )

function GM:Initialize()

	self.BaseClass:Initialize()
	
	Stains = {}
	StainMats = { surface.GetTextureID( "blood/Blood1" ),
	surface.GetTextureID( "blood/Blood2" ),
	surface.GetTextureID( "blood/Blood3" ),
	surface.GetTextureID( "blood/Blood4" ),
	surface.GetTextureID( "blood/Blood5" ),
	surface.GetTextureID( "blood/Blood6" ),
	surface.GetTextureID( "blood/Blood7" ),
	surface.GetTextureID( "blood/Blood8" ) }
	
	HeartBeat = 0
	HumanEmitter = nil
	
	language.Add( "npc_zombie_normal", "Zombie" )
	language.Add( "npc_zombie_fast", "Fast Zombie" )
	language.Add( "npc_zombie_poison", "Poison Zombie" )
	
	surface.CreateFont( "28 Days Later", 32, 400, true, false, "FragsText" )
	surface.CreateFont( "28 Days Later", 28, 400, true, false, "RedeemText" )
	surface.CreateFont( "Typenoksidi", 20, 500, true, false, "ZONoticeText" )
	
end

function GM:Think()

	self.BaseClass:Think()
	
	GAMEMODE:FadeRagdolls()
	
	if not HumanEmitter then
		HumanEmitter = ParticleEmitter( LocalPlayer():GetPos() )
	end
	local pos = LocalPlayer():GetPos()
	for k, ply in pairs( team.GetPlayers( TEAM_ALIVE ) ) do
	
		local trgpos = ply:GetPos() + Vector(0,0,55)
		
		if ply:KeyDown( IN_DUCK ) then
			trgpos = ply:GetPos() + Vector(0,0,20)
		end
		
		if ply != LocalPlayer() and ply:Alive() and trgpos:Distance( pos ) < 4000 then
		
			local scale = math.Clamp( ply:Health() / 100, 0, 1 )
			for i=1, math.random( 1, 3 ) do
				local par = HumanEmitter:Add( "sprites/light_glow02_add_noz.vmt", trgpos )
				par:SetVelocity( VectorRand() * 30 )
				par:SetDieTime( 0.5 )
				par:SetStartAlpha( 255 )
				par:SetEndAlpha( 0 )
				par:SetStartSize( math.random( 2, 10 ) )
				par:SetEndSize( 0 )
				par:SetColor( 255 - scale * 255, 55 + scale * 200, 50 ) 
				par:SetRoll( math.random( 0, 300 ) )
			end
		end
	end
	
	if LocalPlayer():Team() == TEAM_ALIVE and LocalPlayer():Alive() and LocalPlayer():Health() <= 25 and HeartBeat < CurTime() then
	
		local scale = LocalPlayer():Health() / 25
		HeartBeat = CurTime() + 0.5 + scale * 1.5
		
		LocalPlayer():EmitSound( Sound("koth/heartbeat.wav"), 100, 150 - scale * 50 )
		
	end
	
end

function GM:FadeRagdolls()

	for k,v in pairs( ents.FindByClass( "class C_ClientRagdoll" ) ) do
	
		if v.Time and v.Time < CurTime() then
		
			v:SetColor( 255, 255, 255, v.Alpha )
			v.Alpha = math.Approach( v.Alpha, 0, -2 )
			
			if v.Alpha <= 0 then
				v:Remove()
			end
		
		elseif not v.Time then
		
			v.Time = CurTime() + 10
			v.Alpha = 255
		
		end
	end
end

function GM:HUDShouldDraw( name )

	if GAMEMODE.ScoreboardVisible then return false end
	
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end 
  	end 
	
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
		return false
	end
	
	return true
	
end

function GM:HUDWeaponPickedUp()

end

function GM:HUDDrawPickupHistory()

end

function DoPoison( msg )

	for i=1, 3 do
		AddStain()
	end
	
	DisorientTime = CurTime() + 60
	ViewWobble = 0.5
	
	Sharpen = 4.5
	
	ColorModify[ "$pp_colour_addr" ] = 0.40
	ColorModify[ "$pp_colour_addg" ] = 0.20
	
end
usermessage.Hook("Poison", DoPoison)

function GM:AddScoreboardKills( ScoreBoard )

	local f = function( ply ) return ply:Frags() end
	ScoreBoard:AddColumn( "Bones", 50, f, 0.5, nil, 6, 6 )

end

local ClassChooser = nil 
cl_classsuicide = CreateConVar( "cl_classsuicide", "0", { FCVAR_ARCHIVE } )

function GM:ShowClassChooser( TEAMID )

	if ( !GAMEMODE.SelectClass ) then return end
	if ( ClassChooser ) then ClassChooser:Remove() end

	ClassChooser = vgui.CreateFromTable( vgui_Splash )
	ClassChooser:SetHeaderText( "Choose Class" )
	ClassChooser:SetHoverText( "What class do you want to be?" )

	Classes = team.GetClass( TEAMID )
	for k, v in SortedPairs( Classes ) do
	
		if not LocalPlayer():GetNWBool( "FirstZombie", false ) and v == "Soldier" then
			break
		end
		
		local displayname = v
		local Class = player_class.Get( v )
		if ( Class && Class.DisplayName ) then
			displayname = Class.DisplayName
		end
		
		local description = "Click to spawn as " .. displayname
		
		if( Class and Class.Description ) then
			description = Class.Description
		end
		
		local func = function() if( cl_classsuicide:GetBool() ) then RunConsoleCommand( "kill" ) end RunConsoleCommand( "changeclass", k ) end
		local btn = ClassChooser:AddSelectButton( displayname, func, description )
		btn.m_colBackground = team.GetColor( TEAMID )
	
	end
	
	ClassChooser:AddCancelButton()
	ClassChooser:MakePopup()
	ClassChooser:NoFadeIn()

end

