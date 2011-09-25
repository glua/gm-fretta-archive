
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


//Grid size
local maxX, maxY, maxZ = 23,23,11

//Block Size
local sizeX, sizeY, sizeZ = 128,128,128

//enums
SPACE_VOID = 0	// unused space
SPACE_BLOCK = 1	// sapce taken up by a block
SPACE_MAP = 2	// space accessible by players


function GM:InitPostEntity()
	
	self.BaseClass:InitPostEntity()

	self.grid = {}
	self.RecordEnts = 0
	self.entsCount = 0
	self.maxEnts = 0
	
	self:ClearGrid()

end

function GM:OnPreRoundStart( num )

	self:ClearGrid()
	self.BaseClass:OnPreRoundStart( num )

	self.entsCount = 0
	self.maxEnts = 0
	
end

// sets every grid pos to false
function GM:ClearGrid()

	// Print entity stats from last round.
	if( self.entsCount > self.RecordEnts ) then self.RecordEnts = self.entsCount end
	print('\n==============================')
	print( 'Entity Stats:' )
	print( "Finishing ents:", self.entsCount )
	print( "Max ents:", self.maxEnts )
	print( "Record Ents:", self.RecordEnts )
	print('==============================\n')

	//Clear Grid
	for x = 1,maxX do
		self.grid[x] = {}
		for y=1,maxY do
			self.grid[x][y] = {}
			for z=1,maxZ do
				self.grid[x][y][z] = SPACE_VOID
			end
		end
	end
end

// Return the status of a grid position
function GM:GetGrid(x,y,z)
	
	// If position is outside the bounds of the map it's classed as a block
	if( self.grid[x] == nil || self.grid[x][y] == nil || self.grid[x][y][z] == nil ) then
		return SPACE_BLOCK
	end
	return self.grid[x][y][z]
end

// Set the status of a grid position
function GM:SetGrid( x,y,z, status )
	self.grid[x][y][z] = status
end

//Get Random usable grid coord of given staus
function GM:GetRandomGrid( staus )

	for x,_ in RandomPairs( self.grid ) do
		for y,_ in RandomPairs( self.grid[x] ) do
			for z,_ in RandomPairs( self.grid[x][y] ) do
				if( self.grid[x][y][z] == staus && z > 1 ) then
					return x,y,z
				end
			end
		end
	end

	// Fallback in case we failed
	return math.random(maxX), math.random(maxY), math.random(maxZ) 

end

// Set a grid position as hollow and surround it with blocks
function GM:GridSetHollow( ent, x,y,z )

	if( ent != NULL && !ent.PlayerDamaged ) then return end

	// flag gridpos as part of the map
	self:SetGrid( x,y,z, SPACE_MAP )

	// spawn blocks surrounding it
	for i = -1, 1, 2 do
		if( self:GetGrid( x+i,y,z ) == SPACE_VOID ) then self:SpawnBlock(x+i,y,z) end
		if( self:GetGrid( x,y+i,z ) == SPACE_VOID ) then self:SpawnBlock(x,y+i,z) end
		if( self:GetGrid( x,y,z+i ) == SPACE_VOID ) then self:SpawnBlock(x,y,z+i) end
	end
end

