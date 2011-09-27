hook.Add("PostPlayerDraw", "flagHook", function(ply)
	if(ply._PlayerFlag == nil)then return end
	if(ply == LocalPlayer())then return end
	if(ply.hasFlag == true)then
		local Bone = ply:LookupBone("ValveBiped.Bip01_Spine2")
		local BonePos , BoneAng = ply:GetBonePosition( Bone )
		ply._PlayerFlag:SetPos(BonePos + (-16*BoneAng:Forward()) + Vector(0,0,8))
		ply._PlayerFlag:SetAngles(BoneAng + Angle(0,90,120))
		ply._PlayerFlag:SetNoDraw( false )
		if(ply:Team() == TEAM_RED)then
			ply._PlayerFlag:SetColor(0, 0, 255, 255)
		else
			ply._PlayerFlag:SetColor(255, 0, 0, 255)
		end
	else
		ply._PlayerFlag:SetNoDraw( true )
	end
end)

function setFlagHolder(data)
	ply = data:ReadEntity()
	ply.hasFlag = data:ReadBool();
	if(ply._PlayerFlag == nil) and (ply != LocalPlayer()) and (ply:IsValid())then
		if(ply:Alive()) and (ply:Team() != TEAM_SPECTATOR) and (ply:Team() != TEAM_UNASSIGNED)then
			ply._PlayerFlag = ClientsideModel("models/props_c17/GasPipes006a.mdl")
		end
	end
end
usermessage.Hook( "ChangeFlagHolder", setFlagHolder )

