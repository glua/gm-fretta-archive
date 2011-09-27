ENT.Type = "brush"
ENT.Base = "base_brush"

function ENT:Think()

end 

function ENT:KeyValue(k,v)
	if k == "RequiredItems" then
		self.ReqItems = string.Explode(";",string.gsub(string.lower(v)," ",""))
	elseif k == "TargetRelay" then
		self.RelayName = v
	elseif k == "CuratorRelay" then
		self.CurRelayName = v
	elseif k == "CuratorCost" then
		self.CurRelayCost = v
	elseif k == "CuratorText" then
		self.CurTxt = v
	end
end 
