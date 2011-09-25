
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:SetScore( num )
	self:SetNWInt( "Score", num )
end

function meta:GetScore()
	return self:GetNWInt( "Score", 0 )
end

function meta:AddScore( num )
	self:SetNWInt( "Score", self:GetScore() + num )
end