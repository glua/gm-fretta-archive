local meta = FindMetaTable( "Player" );
local emeta = FindMetaTable( "Entity" );

GibAmt = 12; -- formerly 20

function GM:DoPlayerDeath( ply, attacker, dmginfo ) -- fretta stuff minus unnecessary stuff
	
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:AddDeaths( 1 )
	ply.CanDieAcid = false;
	
	DoBystanderScreams( ply );
	
end

function meta:GibDeath()
	
	local origin = self:GetPos();
	local vel = self:GetVelocity();
	
	umsg.Start( "msgGibFX" );
		umsg.Vector( origin );
	umsg.End();
	
	for _ = 1, GibAmt do
		
		local ent = ents.Create( "cube_gib" );
		ent:SetPos( Vector( origin.x, origin.y, math.random( origin.z, origin.z + 72 ) ) );
		ent:Spawn();
		ent:SetVelocity( vel + Vector( math.random( -20, 20 ), math.random( -20, 20 ), math.random( -20, 20 ) ) );
		
		table.insert( self.SpawnRemoveEnts, ent );
		
	end
	
end

function meta:FreezeDeath()
	
	local origin = self:GetPos();
	local vel = self:GetVelocity();
	
	for _ = 1, GibAmt do
		
		local ent = ents.Create( "cube_gib_frozen" );
		ent:SetPos( Vector( origin.x, origin.y, math.random( origin.z, origin.z + 72 ) ) );
		ent:Spawn();
		ent:SetVelocity( vel + Vector( math.random( -20, 20 ), math.random( -20, 20 ), math.random( -20, 20 ) ) );
		
		table.insert( self.SpawnRemoveEnts, ent );
		
	end
	
end

function meta:BurnDeath()
	
	self:SetModel( "models/Humans/Charple01.mdl" );
	self:CreateRagdoll();
	
	local rag = self:GetRagdollEntity();
	rag:Ignite( 10, 0 );
	
end

function meta:ExplodeDeath()
	
	local origin = self:GetPos();
	local vel = self:GetVelocity();
	
	umsg.Start( "msgGibFX" );
		umsg.Vector( origin );
	umsg.End();
	
	for _ = 1, GibAmt do
		
		local ent = ents.Create( "cube_gib" );
		ent:SetPos( Vector( origin.x, origin.y, math.random( origin.z, origin.z + 72 ) ) );
		ent:Spawn();
		ent:Ignite( 10, 0 );
		ent:SetVelocity( vel + Vector( math.random( -20, 20 ), math.random( -20, 20 ), math.random( -20, 20 ) ) );
		
		table.insert( self.SpawnRemoveEnts, ent );
		
	end
	
end

function meta:DissolveDeath()
	
	self:CreateRagdoll();
	
	local ent = self:GetRagdollEntity();
	
	local dissolve = ents.Create( "env_entity_dissolver" );
	dissolve:SetPos( ent:GetPos() );
	
	ent:SetName( tostring( ent ) );
	dissolve:SetKeyValue( "target", ent:GetName() );
	
	dissolve:SetKeyValue( "dissolvetype", "0" );
	dissolve:Spawn();
	dissolve:Fire( "Dissolve", "", 0 );
	dissolve:Fire( "kill", "", 1 );
	
end

function meta:CrushDeath()
	
	local origin = self:EyePos();
	
	local traceDiffs = { };
	
	for i = 0, 40, 5 do
		
		for j = 0, 360, 45 do
			
			local x = math.cos( j ) * i;
			local y = math.sin( j ) * i;
			table.insert( traceDiffs, Vector( x, y, 0 ) );
			
		end
		
	end
	
	for _, v in pairs( traceDiffs ) do -- splat
		
		local trace = { };
		trace.start = origin;
		trace.endpos = trace.start - Vector( 0, 0, 72 );
		trace.filter = self;
		
		local tr = util.TraceLine( trace );
		
		tr.HitPos = tr.HitPos + v;
		
		util.Decal( "Blood", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal );
		
	end
	
end

