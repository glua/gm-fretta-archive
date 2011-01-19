
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( "shared.lua" )
 
function ENT:Initialize()

	self.Entity:SetModel( self.Entity:GetModel() or "models/error.mdl" ) //This shouldn't happen, unless something got seriously fucked up
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )  
	
	local teamcol = team.GetColor( self.Entity:GetNWEntity( "Owner" ):Team() )
	self.Entity:SetColor( teamcol.r, teamcol.g, teamcol.b, 255 ) //Color == Team Color!
	
	local phys = self.Entity:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:EnableMotion( false ) //Freeze it
	end
	
	local volume = phys:GetVolume() + 4000 //Calculate HP according to volume (not accurate, but sufficient in most cases)
	local mdl = self.Entity:GetModel()
	
	if ( string.find( mdl, "blastdoor00")
	or string.find( mdl, "combine")) then //Overpowered stuff!
		volume = volume / 2.15
	end
	
	if ( string.find( mdl, "wood_crate00")
	or string.find( mdl, "kitchen_")
	or mdl == "models/props_wasteland/laundry_dryer002.mdl" ) then //Extremely overpowered stuff!
		volume = volume / 2.6
	end
	
	if ( mdl == "models/props_wasteland/prison_heavydoor001a.mdl" ) then //Underpowered stuff!
		volume = volume * 2.2
	end
	
	volume = math.floor( volume / 500 ) * 100 //Make it a "nice" number ( e.g. 25464 becomes 25400 )
	
	self.Entity:SetNWInt( "HP", volume )
	self.Entity:SetNWFloat( "Scale", 1 )
	
	------- Why is this even here? TODO: Readd if removing it breaks stuff -----
	/*local index = 0
	
	for i = 1, #PropList do
		if ( PropList[i][1] == self.Entity:GetModel() ) then
			index = i
			break
		end
	end*/

end

function ENT:OnTakeDamage( dmg )

	local att = dmg:GetAttacker()
	if ( att:IsValid() and att:IsPlayer() and att:Team() == self.Entity:GetNWEntity( "Owner" ):Team() ) then return end
	//^ Can only get damage from enemies!
	
	local HP = self.Entity:GetNWInt( "HP", 0 )
	local dmgA = math.ceil( dmg:GetDamage() * 1.5 )
	
	if ( dmg:IsExplosionDamage() ) then dmgA = dmgA * 8 end
	if ( dmg:IsBulletDamage() ) then dmgA = dmgA * 0.75 end
	
	self.Entity:SetNWInt( "HP", HP - dmgA )
	HP = HP - dmgA
	
	if ( HP <= 0 ) then
		local owner = self.Entity:GetNWEntity( "Owner", NULL )
		if ( ValidEntity( owner ) ) then owner:SetNWInt( "Props", owner:GetNWInt( "Props", 0 ) - 1 ) end
		self.Entity:Remove()
	end
	
	local owner = self.Entity:GetNWEntity( "Owner", NULL )
	if ( !ValidEntity( owner ) ) then return end
	
	local col = team.GetColor( owner:Team() )
	local efdata = EffectData()
	efdata:SetScale( dmgA )
	
	if ( dmg:IsBulletDamage() ) then
		efdata:SetOrigin( dmg:GetDamagePosition() )
	else
		efdata:SetOrigin( self:GetCenter() )
	end
	
	efdata:SetStart( Vector( col.r, col.g, col.b ) ) //Setting the start to a color is a smart way to send color information to the effect :)
	util.Effect( "entity_hit", efdata )
	
	self.Entity:TakePhysicsDamage( dmg )
	
end

function ENT:GetCenter()
	return self.Entity:LocalToWorld( self.Entity:OBBCenter() )
end
 
function ENT:Think()
	
	local flag = ents.FindByClass( "fw_flag" )[1]
	if ( !ValidEntity( flag ) ) then return end
	
	if ( GetGlobalInt( "RoundNumber" ) == 1 and ValidEntity( flag ) ) then
		if ( ( self.Entity:GetPos() - flag:GetPos() ):Length() < 100 ) then
			self.Entity:TakeDamage( self.Entity:GetNWInt( "HP", 0 ) / 2 )
			local owner = self.Entity:GetNWEntity( "Owner", NULL )
			if ( ValidEntity( owner ) ) then owner:PrintMessage( HUD_PRINTTALK, "Your prop is too close to the flag!" ) end
		end
	end
	
	self.Entity:NextThink( CurTime() + 1 )
    return true // Note: You need to return true to override the default next think time

end
 
function ENT:PhysicsUpdate( phys )
end