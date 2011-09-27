
local function DrawTargetIDName(ply,x,y,alpha)
	
	local text = ply:Nick()
	local font = "TargetID"
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	x = x - w/2
	
	local col = GAMEMODE:GetTeamColor( ply )
	col.a = alpha
	
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,(alpha/255)*120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,(alpha/255)*50) )
	draw.SimpleText( text, font, x, y, col )
	
end

local function DrawTargetIDHealth(ply,x,y,alpha)
	
	local w,h = 60,10
	local frac = math.Clamp(ply:Health()/100, 0, 1)
	
	local col = Color((1-frac)*255, frac*255, 0, alpha)
	
	x = x - w/2
	y = y + 21
	
	draw.RoundedBox(0, x-1, y-1, w+2, h+2, Color(0,0,0,(alpha/255)*200))
	draw.RoundedBox(0, x, y, frac*w, h, col)
	
end

local function DrawTargetIDCoins(ply,x,y,alpha)
	
	local text = ply:GetCoins().."C"
	local font = "TargetIDSmall"
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	x = x - w/2
	y = y + 32
	
	local col = GAMEMODE:GetTeamColor( ply )
	col.a = alpha
	
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,(alpha/255)*120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,(alpha/255)*50) )
	draw.SimpleText( text, font, x, y, col )
	
end

local alpha = 0
local ply = nil
function GM:HUDDrawTargetID()
	
	local trace = util.QuickTrace(LocalPlayer():GetShootPos(), LocalPlayer():GetCursorAimVector()*4096, LocalPlayer())
	
	if not trace.Entity:IsPlayer() then
		alpha = math.Clamp(alpha - (alpha*FrameTime()*30)^(1/2), 0, 255)
	elseif trace.Entity:IsPlayer() then
		alpha = 255
		ply = trace.Entity
	end
	
	if IsValid(ply) and !ply:GetInvisible() and alpha > 0 then
		
		local pos = ply:LocalToWorld(ply:OBBCenter()):ToScreen()
		
		DrawTargetIDName(ply, pos.x, pos.y, alpha)
		DrawTargetIDHealth(ply, pos.x, pos.y, alpha)
		DrawTargetIDCoins(ply, pos.x, pos.y, alpha)
		
	end

	local weapon = LocalPlayer():GetActiveWeapon()

	if weapon:IsValid() then
		if (weapon:GetClass() == "cb_weapon_medgun") and (weapon.dt.Target:IsValid()) and not(weapon.dt.IsUber) then
		
			local text = ply:Nick()
			local font = "TargetID"
			
			surface.SetFont( font )

			local w,h = surface.GetTextSize(text)
			local pos = weapon.dt.Target:LocalToWorld(weapon.dt.Target:OBBCenter()):ToScreen()
			pos.x = math.Clamp(pos.x, w, ScrW()-w)
			pos.y = math.Clamp(pos.y, h, ScrH()-h-16)

			DrawTargetIDName(weapon.dt.Target, pos.x, pos.y, 255)
			DrawTargetIDHealth(weapon.dt.Target, pos.x, pos.y, 255)
			DrawTargetIDCoins(weapon.dt.Target, pos.x, pos.y, 255)

		end
	end
	
end
