ENT.Type = "brush"
ENT.LastThink = 0
ENT.Active = false
ENT.Players = {}

function ENT:SetActive( bewl )

	self.Active = bewl
	
	for k,v in pairs( self.Players ) do
		v:EmitSound( GAMEMODE.ExitHill )
	end	
	
	self.Players = {}
	
end

function ENT:PassesTriggerFilters( ent )

	return ent:IsPlayer() and self.Active and GAMEMODE:InRound()
	
end

function ENT:Think()

	if self.LastThink > CurTime() or !GAMEMODE:InRound() or not self.Active then return end
	
	self.LastThink = CurTime() + 1
	
	if self.Players[1] == nil then
		for k,v in pairs( player.GetAll() ) do
			v:SetNWInt( "hillowner", 0 )
		end
		return
	end
	
	local conflict
	
	for k,v in pairs( self.Players ) do
		if not conflict then
			conflict = v:Team()
		end
		if v:Team() != conflict then
			for k,v in pairs( player.GetAll() ) do
				v:SetNWInt( "hillowner", 0 )
			end
			return
		end
	end
	
	self.Entity:GiveTime( conflict )
	
end

function ENT:GiveTime( teamnum )

	for k,v in pairs( player.GetAll() ) do
		v:SetNWInt( "hillowner", teamnum )
	end
	
	for k,v in pairs( self.Players ) do
		if v:Team() == teamnum and v:Alive() then
			v:AddTime()
		end
	end
	
end

function ENT:GetPlayers()

	return self.Players or {}
	
end

function ENT:AddPlayer( ply )

	if not table.HasValue( self.Players, ply ) then
		table.insert( self.Players, ply )
		ply:EmitSound( GAMEMODE.EnterHill, 100, 120 )
	end
	
end

function ENT:StartTouch( ent )

	if self.Entity:PassesTriggerFilters( ent ) then
		self.Entity:AddPlayer( ent )
	end
	
end

function ENT:EndTouch( ent )

	if self.Entity:PassesTriggerFilters( ent ) then
	
		local num 
		
		for k,v in pairs( self.Players ) do
			if v == ent then
				num = k
				v:EmitSound( GAMEMODE.ExitHill )
			end
		end
		
		if num then
			table.remove( self.Players, num )
		end
	end
end
