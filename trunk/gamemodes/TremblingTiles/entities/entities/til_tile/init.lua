include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

ENT.FallSounds = {
	
	Sound( "doors/vent_open1.wav" ),
	Sound( "doors/vent_open2.wav" ),
	Sound( "doors/vent_open3.wav" )
	
};

ENT.ActivateSounds = {
	
	Sound( "physics/metal/sawblade_stick1.wav" ),
	Sound( "physics/metal/sawblade_stick2.wav" ),
	Sound( "physics/metal/sawblade_stick3.wav" )
	
}

ENT.PowerupGestures = {
	52,
	53,
	54,
	1413,
	1421,
	1422,
	1423,
	1424,
}

ENT.PowerupLines = {
	"answer25",
	"finally",
	"gotone01",
	"gotone02",
	"likethat",
	"thislldonicely01",
	"yeah02",
	"runforyourlife01",
	"runforyourlife02"
}

function ENT:Initialize()
	
	self:PhysicsInit( SOLID_BSP );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_BSP );
	
	self:SetNoDraw( false );
	
	local min, max = self:WorldSpaceAABB();
	self.Pos = ( min + max ) / 2; -- Brush entities have...issues...
	self.Min = min;
	self.Max = max;
	
	self.Dropped = false;
	
	self.Discharge = math.huge;
	
end

function ENT:StartTouch( ent )
	
	if( ent:CanActivateTile( self ) ) then
		
		if( self.Powerup and self.Powerup.OnGet and !self.Powerup.Disabled ) then
			
			self.Powerup.OnGet( ent );
			
			self:EmitSound( Sound( "physics/metal/metal_canister_impact_hard" .. math.random( 1, 3 ) .. ".wav" ) );
			
			self.Powerup.Disabled = true;
			self.Powerup:SetNWInt( "FadeStart", CurTime() );
			
			local gest = table.Random( self.PowerupGestures );
			ent:DoAnimationEvent( gest );
			umsg.Start( "msgDoGesture" );
				umsg.Short( gest );
				umsg.Entity( ent );
			umsg.End();
			
			umsg.Start( "msgSyncRenderPowerup" );
				umsg.Short( self.Powerup.RenderMat or 1 );
				umsg.Short( self.Powerup.Time );
				umsg.Entity( ent );
			umsg.End();
			
			if( table.HasValue( FemalePlayermodels, ent:GetModel() ) ) then
				
				ent:EmitSound( Sound( "vo/npc/female01/" .. table.Random( self.PowerupLines ) .. ".wav" ) );
				
			else
				
				ent:EmitSound( Sound( "vo/npc/male01/" .. table.Random( self.PowerupLines ) .. ".wav" ) );
				
			end
			
			local endFunc = self.Powerup.OnEndTime;
			local time = self.Powerup.Time;
			
			timer.Simple( time, function()
				
				if( ent and ent:IsValid() and ent:Alive() ) then
					
					endFunc( ent );
					
					if( self.Powerup and self.Powerup:IsValid() ) then
						
						self.Powerup:Remove();
						
					end
					
					if( self and self:IsValid() ) then
						
						self.Powerup = nil;
						
					end
					
				end
				
			end );
			
		end
		
		if( ent.Invincible ) then return end
		
		if( !self.Dropped and !DEBUG ) then
			
			self:EmitSound( table.Random( self.ActivateSounds ), 66, math.random( 70, 130 ) );
			self:SetColor( 255, 0, 0, 255 );
			self.Dropped = true;
			
			timer.Simple( 1, function()
				
				self:EmitSound( table.Random( self.FallSounds ), 33, math.random( 70, 130 ) );
				self:Drop();
				
			end );
			
		end
		
	end
	
end

function ENT:SetPowerup( ent )
	
	self.Powerup = ent;
	
end

function ENT:Think()
	
	if( self:GetVelocity() == Vector( 0, 0, 0 ) and CurTime() - self.Discharge > 1 ) then
		
		local phy = self:GetPhysicsObject();
		
		if( phy and phy:IsValid() ) then
			
			phy:EnableMotion( false );
			
		end
		
	end
	
end

function ENT:Drop()
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local phy = self:GetPhysicsObject();
	
	if( phy and phy:IsValid() ) then
		
		phy:Wake();
		phy:EnableMotion( true );
		
	end
	
	if( self.Powerup ) then
		
		self.Powerup:FadeAway();
		
	end
	self.Powerup = nil;
	
	self.Discharge = CurTime();
	
end
