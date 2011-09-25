-- Includes
include("shared.lua")
include("Projectiles.lua")
include("cl_hud.lua")
include("cl_splashscreen.lua")
include("cl_radar.lua")
include("cl_scoreboard.lua")
--include( 'vgui/vgui_scoreboard.lua' )
CreateClientConVar("cam_relative",0,true,true)
GM.PlayerRingSize = 64

local ang = Angle(0,90,0)
local viewtab = {["angles"] = Angle(90,0,-90)}
local refoffset = Vector(0,0,GM.MaxCameraHeight)
local poffset = Vector(0,0,GM.MaxCameraHeight)
local tracetab = {}
tracetab.mask = CONTENTS_SOLID
tracetab.mins = Vector(-16,-16,-16)
tracetab.maxs = Vector(16,16,16)
local lasttrace = 0
local gtvcol = Color(53,157,211,255)

/*---------------------------------------------------------
   Name: gamemode:CalcView( Player ply, Vector origin, Angles angles, Number fov )
   Desc: Calculates the position of the top-down camera
---------------------------------------------------------*/
function GM:CalcView( ply, origin, angles, fov )
	local ent = GetViewEntity()
	tracetab.start = origin
	tracetab.endpos = origin+refoffset
	viewtab.origin = origin+poffset
	if !ent:IsValid() || ((LocalPlayer():Team() == TEAM_SPECTATOR) && (LocalPlayer():GetObserverMode() != OBS_MODE_CHASE)) then
		return self.BaseClass:CalcView(ply, origin, angles, fov)
	end
	tracetab.filter = ent
	local tr = util.TraceHull(tracetab)
	if ent:IsPlayer() && ent:Alive() then
		poffset.z = math.Approach(poffset.z,tr.HitPos.z-tracetab.start.z,(CurTime()-lasttrace)*1200)
	end
	lasttrace = CurTime()
	viewtab.fov = math.Clamp((GAMEMODE.MaxCameraHeight-poffset.z)/5,75,120)
	return viewtab
end

/*---------------------------------------------------------
   Name: gamemode:CreateMove( command )
   Desc: Allows the client to change the move commands 
			before it's send to the server
---------------------------------------------------------*/
function GM:CreateMove( cmd )
	if (LocalPlayer():Team() != TEAM_SPECTATOR) then	
		if LocalPlayer():Alive() then
			local pos = LocalPlayer():GetPos():ToScreen()
			cmd:SetViewAngles(Angle(0,-1*math.Rad2Deg(math.atan2(gui.MouseY()-pos.y,gui.MouseX()-pos.x)),0))
		else
			cmd:SetViewAngles(Angle(-90,0,0))
		end
	end
	return cmd
end

/*---------------------------------------------------------
   Name: gamemode:CallScreenClickHook( bDown, mousecode, AimVector )
   Desc: Called when clicked on the screen, 
---------------------------------------------------------*/
function GM:CallScreenClickHook( bDown, mousecode, AimVector )
	if mousecode == MOUSE_LEFT then
		if bDown then
			RunConsoleCommand("+attack")
		else
			RunConsoleCommand("-attack")
		end
	end
	if mousecode == MOUSE_RIGHT then
		if bDown then
			RunConsoleCommand("+attack2")
		else
			RunConsoleCommand("-attack2")
		end
	end
	local i = 0
	if ( bDown ) then i = 1 end
	
	// Tell the server that we clicked on the screen so it can actually do stuff.
	RunConsoleCommand( "cnc", i, mousecode, AimVector.x, AimVector.y, AimVector.z )
	
	// And let us predict it clientside
	hook.Call( "ContextScreenClick", GAMEMODE, AimVector, mousecode, bDown, LocalPlayer() )

end

/*---------------------------------------------------------
   Name: gamemode:Move
   This basically overrides the NOCLIP, PLAYERMOVE movement stuff.
   It's what actually performs the move. 
   Return true to not perform any default movement actions. (completely override)
---------------------------------------------------------*/
function GM:Move( ply, movedata)
	if ((ply == LocalPlayer()) && (GetConVarNumber("cam_relative") == 0) && (LocalPlayer():Team() != TEAM_SPECTATOR)) then
		movedata:SetMoveAngles(ang)
	end
end

/*---------------------------------------------------------
   Name: gamemode:Think( )
   Desc: Called every frame
---------------------------------------------------------*/
function GM:Think( )
	self.BaseClass:Think()
	if !GAMEMODE.IsEndOfGame then
		gui.EnableScreenClicker(LocalPlayer():Team() != TEAM_SPECTATOR)
	end
end

function GM:PlayerFootstep()
	return true
end

function GM:PlayerBindPress( pl, bind, down )
	if string.find(bind,"+duck") then
		return true
	end
	// Redirect binds to the spectate system
	if ( pl:IsObserver() && down ) then
	
		if ( bind == "+jump" ) then 	RunConsoleCommand( "spec_mode" )	end
		if ( bind == "+attack" ) then	RunConsoleCommand( "spec_next" )	end
		if ( bind == "+attack2" ) then	RunConsoleCommand( "spec_prev" )	end
		
	end
	
	return false	
	
