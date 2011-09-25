include("data.lua")

ta = {}

if SERVER then

	function ta.Message(msg,toall,pls)
		if toall == nil then toall = true end
		if toall == true then
			for _,v in ipairs(player.GetAll()) do
				v:ChatPrint(msg)
			end
		else
			for _,v in ipairs(pls) do
				v:ChatPrint(msg)
			end
		end
	end
	
	function ta.Explosion(pl,pos,mag)
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( pos:GetNormalized() )
		util.Effect( "super_explosion", effectdata )
		
		local explosion = ents.Create( "env_explosion" )
		explosion:SetPos(pos)
		explosion:SetKeyValue( "iMagnitude" , tostring(mag) )
		explosion:SetPhysicsAttacker(pl)
		explosion:SetOwner(pl)
		explosion:Spawn()
		explosion:Fire("explode","",0)
		explosion:Fire("kill","",0 )
	end
	
	function ta.ComparePoints(pl1,pl2)
		
		if pl1:IsBot() || !pl1:IsValid() || !pl1:IsConnected() then return pl2
		elseif pl2:IsBot() || !pl2:IsValid() || !pl2:IsConnected() then return pl1 end
		
		local pts1,pts2 = DB.GetPoints(pl1) + DB.GetPlays(pl1) * 5, DB.GetPoints(pl2) + DB.GetPlays(pl2) * 5
		
		return pts1 > pts2 && pl1 || pl2
	end
	
	function ta.AddFilesRecursive(root,path)
		if file.IsDir(path..root) then
			for _,v in ipairs(file.Find(path..root.."/*")) do ta.AddFilesRecursive(v,path..root.."/") end
		else
			resource.AddSingleFile(string.gsub(path..root,"%.%./","")) 
		end
	end
	
	function ta.SpawnEntities()
		local capname = "A"
		for _,v in ipairs( ents.FindByClass( "info_target" ) ) do
			local name = v:GetName()
			if name == "obj_capture" then
				local obj = ents.Create("obj_capture")
				obj:SetPos(v:GetPos() + Vector(60,0,0))
				obj:Spawn()
				obj:Activate()
				obj:SetNWString("ta-capname",capname)
				if capname == "A" then capname = "B"
				elseif capname == "B" then capname = "C" end
			elseif name == "ent_pickup_health" then
				local hp = ents.Create("ent_pickup")
				hp:SetPos(v:GetPos() + Vector(0,0,10))
				hp:Spawn()
				hp:Activate()
				hp:SetType(1)
			elseif name == "ent_pickup_ammo" then
				local ammo = ents.Create("ent_pickup")
				ammo:SetPos(v:GetPos() + Vector(0,0,3))
				ammo:Spawn()
				ammo:Activate()
				ammo:SetType(2)
			elseif name == "sent_striderturret" then
				local turret = ents.Create("sent_striderturret")
				turret:SetPos(v:GetPos() + Vector(0,0,5))
				turret:SetAngles( Angle(0,180,0) )
				turret:Spawn()
				turret:Activate()
			end
		end

		if #ents.FindByClass("obj_explode_win") > 0 then
			SetGlobalString("ta_mode","bomb")
		else
			SetGlobalString("ta_mode","capture")
		end
	
		for _,v in ipairs(ents.FindByClass("sent_humvee")) do
			v:SetPos( v:GetPos() + Vector(0,0,20) )
		end
	end
	
	// Fixing jeeps...
	hook.Add("InitPostEntity","FixJeeps",function()
		for _,v in ipairs(ents.FindByClass("sent_humvee")) do
			v:SetPos( v:GetPos() + Vector(0,0,20) )
		end
	end)

	function ta.AddHint( pl, hint )
		SendUserMessage("ta-hints",pl,hint)
	end
	
	
end

