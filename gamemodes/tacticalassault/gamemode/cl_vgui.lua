include( 'util.lua' )
include("cl_hud.lua")

// RADAR
local radar = vgui.Create("DFrame")
	radar:SetTitle("")
	radar:ShowCloseButton(false)
	radar:SetDraggable(false)
	radar:SetSize(150,150)
	radar:SetPos(ScrW() - 180,ScrH() - 550)
	
	local on_radar = {}
	
	timer.Create("cleanRadar",120,0,function() on_radar = {} end)
	
	function radar:Paint()

		if !LocalPlayer():IsValid() or !LocalPlayer():Alive() || !table.HasValue({1,2},LocalPlayer():Team()) then return end
	
		local cx,cy = radar:GetWide()/2,radar:GetTall()/2
			
		draw.RoundedBox(0,0,0,radar:GetWide(),radar:GetTall(),Color(0,0,0,220))
		draw.RoundedBox(0,2,2,radar:GetWide() - 4,radar:GetTall() - 4,Color(50,50,50,2000))
		/*draw.TexturedQuad({
			texture=surface.GetTextureID("ta/ta-radar"),
			color=color_white,
			x=2,
			y=2,
			w=radar:GetWide() - 4,
			h=radar:GetTall()-4})*/
			
		surface.SetTexture(surface.GetTextureID("ta/radar-beacon3"))
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(cx -5,cy -5,10,10)
		
		local mul = -25
		
		for _,v in ipairs(ents.FindByClass("player")) do 
			
			if !table.HasValue({1,2},v:Team()) then return end
			
			surface.SetTexture(surface.GetTextureID("ta/radar-beacon"..v:Team()))
			if v:Team() != LocalPlayer():Team() and v:Alive() and v != LocalPlayer() then
		
				local rdr,see = ta.SubTableHasValue(on_radar,v),ta.CanSee(v)
			
				if rdr || see then
					
					if !rdr then 
						table.insert(on_radar,{v,v:GetPos()})
						timer.Simple(5,function()
							ta.RemoveSubtableFromValue(on_radar,v)
						end)
					elseif see then 
						ta.GetSubTableWithValue(on_radar,v)[2] = v:GetPos()
					end
				

					local dist,ang = LocalPlayer():GetPos():Distance(v:GetPos()), ta.AngleToPlayer(v)

					if !see then 
						local t = ta.GetSubTableWithValue(on_radar,v)
						dist = LocalPlayer():GetPos():Distance(t[2])
					end
					
					local y = math.cos(math.rad(ang)) * dist / mul
					local x = math.sin(math.rad(ang)) * dist / mul
					
					local eyeang = LocalPlayer():GetForward():Angle().yaw + v:GetForward():Angle().yaw
				
					surface.DrawTexturedRectRotated(cx + x,cy + y,10,10,eyeang)
							
				end
				
			elseif v:Alive() and v:Team() == LocalPlayer():Team() and v != LocalPlayer() then
				
				local dist,ang = LocalPlayer():GetPos():Distance(v:GetPos()), ta.AngleToPlayer(v)
				
				local y = math.cos(math.rad(ang)) * dist / mul
				local x = math.sin(math.rad(ang)) * dist / mul
				
				local eyeang = LocalPlayer():GetForward():Angle().yaw + v:GetForward():Angle().yaw
				
				surface.DrawTexturedRectRotated(cx + x,cy + y,10,10,eyeang)
			
			end
			
		end
		
	end

local commands = {
	["Airstrike"] = {"ta_airstrike","ta/bomb2-comm"},
	["Radio"] = {"stopsounds","ta/radio-comm"},
	["Ammo"] = {"ta_ammodrop","ta/ammo-comm"},
	["UAV"] = {"uav","ta/binoc-comm"},
}
local selected = "Ammo"
local key_wait  = CurTime()

