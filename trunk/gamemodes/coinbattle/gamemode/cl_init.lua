
include("shared.lua")
include("cl_targetid.lua")
include("cl_scores.lua")
include("cl_hud.lua")
include("cl_splashscreen.lua")
include("cl_help.lua")
include("cl_selectscreen.lua")
include("cl_buymenu.lua")

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

function GM:Initialize()
	
	self.BaseClass:Initialize()
	self:CreateHUDPanels()
	
end

usermessage.Hook("OnRoundResult", function(um)
	
	if um:ReadBool() then
		surface.PlaySound( GAMEMODE.WinSound )
	else
		surface.PlaySound( GAMEMODE.LoseSound )
	end
	
end)

DamageNumberLabels = {}

usermessage.Hook("DamageNotify", function(um)
	
	local t = {}
	t.Pos		= um:ReadVector() + VectorRand()*10
	t.Text		= um:ReadShort()
	t.DieTime	= um:ReadShort()
	t.Col		= Color(153,2,47,255)
	table.insert(DamageNumberLabels,t)
	
end)

function GM:PrePlayerDraw(ply)

	if not(ply == LocalPlayer()) then

		if not ply.CBCloakAlpha then ply.CBCloakAlpha = 255 end

		local bool = ply:GetInvisible()

		if !bool then
			ply.CBCloakAlpha = Lerp(RealFrameTime()*10,ply.CBCloakAlpha,255 )
		else
			if not(ply:Team()==LocalPlayer():Team()) then
				ply.CBCloakAlpha = Lerp(RealFrameTime()*6,ply.CBCloakAlpha,1 )
				if ply.CBCloakAlpha <=10 then
					return true
				end
			else
				ply.CBCloakAlpha = Lerp(RealFrameTime()*6,ply.CBCloakAlpha,127 )
			end
		end

		ply:SetColor(255,255,255,ply.CBCloakAlpha)

	end

end

local CircleMat = Material( "SGM/playercircle" );

function GM:DrawPlayerRing( pPlayer )

	if ( !IsValid( pPlayer ) ) then return end
	if ( pPlayer:GetInvisible() and not(pPlayer:Team() == LocalPlayer():Team())) then return end
	if ( !pPlayer:GetNWBool( "DrawRing", false ) ) then return end
	if ( !pPlayer:Alive() ) then return end
	
	local trace = {}
	trace.start 	= pPlayer:GetPos() + Vector(0,0,50)
	trace.endpos 	= trace.start + Vector(0,0,-300)
	trace.filter 	= pPlayer
	
	local tr = util.TraceLine( trace )
	
	if not tr.HitWorld then
		tr.HitPos = pPlayer:GetPos()
	end

	local color = table.Copy( team.GetColor( pPlayer:Team() ) )
	color.a = 40;

	render.SetMaterial( CircleMat )
	render.DrawQuadEasy( tr.HitPos + tr.HitNormal, tr.HitNormal, GAMEMODE.PlayerRingSize, GAMEMODE.PlayerRingSize, color )	

end

hook.Add( "PrePlayerDraw", "DrawPlayerRing", function( ply ) GAMEMODE:DrawPlayerRing( ply ) end ) 