if CLIENT then

	function ta.RoundedBoxOutlined( bordersize, x, y, w, h, color, bordercol )

		x = math.Round( x )
		y = math.Round( y )
		w = math.Round( w )
		h = math.Round( h )

		draw.RoundedBox( bordersize, x, y, w, h, color )
		
		surface.SetDrawColor( bordercol )
		
		surface.SetTexture( texOutlinedCorner )
		surface.DrawTexturedRectRotated( x + bordersize/2 , y + bordersize/2, bordersize, bordersize, 0 ) 
		surface.DrawTexturedRectRotated( x + w - bordersize/2 , y + bordersize/2, bordersize, bordersize, 270 ) 
		surface.DrawTexturedRectRotated( x + w - bordersize/2 , y + h - bordersize/2, bordersize, bordersize, 180 ) 
		surface.DrawTexturedRectRotated( x + bordersize/2 , y + h -bordersize/2, bordersize, bordersize, 90 ) 
		
		surface.DrawLine( x+bordersize, y, x+w-bordersize, y )
		surface.DrawLine( x+bordersize, y+h-1, x+w-bordersize, y+h-1 )
		
		surface.DrawLine( x, y+bordersize, x, y+h-bordersize )
		surface.DrawLine( x+w-1, y+bordersize, x+w-1, y+h-bordersize )

	end
	
	function ta.DrawTrapezoid(x,y,w,h,diag,facing_up,col)
		if col then surface.SetDrawColor(col) end
		if facing_up then	
			surface.DrawPoly{
				{ x = x, y = y + h};
				{ x = x  + w, y = y + h};
				{ x = x + w - diag, y = y;};
				{ x = x + diag,y = y};
			}
		else
			surface.DrawPoly{
				{ x = x, y = y};
				{ x = x + diag, y = y + h};
				{ x = x + w - diag, y = y + h;};
				{ x = x + w,y = y};
			}
		end
	end
	
	function ta.DrawChevron(x,y,w,h,chev,point_up,col)
		if col then surface.SetDrawColor(col) end
		
		if !point_up then
			surface.DrawPoly{
				{x = x,y=y};
				{x = x + w/2,y= y - h};
				{x = x,y = y - chev};
				{x = x - w/2,y = y - h};
			}
		else
		end
	end
	
	function ta.DrawChevronRight(x,y,w,h,chev,point_right,col)
		if col then surface.SetDrawColor(col) end
	
		if point_right then
			surface.DrawPoly{
				{x=x,y=y};
				{x=x - w,y=y+h/2};
				{x = x - chev;y = y};
				{x = x - w;y=y-h/2};
			}
		else
			surface.DrawPoly{
				{x=x,y=y};
				{x=x + w,y=y+h/2};
				{x = x + chev;y = y};
				{x = x + w;y=y-h/2}
			}
		end
	end
	
	function ta.DrawParallel(x,y,w,h,diag)
		surface.DrawPoly{
			{x = x,y=y};
			{x = x + diag,y = y - h};
			{x = x + diag + w,y = y - h};
			{x = x + w;y = y};
		}
	end
	
	function ta.AngleToPlayer(obj)
		local vpos = LocalPlayer():GetPos()
		local apos = obj:GetPos()
		local eyeang = LocalPlayer():EyeAngles()
		local eyaw = eyeang.y
		local bearing
		if eyaw > 0 then bearing = 360 - eyaw
		else bearing = math.abs(eyaw)
		end
		local distx = vpos.x - apos.x --adj
		local disty = vpos.y - apos.y -- opp
		local test = math.atan2(disty, distx)
		test = math.Rad2Deg( test ) -- the angle from the origin(world)
		data =  test + bearing --make it relative to the player.
		data = data - 180 -- for some reason, it's rotated 180 deg.
		if data < 0 then return 360 + data
		else return data end
	end
	
	function ta.AddKillStreak(ply,kills)
		local snds = {
			Sound("ta/killstreak-1.mp3"),
			Sound("ta/killstreak-2.mp3"),
		}
	
		local medals = {
		[5] = {"ta/bronze",function()
			surface.PlaySound(table.Random(snds))
			end},
		[15] = {"ta/silver",function()
			surface.PlaySound(table.Random(snds))
			end},
		[25] = {"ta/gold",function()
			surface.PlaySound(table.Random(snds))
			LocalPlayer():ChatPrint("For your valor, you have been given the Aurora Cannon. Use it wisely.")
			RunConsoleCommand("ta_aurora")
			end},
		}
		
		if !IsValid( g_DeathNotify )  then return end
		if not medals[kills] then return end

		local pnl = vgui.Create( "GameNotice", g_DeathNotify )
		
		local icon = vgui.Create("DImage",pnl)
		icon:SetMaterial(medals[kills][1])
		icon:SetSize(35,35)
		pnl:AddItem(icon)
		
		pnl:AddText( ply:Name() .. " has a "..kills .. " kill streak!" )
		if ply == LocalPlayer() then medals[kills][2]() end

		g_DeathNotify:AddItem( pnl )
	end
	
	function ta.ClearTooltips()
		local f = vgui.Create("DFrame")
		f:SetPos(0,0)
		f:SetSize(1,1)
		f:MakePopup()
		timer.Simple(0.2,function() f:Close() end)
	end
	
	function ta.CanSee(obj)
		local pos = obj:GetPos():ToScreen()
		return util.TraceLine({start = LocalPlayer():GetShootPos(),endpos = obj:GetPos() + obj:OBBCenter(),filter= LocalPlayer()}).Entity == obj and pos.x <= ScrW() and pos.x >=0 and pos.y <= ScrH() and pos.y >= 0
	end
	
	function ta.LowHealth()
		local breathe = Sound("player/breathe1.wav")
		local heart = Sound("player/heartbeat1.wav")
		local coughs = {
			Sound("ambient/voices/cough1.wav"),
			Sound("ambient/voices/cough2.wav"),
			Sound("ambient/voices/cough3.wav"),
			Sound("ambient/voices/cough4.wav"),
		}
		
		surface.PlaySound(breathe)
		surface.PlaySound(heart)
		timer.Create("ta-breathe",SoundDuration("../../hl2/sound/"..breathe),0,function() surface.PlaySound(breathe) end)
		timer.Create("ta-heart",SoundDuration("../../hl2/sound/"..heart),0,function() surface.PlaySound(heart) end)
		function Cough()
			timer.Create("ta-cough",math.random(4,15),0,function() surface.PlaySound(table.Random(coughs)) Cough() end)
		end
		Cough()
	end
	
	function ta.StopLowHealth()
		if timer.IsTimer("ta-breathe") then
			timer.Destroy("ta-breathe")
			timer.Destroy("ta-heart")
			timer.Destroy("ta-cough")
			RunConsoleCommand("stopsounds")
			LocalPlayer():SetDSP(1,false)
		end
	end
	
	ta.hint = ""
	ta.hint_start = 0
	ta.hint_w = 0
	ta.hint_wait = 10
	function ta.AddHint(msg)
		ta.hint = msg
		ta.hint_start = CurTime()
	end
	function ta.HintTime()
		return (ta.hint_start + ta.hint_wait) - CurTime()
	end
	
	local cur_hint = ""
	usermessage.Hook("ta-hints",function(u)
		cur_hint = u:ReadString()
		local time = ta.HintTime()
		if time <= 0 then time = 0.1 end
		timer.Create("taHints",time,1,function()
			ta.AddHint(cur_hint)
		end)
	end)

