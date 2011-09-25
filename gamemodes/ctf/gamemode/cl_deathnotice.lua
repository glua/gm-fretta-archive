killicon.AddFont( "headshot", "HVACSKillIcons", "D", Color_Icon )
killicon.AddFont( "null", "LSArialBSmall", "", Color_Icon )

GM.LatestVictim = {}

function GM:SetLatestVictim( pl, killed )

	if( killed == nil ) then
		killed = false;
	end
	
	if( pl and type( pl ) != "string" and pl:IsValid() and pl:IsPlayer() ) then
		local temp = {};
		temp.time = CurTime();
		temp.name = pl:Name();
		temp.killed = killed;
		
		if( pl == LocalPlayer() ) then
			temp.name = "yourself";
		elseif( pl:Team() == LocalPlayer():Team() ) then
			temp.name = "TEAMMATE " .. temp.name;
		elseif( pl:GetFriendStatus() == "friend" ) then
			temp.name = "your friend " .. temp.name;
		end
		
		GAMEMODE.LatestVictim = temp;
	end
end

GM.VictimFont = "HudBarItem";

function GM:DrawLatestVictim( )

	local lv = GAMEMODE.LatestVictim;
	
	if( lv and lv.name and lv.time ) then
		
		local prefix = "You killed ";
		
		if( lv.killed == true ) then
			prefix = "You were killed by ";
		end
		
		local alpha = lv.alpha or 255;
		GAMEMODE:SimpleTextShadow( prefix .. lv.name, "TrebBoldLarge", ScrW()/2, ScrH()*0.85, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );	
		
		if( lv.time + 3 < CurTime() ) then
			local diff = CurTime() - lv.time;
			lv.alpha = 255 - (127.5 * (diff-3)); -- lol y = mx + c
			--lv.avatar:SetAlpha( lv.alpha );
		end
		
		if( lv.time + 5 < CurTime() ) then
			--lv.avatar:Remove()
			GAMEMODE.LatestVictim = {};
		else
			GAMEMODE.LatestVictim = lv;
		end
		
	end
end

local function RecvFlagAction( message )

	local player = message:ReadEntity();
	local ateam = message:ReadShort();
	local vteam = message:ReadShort();
	local action = message:ReadString();
	
	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	
	pnl:AddText( player )
	pnl:AddText( action .. " the" )
	pnl:AddText( team.GetName( vteam )  .. " Flag", team.GetColor( vteam ) );
	
	g_DeathNotify:AddItem( pnl )
	
end

usermessage.Hook( "PlayerFlagAction", RecvFlagAction )

local function RecvAutoReturn( message )

	local ateam = message:ReadShort();

	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	
	pnl:AddText( team.GetName( ateam )  .. " Flag", team.GetColor( ateam ) )
	pnl:AddText( "returned to base after being dropped for 30 seconds" )
	
	g_DeathNotify:AddItem( pnl )
	
end

usermessage.Hook( "PlayerFlagAutoReturned", RecvAutoReturn )