function emeta:GibBodyPart( bone, mdl )
	
	local look = bone;
	if( type( bone ) == "string" ) then
		look = self:LookupBone( bone );
	end
	
	local matrix = self:GetBoneMatrix( look );
	local pos = matrix:GetTranslation();
	
	umsg.Start( "msgRemoveRagBone" );
		umsg.Short( look );
		umsg.Entity( self );
	umsg.End();
	
	umsg.Start( "msgDecapFX" );
		umsg.Vector( pos );
	umsg.End();
	
	if( mdl ) then
		
		local ent = ents.Create( "cube_gib" );
		ent:SetPos( pos );
		ent:SetModel( mdl );
		ent:Spawn();
		
		table.insert( self.SpawnRemoveEnts, ent );
		
	end
	
end

function meta:DecapitateDeath()
	
	self:CreateRagdoll();
	local rag = self:GetRagdollEntity();
	local attach = rag:LookupAttachment( "forward" );
	local angpos = rag:GetAttachment( attach );
	--[[
	umsg.Start( "msgDecapFX" );
		umsg.Vector( angpos.Pos );
	umsg.End();--]]
	
	local e = ents.Create( "info_particle_system" );
	e:SetPos( rag:EyePos() );
	e:SetKeyValue( "effect_name", "blood_advisor_puncture_withdraw" );
	e:SetKeyValue( "start_active", "1" );
	e:Spawn();
	e:Activate();
	e:SetParent( rag );
	
	table.insert( self.SpawnRemoveEnts, e );
	
	timer.Simple( 0.1, function()
		
		rag:GibBodyPart( 6 );
		
	end );
	
end

function meta:AcidDeath( ent, pos, ang )
	
	self:SetCameraPos( pos, ang );
	
	timer.Simple( 3, function()
		
		if( self.CanDieAcid ) then
			
			self:GibBodyPart( "ValveBiped.Bip01_L_Hand", "models/Gibs/HGIBS_scapula.mdl" );
			
		end
		
	end );
	
	timer.Simple( 5, function()
		
		if( self.CanDieAcid ) then
			
			self:GibBodyPart( "ValveBiped.Bip01_L_Forearm", "models/Gibs/HGIBS_scapula.mdl" );
			self:EmitSound( Sound( "vo/npc/male01/myarm0" .. math.random( 1, 2 ) .. ".wav" ), 100, math.random( 70, 130 ) );
			
		end
		
	end );
	
	timer.Simple( 7, function()
		
		if( self.CanDieAcid ) then
			
			self:GibBodyPart( "ValveBiped.Bip01_L_UpperArm", "models/Gibs/HGIBS_scapula.mdl" );
			
		end
		
	end );
	
	timer.Simple( 9, function()
		
		if( self.CanDieAcid ) then
			
			self:TakeDamage( 200, ent, ent );
			
			umsg.Start( "msgResetRagBone" ); -- Give them their arm back
				umsg.Entity( self );
			umsg.End();
			
		end
		
		self.CanDieAcid = false;
		
	end );
	
end

function SuicideDeath( wep )
	
	timer.Simple( 0, function() -- Next think frame
		
		if( wep:GetClass() == "weapon_suicidegun" ) then
			
			wep:GetOwner():SelectWeapon( "weapon_suicidegun" );
			
		end
		
	end );
	
end
hook.Add( "WeaponEquip", "SuicideDeath", SuicideDeath );

function GM:PlayerDeathSound()
	return true;
end

function DeathSoundHook( ply, inflictor, attacker )
	
	if( !ply.Falling ) then
		
		if( table.HasValue( F_PLAYERMODELS, ply:GetModel() ) ) then
			
			ply:EmitSound( table.Random( F_DEATH_SOUNDS ), 100, math.random( 85, 115 ) );
			
		else
			
			ply:EmitSound( table.Random( M_DEATH_SOUNDS ), 100, math.random( 85, 115 ) );
			
		end
		
	end
	
end
hook.Add( "PlayerDeath", "DeathSoundHook", DeathSoundHook );
