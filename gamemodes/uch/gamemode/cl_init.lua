include("shared.lua")
include("cl_hud.lua")
include("cl_killnotices.lua")

include("cl_help.lua")
include("cl_scoreboard.lua")
include("cl_selectscreen.lua")
include("cl_splashscreen.lua")
include("cl_voice.lua")


function GM:Initialize()
	
	self.BaseClass:Initialize();
	
end



local txtmat = surface.GetTextureID("UCH/logo/UClogo1");
local tailmat = surface.GetTextureID("UCH/logo/UClogo2");
local birdmat = surface.GetTextureID("UCH/logo/UClogo3");
local btnmat = surface.GetTextureID("UCH/logo/UClogo4");
local wingmat = surface.GetTextureID("UCH/logo/UClogo5");
local expmat = surface.GetTextureID("UCH/logo/UClogo6");

local waverot = 0;
local wavetime = (CurTime() + 6);

local function LogoThink()
	
	//waving (!)
	local t = (wavetime - CurTime());
	if (t < 0) then
		wavetime = (CurTime() + math.random(12, 24));
	end
	if (t > 1.25) then
		waverot = math.Approach(waverot, 0, (FrameTime() * 75));
	else
		local num = (16 * math.sin((CurTime() * 12)))
		waverot = math.Approach(waverot, num, (FrameTime() * 400));
	end
		
	
end
hook.Add("Think", "LogoThink", LogoThink);

function GM:DrawLogo(x, y, size)
	
	local size = (size || 1); //if they didn't specify size, just default it to 1
	
	surface.SetDrawColor(255, 255, 255, 255);
	
	
	local txtw = ((ScrH() * .8) * size);
	local txth = (txtw * .5);
	
	
	//Wing 1
	local w = (txth * .575);
	local h = w;
	
	local deg = 8;
	local sway = (deg * math.sin((CurTime() * 1.25)));
	
	surface.SetTexture(wingmat);
	surface.DrawTexturedRectRotated((x - (txtw * .038)), (y - (txth * .205)), w, h, (-36 + sway));
	
	
	//Button
	local w = (txth * .116);
	local h = w;
	
	surface.SetTexture(btnmat);
	surface.DrawTexturedRect((x - (txtw * .0625)), (y - (txth * .27)), w, h);
	
	
	//Wing 2
	local w = (txth * .575);
	local h = w;
	
	local deg = 8;
	local sway = (deg * math.sin((CurTime() * 1)));
	
	surface.SetTexture(wingmat);
	surface.DrawTexturedRectRotated((x - (txtw * .05)), (y - (txth * .21)), w, h, (-4 + sway));
	
	
	//Tail
	local w = (txtw * .14);
	local h = (w * 4);

	local deg = 6;
	local sway = (deg * math.sin((CurTime() * 2)));
	
	surface.SetTexture(tailmat);
	surface.DrawTexturedRectRotated((x - (txtw * .255)), (y - (txth * .145)), w, h, (-6 + sway));
	
	
	//Bird
	local w = (txth * .28);
	local h = w;
	
	surface.SetTexture(birdmat);
	surface.DrawTexturedRect((x + (txtw * .146)), (y - (txth * .3575)), w, h);
	
	
	// (!)
	local w = (txth * .64);
	local h = w;
	
	surface.SetTexture(expmat);
	surface.DrawTexturedRectRotated((x + (txtw * .2425)), (y + (txth * .09)), w, h, waverot);
	
	
	//Text
	surface.SetTexture(txtmat);
	surface.DrawTexturedRect((x - (txtw * .5)), (y - (txth * .5)), txtw, txth);
	
end



function GM:PositionScoreboard(ScoreBoard)
	
	ScoreBoard:SetSize(700, ScrH() - 100);
	ScoreBoard:SetPos((ScrW() - ScoreBoard:GetWide()) / 2, 50);
	
end


function GM:ShowGamemodeChooser()
	
	if (!self.PlayingVoteMusic) then
		
		self.PlayingVoteMusic = true;
		
		local musix = (LocalPlayer().VoteMusic || "music3.mp3");
		surface.PlaySound("UCH/music/voting/" .. musix);
		
	end
	
	self:ScoreboardHide();
	
	self.BaseClass:ShowGamemodeChooser(self);
	
end


function GM:PaintSplashScreen()

	self:DrawLogo((ScrW() * .5), (ScrH() * .175));

end


function GM:RenderScreenspaceEffects()
	
	if (LocalPlayer():IsGhost()) then
		DoGhostEffects();
	end
	
	for k, ply in pairs(player.GetAll()) do
		
		if (!LocalPlayer():IsGhost() && ply:IsGhost() || (ply:IsUC() && !ply:Alive())) then
			ply:SetRenderMode(RENDERMODE_NONE);
		else
			ply:SetRenderMode(RENDERMODE_NORMAL);
		end
		
		ply.skin, ply.bgroup, ply.bgroup2 = (ply.skin || nil), (ply.bgroup || nil), (ply.bgroup2 || nil);
	
		if (ply:Alive()) then
			ply.skin = ply:GetSkin();
			ply.bgroup = ply:GetBodygroup(1);
			ply.bgroup2 = ply:GetBodygroup(2);
		end
		
		local rag = ply:GetRagdollEntity();
		if (ValidEntity(rag)) then
			if (!ply:IsUC()) then
				rag:SetSkin(ply.skin);
				rag:SetBodygroup(1, ply.bgroup);
				rag:SetBodygroup(2, ply.bgroup2);
				
				if (!rag.Flew && ply.RagShouldFly) then
					rag.Flew = true;
					ply.RagShouldFly = false;
					local dir = (self:GetUC():GetForward() + Vector(0, 0, .75));
					for i = 0, (rag:GetPhysicsObjectCount() - 1) do
						rag:GetPhysicsObjectNum(i):ApplyForceCenter((dir * 50000));
					end
					rag:EmitSound("UCH/pigs/squeal" .. tostring(math.random(1, 3)) .. ".mp3", 100, math.random(90, 105));
				end
				
			else
				rag:SetSkin(1);
				rag:SetBodygroup(1, 0);
			end
		end
		
		if (ply:IsPancake()) then
			ply:DoPancakeEffect();
		else
			ply.PancakeNum = 1;
			ply:SetModelScale(Vector(1, 1, 1));
		end
		
	end
	
end


local function MakeRagFly(um)
	local ply = um:ReadEntity();
	ply.RagShouldFly = true;
end
usermessage.Hook("UCMakeRagFly", MakeRagFly);


function GM:OnPlayerChat( player, strText, bTeamOnly, bPlayerIsDead )
 
	local tab = {}
 
	if ( IsValid( player ) ) then
		if (player:IsGhost()) then
			table.insert(tab, Color(200, 200, 200));
			local str = (player:GetBodygroup(1) == 1 && "Fancy ") || "Spooky ";
			table.insert(tab, str .. player:GetName());
		else
			table.insert( tab, player )
		end
	else
		table.insert( tab, "Console" )
	end
 
	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": "..strText )
 
	chat.AddText( unpack(tab) )
 
	return true
 
end

function GM:PrePlayerDraw(ply)
	
	if (!LocalPlayer():IsGhost() && ply:IsGhost() || (ply:IsUC() && !ply:Alive()) || (ply:IsGhost() && ply:GetModel() != "models/uch/mghost.mdl")) then
		return true;
	end
	
end

