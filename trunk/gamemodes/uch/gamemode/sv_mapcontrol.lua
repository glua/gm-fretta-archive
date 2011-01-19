
local whitelist = {
	"models/props_gameplay/resupply_locker.mdl",
	"models/props_gameplay/cap_point_base.mdl",
	"models/props_vehicles/train_enginecar.mdl",
	"models/props_skybox/train_enginecar_skybox.mdl",
	"models/props_mining/computer_industrial03.mdl",
	"models/props_spytech/corkboard01.mdl",
	"models/props_spytech/work_table001.mdl",
	"models/props_mining/computer_industrial04.mdl",
	"models/props_mining/computer_industrial01.mdl",
	"models/props_mining/computer_industrial02.mdl",
	"models/props_spytech/wall_clock.mdl",
	"models/props_spytech/exit_sign01.mdl",
	"models/props_spytech/intercom.mdl",
	"models/props_lights/light_cone_farm.mdl",
	"models/props_2fort/lantern001.mdl",
	"models/props_nucleus/mp_capbottom.mdl",
	"models/props_nucleus/mp_captop.mdl",
	"models/props_gameplay/sign_gameplay01.mdl"
};

function GM:RemoveDoors()
	local map = game.GetMap();
	if (map:Left(6) == "arena_") then
		for k, v in pairs(ents.FindByClass("func_brush")) do
			v:Remove();
		end
		/*for k, v in pairs(ents.FindByClass("func_door")) do
			if (!table.HasValue(whitelist, v:GetModel())) then
				//v:Remove();
			end
		end
		for k, v in pairs(ents.FindByClass("prop_dynamic")) do
			if (!table.HasValue(whitelist, v:GetModel())) then
				//v:Remove();
			end
		end*/
		for k, v in pairs(ents.FindByClass("info_player_start")) do
			v:Remove();
		end
		for k, v in pairs(ents.FindByClass("logic_relay")) do
			v:Fire("trigger");
		end
		for k, v in pairs(ents.FindByClass("func_door")) do
			v:Fire("open");
		end
	end
end
