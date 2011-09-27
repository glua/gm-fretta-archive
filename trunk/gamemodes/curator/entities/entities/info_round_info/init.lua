ENT.Type = "point"
ENT.Base = "base_point"

function ENT:Initialize() --just an empty function... this really is just a definition of a point.
	
end 

function ENT:KeyValue(k,v)
	if k == "EndRelay" then
		self.EndRelayName = v
	elseif k == "StartRelay" then
		self.StartRelayName = v
	end
end 

--This entity is a bit special. But none of It's code needs to be made here.