// Command options
function CommandOptions()
	local f = vgui.Create("DFrame")
	f:SetPos(0,0)
	f:SetSize(ScrW(),ScrH())
	f:SetTitle("")
	f:ShowCloseButton(false)
	f:MakePopup()
	f:SetDraggable(false)
	f:SetScreenLock(true)
	
	
	local key_timer = 0
	function f:Paint()

		if SysTime() - key_timer > .075 then
			if input.IsKeyDown(KEY_LEFT) then 
				selected = ta.PreviousKey(commands,selected)
			elseif input.IsKeyDown(KEY_RIGHT) then selected = ta.NextKey(commands,selected) 
			end
			key_timer = SysTime()
		end
	
		local sel_n = ta.KeyNum(commands,selected)
			
		for k,v in pairs(commands) do
				
			local v_n = ta.KeyNum(commands,k)
				
			if math.abs(v_n - sel_n) <= 1 then	
				
				local xpos = (v_n - sel_n) * 100 + ScrW()/2
				local mx,my = gui.MousePos()
					
				if v_n == sel_n then
					local x,y = xpos + 5,ScrH()-207
					surface.SetTexture( "color/white")
					surface.SetDrawColor( 100, 100, 100, 200 )
					surface.DrawPoly{
						{ x = x-1; y = y};
						{ x = x+32; y = y};
						{ x = x+47; y = y+27};
						{ x = x+32; y = y+55};
						{ x = x-2; y = y+55};
						{ x = x-17; y = y+28};
					}
					//draw.DrawText(k,"ScoreboardText",xpos + 20,ScrH() - 185,color_black,1)
					draw.TexturedQuad({texture=surface.GetTextureID(v[2]),color=color_white,x=xpos,y=ScrH()-198,w=40,h=40})
					
					if input.IsKeyDown(KEY_ENTER) then 
						LocalPlayer():ConCommand(v[1])
						f:Close() 
					end
				else 
					draw.RoundedBox(0,xpos,ScrH() - 200,40,40,Color(100,100,100,200))
					//draw.DrawText(k,"ScoreboardText",xpos + 20,ScrH() - 180,color_black,1)
					draw.TexturedQuad({texture=surface.GetTextureID(v[2]),color=color_white,x=xpos+5,y=ScrH()-195,w=30,h=30})

				end
			
			end
				
		end
	end
	concommand.Add("-command",function() if ValidPanel(f) then f:Close() end end)

end
concommand.Add("+command",CommandOptions)

// Squad box
local avatars = {}
local function UpdateAvatars( parent )
	for _,v in ipairs(avatars) do v:SetVisible(false) end
	avatars = {}
	for k,v in ipairs(squad) do if ValidEntity(v) then
		local icon = vgui.Create("AvatarImage",parent)
		icon:SetPlayer(v)
		icon:SetPos(10,40 + (k - 1) * 35)
		icon:SetSize(30,30)
		table.insert(avatars,icon)
	end end
end

local last_squad = {}
local last_alive = false
local squadbox = vgui.Create("DPanel")
squadbox:SetPos(ScrW() - 250,ScrH() - 360)
squadbox:SetSize(220,200)
squadbox.Paint = function()
	
	if !ValidEntity(LocalPlayer()) || !squad[1] then 
		for k,v in ipairs(avatars) do 
			v:SetVisible(false) 
			table.remove(avatars,k)  
		end
		return 
	end
	
	if !LocalPlayer():Alive() then
		for _,v in ipairs(avatars) do v:SetVisible(false) end
		return
	else
		for _,v in ipairs(avatars) do v:SetVisible(true) end
	end

	//draw.TexturedQuad( {texture = surface.GetTextureID("VGUI/gradient-l"), color = , x = 0, y = 30, w = squadbox:GetWide(), h = squadbox:GetTall() - 30})
	draw.RoundedBox( 0, 0, 30, squadbox:GetWide(), squadbox:GetTall() - 30, Color( 0, 0, 0, 220 ) )
	draw.RoundedBox( 0, 2, 32, squadbox:GetWide() - 4, squadbox:GetTall() - 34, Color( 50, 50, 50, 200 ) )
	
	draw.DrawText("Squad Members","ObjectiveFontPrimary",squadbox:GetWide()/2,0,color_white,1)
	
	for k,v in ipairs(squad) do if ValidEntity(v) then

		local suffix = ""
		if v == squad.leader then suffix = "(L)" end
		
		draw.DrawText(v:Name() .. " " .. suffix,"MenuLarge",55,45 + (k - 1) * 35,color_white,0)
		
	end end
	
	if last_squad != squad || last_alive != LocalPlayer():Alive() then UpdateAvatars(squadbox) end
	last_squad = squad
	last_alive=  LocalPlayer():Alive()
end