end

local score_efdata = EffectData()
usermessage.Hook("gtv_score",function(um)
	local pos = um:ReadVector()
	local score = um:ReadShort()
	score_efdata:SetOrigin(pos)
	score_efdata:SetScale(score)
	util.Effect("ef_gtv_score",score_efdata)
end)

local arrowtex = surface.GetTextureID("gtv/arrowframe")
//local colvec = Vector(1,1,1)
local arrowmat = Material("gtv/arrowframe")

local aftracep = {} --make this different
	aftracep.mask = MASK_SHOT


function GM:HUDPaint()
	for k,v in ipairs(player.GetAll()) do 
		if (v != GetViewEntity()) && (v:Team() != TEAM_SPECTATOR) && v:Alive() then
			gamemode.Call("DrawPlayerOnRadar",v)
		end
	end
	if LocalPlayer():Team() != TEAM_SPECTATOR then
		for k,v in ipairs(ents.FindByClass("gtv_item")) do
			local tab = gtv_itemtable[v.dt.ItemType]
			local pos = v:GetPos():ToScreen()
			local tr
			if tab.Icon then
				aftracep.filter = v
				aftracep.start = v:GetPos()
				aftracep.endpos = EyePos()
				tr = util.TraceLine(aftracep)
			end
			if tr && !tr.Hit then
				local col = tab.Color
				local x,y = pos.x,pos.y
				y = y-32
				surface.SetDrawColor(255,255,255,255)
				surface.DrawRect(x-24,y-48,48,32)
				surface.SetDrawColor(col.r,col.g,col.b,255)
				surface.SetTexture(arrowtex)
				surface.DrawTexturedRect(x-24,y-48,48,48)	
				surface.SetDrawColor(col.r,col.g,col.b,255)
				surface.SetTexture(tab.Icon)
				surface.DrawTexturedRect(x-16,y-48,32,32)
			end
		end
	end
	self.BaseClass:HUDPaint()
end



--HAAAAAAAAAAAAAANK

local CircleMat = Material( "playercircle2" )

--got lazy
--don't be mad
--if it's any condolances i decided to play more l4d2
-- it's a sabotaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaage
local rendercol = Color(255,255,255,40)

function GM:DrawPlayerRing( pl )
	if ( !IsValid( pl ) ) then return end
	if ( !pl:GetNWBool( "DrawRing", false ) ) then return end
	if ( !pl:Alive() ) then return end
	
	local trace = {}
	trace.start 	= pl:GetPos() + Vector(0,0,50)
	trace.endpos 	= trace.start + Vector(0,0,-300)
	trace.filter 	= pl
	
	local tr = util.TraceLine( trace )
	
	if not tr.HitWorld then
		tr.HitPos = pl:GetPos()
	end
	local col = list.GetForEdit("PlayerColours")[pl:GetNWString("pl_color")] --we don't want to make a copy, more efficient this way since we know how to NOT fuck it up
		if col then
			rendercol.r = col.r --using an existing color object saves us 60xNumberOfPlayers or howevermany color objects a second for GC to handle!
			rendercol.g = col.g
			rendercol.b = col.b
		else
			rendercol.r = 255
			rendercol.g = 255
			rendercol.b = 255
		end
		render.SetMaterial( CircleMat )

		local fwd1 = pl:GetAimVector()
		fwd1.z = 0
		fwd1:Normalize()
		local rt = tr.HitNormal:Cross(fwd1)
		local fwd = rt:Cross(tr.HitNormal)
		rt = rt*GAMEMODE.PlayerRingSize*-0.5
		fwd = fwd*GAMEMODE.PlayerRingSize*0.5
		cam.Start3D(EyePos(),EyeAngles())
			render.SetColorModulation(rendercol.r/256,rendercol.g/256,rendercol.b/256)
			render.SetBlend(1)
			CircleMat:SetMaterialVector("$color",Vector(rendercol.r/256,rendercol.g/256,rendercol.b/256))
			render.DrawQuad(tr.HitPos+tr.HitNormal+fwd-rt,tr.HitPos+tr.HitNormal+fwd+rt,tr.HitPos+tr.HitNormal-fwd+rt,tr.HitPos+tr.HitNormal-fwd-rt)
			render.SetColorModulation(1,1,1)
			render.SetBlend(1)
		cam.End3D()
		//render.DrawQuadEasy( tr.HitPos + tr.HitNormal, tr.HitNormal, GAMEMODE.PlayerRingSize, GAMEMODE.PlayerRingSize, rendercol , pl:GetAimVector():Angle().y)	
end

function GM:OnRoundEnd()
	local pl = NULL
	local highestscore = 0
	for k,v in ipairs(player.GetAll()) do
		if v:Frags() > highestscore then
			pl = v
			highsetscore = pl:Frags()
		end
	end
	if pl:IsValid() && (GetGlobalFloat("RoundNumber") != 0) then
		chat.AddText(pl,color_white," was the best contestant, winning Round ",tostring(GetGlobalFloat("RoundNumber"))," with a score of ",gtvcol,NumberToStringWithSeparators(pl:Frags()),color_white," points!")
	end
end
