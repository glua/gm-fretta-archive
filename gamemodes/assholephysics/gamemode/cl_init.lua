include( 'shared.lua' )
include( 'cl_hud.lua' )
include( 'props.lua' )
include( 'gibs.lua' )  

function GM:Initialize()
	
	self.BaseClass:Initialize()
	
	Prices = {}
	Indicators = {}
	PrintCombo = 0
	AlphaFade = 0
	
	surface.CreateFont( "coolvetica", 24, 450, true, false, "PriceText" ) 
	surface.CreateFont( "Thwack", 38, 250, true, false, "ComboText" ) 
	surface.CreateFont( "Trebuchet MS", 32, 800, true, false, "CashText" )
	
end

function DrawPrice( msg )

	local pos = msg:ReadVector()
	local text = msg:ReadString()
	local cash = msg:ReadShort()
	
	local tbl = { Pos = pos, Text = text, Time = CurTime() + 2, Alpha = 255, Dist = 50, Cash = cash, Col = Color(55,255,55,255) }
	local tbl2 = { Cash = cash, Dist = ScrH() * 0.2, Time = CurTime() + 1, Alpha = 255, Col = Color(55,255,55,255) }
	
	if tbl.Pos.z > LocalPlayer():GetPos().z + 10 then
		tbl.Dist = 25
	end
	
	if tbl.Cash < 0 then
		tbl.Col = Color(255,55,55,255)
		tbl2.Col = Color(255,55,55,255)
	end
	
	if text == "" or pos == Vector(0,0,0) then
		tbl2.Col = Color(255,255,55,255)
	else
		table.insert( Prices, tbl )
	end
	
	if tbl2.Cash != 0 then
		table.insert( Indicators, tbl2 )
	end
	
end
usermessage.Hook( "DrawPrice", DrawPrice )

function GM:OnHUDPaint()

	local combo = LocalPlayer():GetNWInt( "Combo", 0 )
	
	if combo > 1 then
		PrintCombo = combo
		AlphaFade = math.Approach( AlphaFade, 255, 5 )
	else
		AlphaFade = math.Approach( AlphaFade, 0, 5 )
	end
	
	draw.SimpleTextOutlined( PrintCombo.."x COMBO" , "ComboText", ScrW() * 0.5, ScrH() * 0.85, Color(55,255,55,AlphaFade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,AlphaFade) )
	
	for k,v in pairs( Indicators ) do
	
		local scale = math.Clamp( ( 1 - ( v.Time - CurTime() ) ), 0, 1 )
		local text = "+ $"
		local cash = v.Cash
		
		if v.Cash < 0 then
			text = "- $"
			cash = -cash
		end
		
		v.Col.a = v.Alpha
		
		draw.SimpleTextOutlined( text..cash, "CashText", ScrW() * 0.95, ScrH() * 0.90 - v.Dist * scale, v.Col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, Color(0,0,0,v.Alpha) )
		
		Indicators[k].Alpha = math.Approach( v.Alpha, 0, 3 )
	
	end

	for k,v in pairs( Prices ) do
		if v.Alpha < 1 then
			table.remove( Prices, k )
			break
		end
	end
	
	for k,v in pairs( Prices ) do
	
		local scale = math.Clamp( ( 2 - ( v.Time - CurTime() ) ) / 2, 0, 1 )
		local add = Vector( 0, 0, scale * v.Dist )
		local pos = ( add + v.Pos ):ToScreen()
		
		if v.WaitTime then
		
			add = Vector( 0, 0, v.Dist )
			pos = ( add + v.Pos ):ToScreen()
			
			if v.WaitTime < CurTime() and v.Alpha > 0 then
				Prices[k].Alpha = Prices[k].Alpha - 1
			end
			
		end
		
		if pos.visible then
		
			if v.WaitTime then
			
				if v.WaitTime > CurTime() then
					draw.SimpleTextOutlined( v.Text, "PriceText", pos.x, pos.y, v.Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255) )
				else
					draw.SimpleTextOutlined( v.Text, "PriceText", pos.x, pos.y, Color(v.Col.r,v.Col.g,v.Col.b,v.Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,v.Alpha) )
				end
				
			else
			
				draw.SimpleTextOutlined(v.Text, "PriceText", pos.x, pos.y, Color(v.Col.r,v.Col.g,v.Col.b,scale * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,scale * 255) )
				
			end
			
		end
		
		if v.Time <= CurTime() then
			Prices[k].WaitTime = CurTime() + 1
			Prices[k].Time = CurTime() + 10
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