// Spawn a block (duh)
function GM:SpawnBlock( x,y,z )

	self:SetGrid( x,y,z, SPACE_BLOCK )
	
	local fade = (255/maxZ) * z/3
	local Pos = Vector( x*sizeX, y*sizeY, z*sizeZ )
	local size = Vector(128,128,64)

	local block = ents.Create( 'func_breakable' )
		block.Coords = { x,y,z }
		block:SetPos( Pos )
		block:SetModel("*1")
		block:SetColor( fade, fade,fade, 255 )
		block:SetKeyValue('health',1)
		block:SetKeyValue('disablereceiveshadows',1)
		block:SetKeyValue('disableshadows',1)
		block:SetKeyValue('material',8)
		block:SetKeyValue('PerformanceMode',3)
		block:SetKeyValue('spawnflags',2048)
		block:CallOnRemove( "SetHollow",
			function( ent, x,y,z )
				GAMEMODE.entsCount = GAMEMODE.entsCount - 1
				GAMEMODE:GridSetHollow( ent, x,y,z )
			end,
		x,y,z )
	block:Spawn()

	// Add 1 to the ent count
	self.entsCount = self.entsCount + 1
	if( self.entsCount > self.maxEnts ) then
		self.maxEnts = self.entsCount
	end

	// Finish the game early if we're aproaching the max ents limit.
	if( self.entsCount > 1600 ) then
		for _,pl in pairs( player.GetAll() ) do
			pl:Freeze( true )
		end
		if( self:InRound() ) then self:RoundEnd() end
	end

end

function GM:PlayerSelectSpawn( pl )

	local spawnpoint = self.BaseClass:PlayerSelectSpawn( pl )
	local x,y,z
	
	if( pl:Team() == TEAM_SPECTATOR || pl.m_bFirstSpawn ) then
		// Start spectators in an existing part of the map
		x,y,z = self:GetRandomGrid( SPACE_MAP )
	else
		// Start players in an unused part of the map
		x,y,z = self:GetRandomGrid( SPACE_VOID )
		self:GridSetHollow( NULL, x,y,z )
	end

	// Move the spawnpoint to the grid coords
	spawnpoint:SetPos( Vector( x*sizeX, y*sizeY, z*sizeZ-60 ) )

	return spawnpoint
end

function GM:PlayerDeath( victim, inflictor, attacker )

	// Check if the player fell to their death and if this was cause by another player
	if( inflictor == GetWorldEntity() || inflictor:GetClass() == 'trigger_hurt' ) then
		if( IsValid( victim.lastGroundEnt ) && victim.lastGroundEnt:IsPlayer() ) then
			attacker = victim.lastGroundEnt
		end
	end

	self.BaseClass:PlayerDeath(  victim, inflictor, attacker )
	
end

function GM:DoPlayerDeath( victim, attacker, dmginfo )

	// Check if the player fell to their death and if this was cause by another player
	if( attacker == GetWorldEntity() || attacker:GetClass() == 'trigger_hurt' ) then
		if( IsValid( victim.lastGroundEnt ) && victim.lastGroundEnt:IsPlayer() ) then
			attacker = victim.lastGroundEnt
		end
	end

	self.BaseClass:DoPlayerDeath(  victim, attacker, dmginfo )
	
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	// If falldamage, half it
	if( ent:IsPlayer() && dmginfo:GetDamageType() == DMG_FALL ) then
		dmginfo:ScaleDamage( 0.75 )
	end

	// Rock breaker does no damage to players
	if( ent:IsPlayer() && attacker:IsPlayer() && attacker:GetActiveWeapon():GetClass() == 'rock_breaker' ) then
		dmginfo:ScaleDamage( 0 )
	end	

	
	// If not a block for not player damage, finish here
	if( ent:GetClass() != 'func_breakable' || !attacker:IsPlayer() ) then return end

	// block was damaged by a player, check if they were using a breaker gun
	if( attacker:GetActiveWeapon():GetClass() != 'rock_breaker' ) then
		dmginfo:SetDamage( 0 )
		return
	end

	ent.PlayerDamaged = true

	// Check if another player was standing on this block, if it is, set the attacker as the ground ent
	for _,pl in pairs( player.GetAll() ) do
		if( pl.lastGroundEnt == ent ) then
			pl.lastGroundEnt = attacker
		end
	end
	
end

function GM:Think()

	self.BaseClass:Think()
	
	// Save the players last ground entity
	for _,pl in pairs( player.GetAll() ) do
		local GroundEnt = pl:GetGroundEntity()
		if( IsValid( GroundEnt ) && GroundEnt != pl.lastGroundEnt ) then
			pl.lastGroundEnt = GroundEnt
		end
	end

end