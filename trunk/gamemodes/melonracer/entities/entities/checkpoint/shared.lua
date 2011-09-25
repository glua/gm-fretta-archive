 	
ENT.Type 		= "brush"

AddCSLuaFile( "shared.lua" )

AccessorFunc( ENT, "m_iNumber", 		"Number" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

end

/*---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )

	if ( self:PassesTriggerFilters( entity ) ) then
		hook.Call( "PlayerHitCheckpoint", GAMEMODE, entity, self:GetNumber() )
	end

end

/*---------------------------------------------------------
   Name: KeyValue
---------------------------------------------------------*/
function ENT:KeyValue( key, value )
	if ( key == "number" ) then
		self:SetNumber( tonumber(value) )
	end
end

/*---------------------------------------------------------
   Name: PassesTriggerFilters
---------------------------------------------------------*/
function ENT:PassesTriggerFilters( entity )
	return entity:GetClass() == "player_melon"
end
