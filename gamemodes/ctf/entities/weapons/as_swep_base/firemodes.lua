-- firemodes
AF_AUTOMATIC					= 1;
AF_SEMIAUTOMATIC				= 2;
AF_BURSTFIRE					= 3;

SWEP.MultipleFiremodes			= false;
SWEP.DefaultFiremode			= AF_AUTOMATIC;
SWEP.SupportedFiremodes			= { AF_AUTOMATIC, AF_BURSTFIRE };

SWEP.FiremodeSwitchSound		= Sound( "Weapon_SMG1.Special1" );

SWEP.Primary[ AF_AUTOMATIC ] 					= {}
SWEP.Primary[ AF_AUTOMATIC ].FireModeName 		= "Automatic";
SWEP.Primary[ AF_AUTOMATIC ].Automatic 			= true;
SWEP.Primary[ AF_AUTOMATIC ].BurstShots			= 0;

SWEP.Primary[ AF_SEMIAUTOMATIC ] 				= {}
SWEP.Primary[ AF_SEMIAUTOMATIC ].FireModeName 	= "Semi-Automatic";
SWEP.Primary[ AF_SEMIAUTOMATIC ].Automatic 		= false;
SWEP.Primary[ AF_SEMIAUTOMATIC ].BurstShots		= 0;

SWEP.Primary[ AF_BURSTFIRE ]					= {}
SWEP.Primary[ AF_BURSTFIRE ].Automatic			= false;
SWEP.Primary[ AF_BURSTFIRE ].BurstShots			= 2;
SWEP.Primary[ AF_BURSTFIRE ].FireModeName 		= "Burst Fire";


function SWEP:InstallFiremode( fm )
	if( self.Primary[ fm ] and fm != self.Firemode) then
		for k, v in pairs( self.Primary[fm] ) do
			self.Primary[ k ] = v;
		end
		
		if( SERVER ) then
			self.Weapon:SetNetworkedInt( "Firemode", fm );
			
			if( self.Owner and self.Owner:IsValid() ) then
				self.Owner:EmitSound( self.FiremodeSwitchSound );
			end
		end
		
		if( self.PlaySwitchAnimation ) then
			self.Weapon:SendWeaponAnim( self.SwitchAnimation );
		end
		
		self.Firemode = fm;
		MsgN( "Firemode set : " .. fm );
	end
end

function SWEP:SelectFiremode( )

	if( CLIENT ) then return end 
	
	local current = self.Firemode;
	local available = self.SupportedFiremodes;
	local cavailable = #available;
	
	local idealFiremode = 1;
	
	if( cavailable > 1 ) then
		for k, v in pairs( available ) do
			if( v == current and k < cavailable ) then
				idealFiremode = k+1;
			end
		end
	end
	
	self:InstallFiremode( available[ idealFiremode ] );
end
