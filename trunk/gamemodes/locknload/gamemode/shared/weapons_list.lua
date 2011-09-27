GM.RegisteredWeapons = {}

function GM:RegisterWeapon (cname, dtable, kvtable)
	table.insert (self.RegisteredWeapons, {
		classname = cname, drawtable = dtable, keyvaluetable = kvtable
	})
end

function GM:SortRegisteredWeapons()
	local wpntbl = weapons.GetList()
	for k,v in pairs (self.RegisteredWeapons) do
		for k2,v2 in pairs (wpntbl) do
			if v2.Classname == v.classname then
				v.wpntbl_entry = v2
			end
		end
	end
	table.sort (self.RegisteredWeapons, function (a,b) return a.wpntbl_entry.ListPosition < b.wpntbl_entry.ListPosition end)
end