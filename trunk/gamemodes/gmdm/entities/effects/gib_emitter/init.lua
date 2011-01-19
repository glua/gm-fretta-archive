

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Normal = data:GetNormal()
	
	// Make Bloodstream effects
	for i= 0, cl_gmdm_gib_numblood:GetInt() do
		local effectdata = EffectData()
			effectdata:SetOrigin( Pos + i * Vector(0,0,4) )
			effectdata:SetNormal( Normal )
		util.Effect( "bloodstream", effectdata )
	end
	
	// Spawn Gibs
	if( cl_gmdm_gibstaytime:GetInt() > 0 ) then
		for i = 0, cl_gmdm_gib_numbodyparts:GetInt() do
		
			local effectdata = EffectData()
				effectdata:SetOrigin( Pos + i * Vector(0,0,4) + VectorRand() * 8 )
				effectdata:SetNormal( Normal )
			util.Effect( "gib_bodypart", effectdata )
		end
	end
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	// Die instantly
	return false
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	// Do nothing - this effect is only used to spawn the particles in Init
	
end

cl_gmdm_gib_numbodyparts = CreateClientConVar( "cl_gmdm_gib_numbodyparts", "8", true, false );
cl_gmdm_gib_numblood = CreateClientConVar( "cl_gmdm_gib_numblood", "12", true, false );




