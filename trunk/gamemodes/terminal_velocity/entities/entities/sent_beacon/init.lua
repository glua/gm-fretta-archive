
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/props_c17/substation_stripebox01a.mdl" )
	
	local tracedata = {}
	tracedata.start = self.Entity:GetPos()
	tracedata.endpos = self.Entity:GetPos() + Vector(0,0,-1000)
	tracedata.filter = self.Entity
	local tr = util.TraceLine( tracedata )
	
	self.Entity:SetPos( tr.HitPos + Vector(0,0,90) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE ) 
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:DetermineTeam()

end

function ENT:Think()

end

function ENT:OnTakeDamage( dmg )

end 

function ENT:DetermineTeam()

	local tbl = ents.FindByClass( "info_player*" )
	local dist = 90000
	
	for k,v in pairs( tbl ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < dist then
		
			dist = v:GetPos():Distance( self.Entity:GetPos() )
			
			if v:GetClass() == "info_player_terrorist" then
			
				self.Team = TEAM_RED
			
			else
			
				self.Team = TEAM_BLUE
			
			end
		
		end
	
	end
	
	if not self.Team then
	
		self.Entity:Remove()
	
	else
	
		local col = table.Copy( team.GetColor( self.Team ) )
		self.Entity:SetColor( col.r, col.g, col.b, 255 )
		
		self.Entity:SetNWInt( "Team", self.Team )
	
	end

end
