
local ent = FindMetaTable( "Entity" )
local player = FindMetaTable( "Player" )
if (!ent) then return end 

function ent:SetLastGrabber( ply )

	self:SetNWEntity( "L_Grabber", ply )
	self:SetNWEntity( "L_Affector", ply )

end

function ent:GetLastGrabber( ply )

	return self:GetNWEntity( "L_Grabber" ) or self

end

function ent:SetLastPunter( ply )

	self:SetNWEntity( "L_Punter", ply )
	self:SetNWEntity( "L_Affector", ply )

end

function ent:GetLastPunter( ply )

	return self:GetNWEntity( "L_Punter" ) or self

end

function ent:SetLastAffector( ply )

	self:SetNWEntity( "L_Affector", ply )

end

function ent:GetLastAffector( ply )

	return self:GetNWEntity( "L_Affector" ) or self

end

if (!player) then return end

function player:GetDeliveries( )

	return self:GetNWInt( "P_Delivery" )

end

function player:SetDeliveries( num )

	self:SetNWInt( "P_Delivery", num )
	
end

function player:AddDeliveries( num )

	self:SetDeliveries( self:GetDeliveries() + num )
	
end

function player:GetSteals( )

	return self:GetNWInt( "P_Steals" )
	
end

function player:SetSteals( num )

	self:SetNWInt( "P_Steals", num )
	
end

function player:AddSteals( num )

	self:SetSteals( self:GetSteals() + num )
	
end


