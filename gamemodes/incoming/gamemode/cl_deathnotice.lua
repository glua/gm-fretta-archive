local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED )
local Deaths = {}

local function RecvPlayerKilled( um )
	local Tbl = {}
	Tbl.Player = um:ReadEntity()
	Tbl.Text = Tbl.Player:Nick() .. " died"
	Tbl.Time = CurTime()
	
	table.insert( Deaths, Tbl )
end
usermessage.Hook( "PlayerKilled", RecvPlayerKilled )

function GM:DrawDeathNotice( x, y )
	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()
	
	x = ScrW() - 64
	y = y * ScrH()
	
	for k, Death in pairs( Deaths ) do
		if ( Death.Time + hud_deathnotice_time > CurTime() ) then
			if ( Death.lerp ) then
				--x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
			
			surface.SetFont( "ChatFont" )
			Death.w, Death.h = surface.GetTextSize( Death.Text )
			
			local fadeout = ( Death.Time + hud_deathnotice_time ) - CurTime()
			
			local alpha = math.Clamp( fadeout * 255, 0, 255 )
			
			draw.TexturedQuad( 
			{ 
				color = Color( 255, 255, 255, alpha ),
				x = x - Death.w,
				y = y - 10,
				w = Death.w + 64,
				h = 64,
				texture = surface.GetTextureID( "models/clannv/nvincoming/hud/bar" )
			} )
			draw.SimpleText( Death.Text, "ChatFont", x - ( Death.w / 2 ) + 32, y, Color( 255, 255, 255, alpha ), 1 )
			
			y = y + Death.h * 3
		end
	end
	
	for k, Death in pairs( Deaths ) do
		if ( Death.Time + hud_deathnotice_time > CurTime() ) then
			return
		end
	end
	
	Deaths = {}
end