surface.CreateFont( "ChatFont", 72, 200, true, false, "Text64" )
function DrawBeacons() 
	local ang = LocalPlayer():EyeAngles()
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
	if(LocalPlayer():Team() != TEAM_SPECTATOR) and (LocalPlayer():Team() != TEAM_UNASSIGNED)then
		if(LocalPlayer().hasFlag)then
			for _, ent in pairs(ents.FindByClass("item_teamflag")) do
				if (LocalPlayer():Team() == ent:GetNWInt("team")) then
					cam.Start3D2D(ent:GetPos()+Vector(0,0,85), Angle(0,ang.y,90), 0.3)
						surface.SetDrawColor( 255, 255, 255, 220 );
						surface.SetTexture( surface.GetTextureID("mhs/yellow_arrow") )
						surface.DrawTexturedRect( -128, -90-128, 256, 256 )
						struc = {}
						struc["pos"] = {0, -110}
						struc["color"] = Color(255, 255, 255, 240)
						struc["text"] = "Return"
						struc["font"] = "Text64"
						struc["xalign"] = TEXT_ALIGN_CENTER
						struc["yalign"] = TEXT_ALIGN_CENTER
						draw.TextShadow( struc, 2, 160 )
					cam.End3D2D()
				end
			end
		end
		for _,ply in pairs(player.GetAll( )) do
			if(ply.hasFlag)then
				if(LocalPlayer():Team() == ply:Team()) and (ply != LocalPlayer())then
					cam.Start3D2D(ply:GetPos()+Vector(0,0,85), Angle(0,ang.y,90), 0.3)
						surface.SetDrawColor( 255, 255, 255, 220 );
						surface.SetTexture( surface.GetTextureID("mhs/blue_arrow") )
						surface.DrawTexturedRect( -128, -90-128, 256, 256 )
						struc = {}
						struc["pos"] = {0, -110}
						struc["color"] = Color(255, 255, 255, 240)
						struc["text"] = "Defend"
						struc["font"] = "Text64"
						struc["xalign"] = TEXT_ALIGN_CENTER
						struc["yalign"] = TEXT_ALIGN_CENTER
						draw.TextShadow( struc, 2, 160 )
					cam.End3D2D()
				elseif(LocalPlayer():Team() != ply:Team())then
					cam.Start3D2D(ply:GetPos()+Vector(0,0,85), Angle(0,ang.y,90), 0.3)
						surface.SetDrawColor( 255, 255, 255, 220 );
						surface.SetTexture( surface.GetTextureID("mhs/red_arrow") )
						surface.DrawTexturedRect( -128, -90-128, 256, 256 )
						struc = {}
						struc["pos"] = {0, -110}
						struc["color"] = Color(255, 255, 255, 240)
						struc["text"] = "Kill"
						struc["font"] = "Text64"
						struc["xalign"] = TEXT_ALIGN_CENTER
						struc["yalign"] = TEXT_ALIGN_CENTER
						draw.TextShadow( struc, 2, 160 )
					cam.End3D2D()
				end
			end
		end
		for _, ent in pairs(ents.FindByClass("cw_flag")) do
			if(ent != nil)then
				cam.Start3D2D(ent:GetPos()+Vector(0,0,40), Angle(0,ang.y,90), 0.3)
					surface.SetDrawColor( 255, 255, 255, 220 );
					struc = {}
					struc["pos"] = {0, -110}
					struc["color"] = Color(255, 255, 255, 240)
					struc["font"] = "Text64"
					struc["xalign"] = TEXT_ALIGN_CENTER
					struc["yalign"] = TEXT_ALIGN_CENTER
					if (LocalPlayer():Team() != ent:GetNWInt("team"))then
						surface.SetTexture( surface.GetTextureID("mhs/green_arrow") )
						struc["text"] = "Capture"
						surface.DrawTexturedRect( -128, -90-128, 256, 256 )
						draw.TextShadow( struc, 2, 160 )
					elseif(!LocalPlayer().hasFlag)then
						surface.SetTexture( surface.GetTextureID("mhs/blue_arrow") )
						struc["text"] = "Defend"
						surface.DrawTexturedRect( -128, -90-128, 256, 256 )
						draw.TextShadow( struc, 2, 160 )
					end
				cam.End3D2D()
			end
		end
	else
		for _, ent in pairs(ents.FindByClass("cw_flag")) do
			if(ent != nil)then
				cam.Start3D2D(ent:GetPos()+Vector(0,0,40), Angle(0,ang.y,90), 0.3)
					surface.SetDrawColor( 255, 255, 255, 220 );
					struc = {}
					struc["pos"] = {0, -110}
					struc["color"] = Color(255, 255, 255, 240)
					struc["font"] = "Text64"
					struc["xalign"] = TEXT_ALIGN_CENTER
					struc["yalign"] = TEXT_ALIGN_CENTER
					if (ent:GetNWInt("team") == TEAM_RED)then
						surface.SetTexture( surface.GetTextureID("mhs/red_arrow") )
						struc["text"] = "Red Flag"
					else
						surface.SetTexture( surface.GetTextureID("mhs/blue_arrow") )
						struc["text"] = "Blue Flag"
					end
					surface.DrawTexturedRect( -128, -90-128, 256, 256 )
					draw.TextShadow( struc, 2, 160 )
				cam.End3D2D()
			end
		end
		for _,ply in pairs(player.GetAll( )) do
			if(ply.hasFlag)then
				cam.Start3D2D(ply:GetPos()+Vector(0,0,85), Angle(0,ang.y,90), 0.3)
					surface.SetDrawColor( 255, 255, 255, 220 );
					struc = {}
					struc["pos"] = {0, -110}
					struc["color"] = Color(255, 255, 255, 240)
					struc["font"] = "Text64"
					struc["xalign"] = TEXT_ALIGN_CENTER
					struc["yalign"] = TEXT_ALIGN_CENTER
					if (ply:Team() == TEAM_BLUE)then
						surface.SetTexture( surface.GetTextureID("mhs/red_arrow") )
						struc["text"] = "Red Flag"
					else
						surface.SetTexture( surface.GetTextureID("mhs/blue_arrow") )
						struc["text"] = "Blue Flag"
					end
					surface.DrawTexturedRect( -128, -90-128, 256, 256 )
					draw.TextShadow( struc, 2, 160 )
				cam.End3D2D()
			end
		end
	end
end
hook.Add("PostDrawOpaqueRenderables", "DrawBeacons", DrawBeacons)