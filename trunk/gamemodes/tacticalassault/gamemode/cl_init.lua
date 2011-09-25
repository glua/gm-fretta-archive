include( 'shared.lua' )
include( 'cl_ambience.lua' )
include( 'cl_hud.lua' )
include( 'cl_vgui.lua' )
include( 'util.lua' )

surface.CreateFont( "HalfLife2", SScale( 20 ), 0, true, true, "HudNumber20" )
surface.CreateFont( "Army", 25, 400, true, false, "ObjectiveFontPrimary" )
surface.CreateFont( "Army", 18, 400, true, false, "ObjectiveFontSecondary" )
surface.CreateFont( "Army",  40, 400, true, false, "AmmoFontPrimary" )

language.Add("sent_sakariashelicopter","Helicopter")
language.Add("sent_sakariasjet","Fighter")
language.Add("sent_notargetmissile","Missile")
language.Add("sent_heli","Helicopter")
language.Add("sent_humvee","Humvee")
language.Add("sent_striderturret","Strider Turret")
language.Add("AirboatGun","Machine Gun")
language.Add("AirboatGun_ammo","Machine Gun")

local Color_Icon = Color( 255, 80, 0, 255 )
killicon.AddFont( "weapon_mad_mp7",                "HL2MPTypeDeath",       "/",    Color_Icon )
killicon.AddFont( "weapon_mad_ar2",                 "HL2MPTypeDeath",       "2",    Color_Icon )
killicon.AddFont( "weapon_mad_awp",              "HL2MPTypeDeath",       "1",    Color_Icon )
killicon.AddFont( "weapon_mad_spas",     "HL2MPTypeDeath",       "0",    Color_Icon )
killicon.AddFont( "weapon_mad_rpg",                "HL2MPTypeDeath",       "3",    Color_Icon )
killicon.AddFont( "weapon_mad_grenade",   "HL2MPTypeDeath",       "4",    Color_Icon )
killicon.AddFont( "weapon_mad_usp_match",              "HL2MPTypeDeath",       "-",    Color_Icon )

killicon.Add( "weapon_mad_fists", "HUD/killicons/fists_killicon", color_white )
killicon.Add( "npc_satchel", "HUD/killicons/slam_killicon", color_white )
killicon.Add( "npc_tripmine", "HUD/killicons/slam_killicon", color_white )
killicon.Add( "env_explosion", "HUD/killicons/slam_killicon", color_white )

PrecacheParticleSystem("building_explosion")

function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function GM:UpdateHUD_Alive()
end
		
// Death view
local bright,cont,col = 0,1,1
hook.Add("RenderScreenspaceEffects","TestDeath",function()
	if !LocalPlayer():Alive() then
		
		bright = math.Approach(bright, -0.11,0.005)
		cont = math.Approach(cont,0.56,0.005)
		col = math.Approach(col,0,0.005)
	
		local ScrColTab = {}
		ScrColTab[ "$pp_colour_addr" ] 		= 0
		ScrColTab[ "$pp_colour_addg" ] 		= 0
		ScrColTab[ "$pp_colour_addb" ] 		= 0
		ScrColTab[ "$pp_colour_brightness" ]= bright
		ScrColTab[ "$pp_colour_contrast" ] 	= cont
		ScrColTab[ "$pp_colour_colour" ] 	= col
		ScrColTab[ "$pp_colour_mulr" ] 		= 0
		ScrColTab[ "$pp_colour_mulg" ] 		= 0
		ScrColTab[ "$pp_colour_mulb" ] 		= 0
		DrawColorModify(ScrColTab)
		
		ta.StopLowHealth()
		
	elseif LocalPlayer():Health() < 20 then
	
		DrawMotionBlur( 0.25, 0.7, 0)
		
	else 
		bright,cont,col = 0,1,1	
		ta.StopLowHealth()
	end
		
end)

// Recieve killstreak info
usermessage.Hook("ta-killstreak",function(um) 
	local killer,kills = um:ReadEntity(),um:ReadShort()
	timer.Simple(0.05,function() ta.AddKillStreak(killer,kills) end) 
end)

// Stop death sounds
usermessage.Hook("ta-death",function(u) 
	local b = u:ReadBool()
	if b then ta.StopLowHealth() else ta.LowHealth() end
end)

local LastStrafeRoll = 0
local WalkTimer = 0
local VelSmooth = 0
local DeathSmooth = 0
function GM:CalcView( ply, origin, angle, fov )
 
	if !ply:Alive() then
		local rag = ply:GetRagdollEntity()
		if !rag then return end
		local att = rag:GetAttachment( rag:LookupAttachment("eyes") )
		if att then
			att.Pos = att.Pos + att.Ang:Forward() * 1
			
			origin = att.Pos
			angle = att.Ang
			
			local tr = util.TraceLine({start = origin,endpos = origin + angle:Forward() * 100000,filter = rag})
			if tr.HitPos:Distance(origin) < 50 then end
		end
		fov = 55
	else
		VelSmooth = math.Clamp( VelSmooth * 0.9 + ply:GetVelocity():Length() * 0.08, 0, 700 )
		if ply:GetPlayerClassName() == "Runner" then VelSmooth = VelSmooth / 1.2 end
		WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05

		if ply:IsOnGround() then	
			angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
			angle.pitch = angle.pitch + math.cos( WalkTimer * 0.5 ) * VelSmooth * 0.003
			angle.yaw = angle.yaw + math.cos( WalkTimer ) * VelSmooth * 0.003
		end
	end
 
	return self.BaseClass:CalcView(ply,origin,angle,fov)
 
end
