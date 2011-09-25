include('shared.lua')

function ClearTips()
	local fr = vgui.Create("DFrame")
	fr:SetPos(0,0)
	fr:SetSize(1,1)
	fr:MakePopup()
	fr.Paint = function() end
	timer.Simple(0.1,function() fr:Remove() end)
end
	
usermessage.Hook("Techie-ShowMenu",function()
	
	local f = vgui.Create("DFrame")
	f:SetSize(450,150)
	f:Center()
	f:SetTitle("")
	f:MakePopup()
	
	f.Paint = function()
		draw.RoundedBox(0,0,0,f:GetWide(),f:GetTall(),Color(0,0,0,200))
		draw.DrawText("Construction Menu","ScoreboardText",f:GetWide()/2,4,color_white,1)
	end
	
	local build_list = vgui.Create("DPanelList",f)
	build_list:SetSize(400, f:GetTall() - 50 )
	build_list:SetPos(f:GetWide()/2 - build_list:GetWide() / 2,30)
	build_list:EnableHorizontal(true)
	build_list:SetPadding(10)
	build_list:SetSpacing(25)
	
	local buildings = {
		{"ta/ta-techie-manhacks","techie_manhacks","Manhacks"},
		{"ta/ta-techie-turret","techie_turret","Turret",},
		{"ta/ta-techie-barrier","","Barricades",function() ShowBarriersMenu() end},
		{"ta/ta-techie-spawner","techie_spawner","Item Generator"},
	}
	
	for _,v in ipairs(buildings) do
		local img = vgui.Create("DImageButton",build_list)
		img:SetSize(75,75)
		img:SetImage(v[1])
		img:SetToolTip(v[3])
		img.DoClick = function() 
			if v[4] then v[4]() end
			RunConsoleCommand(v[2]) 
			f:Close()
			ClearTips()
		end
		
		
		build_list:AddItem(img)
	end

end)

function ShowBarriersMenu()

	local f = vgui.Create("DFrame")
	f:SetSize(120,300)
	f:Center()
	f:SetTitle("")
	f:MakePopup()
	
	f.Paint = function()
		draw.RoundedBox(0,0,0,f:GetWide(),f:GetTall(),Color(0,0,0,200))
		draw.DrawText("Barriers","ScoreboardText",f:GetWide()/2,4,color_white,1)
	end
	
	local build_list = vgui.Create("DPanelList",f)
	build_list:SetSize(75, f:GetTall() - 60)
	build_list:SetPos(f:GetWide() / 2 - build_list:GetWide()/2,30)
	
	build_list:SetPadding(5)
	build_list:SetSpacing(20)
	
	
	local types = {
	[1] = { 
		model = "models/devin/barricade_small.mdl",
		health = 250,
		buildtime = 10,
		height = 106.146,
		},
	[2] = {
		model = "models/devin/barricade_medium.mdl",
		health = 500,
		buildtime = 20,
		height = 106.146,
		},
	[3]  = {
		model = "models/devin/barricade_large.mdl",
		health = 1000,
		buildtime = 30,
		height = 127.290,
		raiseup = 55,
		}
	}
	
	for k,v in ipairs(types) do
		local icon = vgui.Create("SpawnIcon")
		icon:SetModel(v.model)
		icon:SetToolTip("Health: "..v.health.."\nBuildtime: "..v.buildtime)
		icon.OnMousePressed = function()
			RunConsoleCommand("techie_barrier",k)
			f:Close() 
			ClearTips()
		end
		build_list:AddItem(icon)
	end
	
end