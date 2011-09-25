// Runner Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Runner"
CLASS.Description = "Outrun them! \nPrimary: SMG \nSecondary: Pistol"
CLASS.WalkSpeed = 300
CLASS.RunSpeed = 450
CLASS.MaxHealth = 75
CLASS.StartHealth = 75

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_mp7")
	pl:Give("weapon_mad_usp_match")
	pl:Give("weapon_mad_flash")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Runner", CLASS )



// Assault Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Assault"
CLASS.Description = "Live longer! \n1:Machine Gun\n2:Shotgun \nTertiary: Resupply"
CLASS.WalkSpeed = 150
CLASS.RunSpeed = 250
CLASS.MaxHealth = 150
CLASS.StartHealth = 150

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_mp7")
	pl:Give("weapon_mad_m249")
	pl:Give("weapon_resupply")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Assault", CLASS )



// Sniper Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Sniper"
CLASS.Description = "Long range!\n1: Sniper\n2: Pistol"

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_awp")
	pl:Give("weapon_mad_usp_match")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Sniper", CLASS )


// Artillery Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Artillery"
CLASS.Description = "Use big guns!\n1: Bazooka\n2: Shotgun"
CLASS.WalkSpeed = 130
CLASS.RunSpeed = 250
CLASS.MaxHealth = 120
CLASS.StartHealth = 120

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_spas")
	pl:Give("weapon_mad_rpg")
	pl:Give("weapon_mad_magnade")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Artillery", CLASS )



// Medic Class
local CLASS= {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Medic"
CLASS.Description = "Heal 'em up \n1: AR2\n2: Medigun"

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_usp_match")
	pl:Give("weapon_mad_ar2")
	pl:Give("weapon_medigun")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Medic", CLASS)



// Techie class
local CLASS= {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Techie"
CLASS.Description = "Build machines!\n1: Shotgun\n2: Pistol"

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_usp_match")
	pl:Give("weapon_mad_spas")
	//pl:Give("weapon_slam")
	pl:Give("weapon_physcannon")
	pl:Give("weapon_techie")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Techie", CLASS)

