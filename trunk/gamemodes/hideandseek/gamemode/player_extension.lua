
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:Blind()
	self:SetNWBool( "isblind", true )
end

function meta:UnBlind()
	self:SetNWBool( "isblind", false )
end