end


function ta.Players()
	return table.Count(player.GetAll())
end

function ta.KeyNum(t,k)
	local ret = 0
	for a,b in pairs(t) do
		ret = ret + 1
		if a == k then return ret end
	end
	return 0
end

function ta.PreviousKey(t,k)
	local ret = k
	for a,b in pairs(t) do
		if a == k then return ret end
		ret = a
	end
end

function ta.NextKey(t,k)
	local ret_next = false
	for a,b in pairs(t) do
		if ret_next then return a end
		if a == k then ret_next = true end
	end
	return k
end

function ta.SubTableHasValue(t,v)
	for _,subtable in pairs(t) do
		if table.HasValue(subtable,v) then return true end
	end
	return false
end

function ta.GetSubTableWithValue(t,v)
	for _,subtable in pairs(t) do
		if table.HasValue(subtable,v) then return subtable end
	end
	return {}
end

function ta.RemoveSubtableFromValue(t,v)
	for k,subtable in pairs(t) do
		if table.HasValue(subtable,v) then table.remove(t,k) return end
	end
end

function ta.SecToMin(sec)
	local min,s = math.floor(sec / 60),math.floor(math.fmod(sec,60))
	if min < 10 then min = "0"..min end
	if s < 10 then s = "0"..s end
	return min .. ":".. s
end

function ta.Capitalize(str) return string.upper(string.Left(str,1)) .. string.Right(str,string.len(str) - 1) end

function ta.FindClosestEntity(pl,class)
	local c_ent,c_dist
	local pos = pl:GetPos()
	for _,v in ipairs(ents.FindByClass(class)) do
		if c_ent then
			local v_dist = v:GetPos():Distance(pos)
			if v_dist < c_dist then
				c_ent = v
				c_dist = v_dist
			end
		else
			c_ent = v
			c_dist = v:GetPos():Distance(pos)
		end
	end
	return c_ent
end


