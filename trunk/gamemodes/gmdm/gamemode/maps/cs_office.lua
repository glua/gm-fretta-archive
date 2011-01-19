MAP.FriendlyName = "Office";
MAP.RemoveSpawns = true;

function MAP:DoSpawns()
	self:AddSpawn( TEAM_UNASSIGNED, Vector( 1518.9160, 1026.1757, -159.9688 ), Angle( 0.000, -140.869, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( 2269.2839, -355.1317, -159.9688 ), Angle( 0.000, 140.811, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( 1574.3041, -611.0353, -159.9688 ), Angle( 0.000, 126.431, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( 884.0598, -287.9688, -159.9688 ), Angle( 0.000, 24.173, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( 551.7495, 398.9994, -159.9688 ), Angle( 0.000, 92.013, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -47.9688, 16.0313, -159.9688 ), Angle( 0.000, 47.903, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -890.6305, -258.7040, -159.9688 ), Angle( 0.000, 47.853, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -876.9842, 468.9496, -159.9688 ), Angle( 0.000, 32.373, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -1375.3385, 448.0035, -287.2618 ), Angle( 0.000, 40.880, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -852.2692, 321.8922, -361.0497 ), Angle( 0.000, -8.620, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -887.8556, -1207.4048, -239.9813 ), Angle( 0.000, 42.200, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -1775.9688, -1599.9688, -327.9688 ), Angle( 0.000, 50.340, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -524.8763, -1579.3701, -327.9688 ), Angle( 0.000, -143.556, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( -46.1336, -1594.5382, -327.9688 ), Angle( 0.000, -32.456, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( 287.6978, -1334.0359, -279.9688 ), Angle( 0.000, 1.564, 0.000 ) )
	self:AddSpawn( TEAM_UNASSIGNED, Vector( 748.0779, -1072.0313, -252.5218 ), Angle( 0.000, -42.876, 0.000 ) )
	
	self:AddPickup( Vector( 89.000000, -272.156250, -100.968750 ), "gmdm_smg" );
	self:AddPickup( Vector( 669.125000, 956.843750, -100.968750 ), "gmdm_tripmine" );
	self:AddPickup( Vector( -1213.5056, 851.2554, -301.8297 ), "gmdm_rpg" );
	self:AddPickup( Vector( -1152.2509, -759.6990, -303.9659 ), "gmdm_shotgun" );
	self:AddPickup( Vector( -672.0250, -946.3970, -126.7816 ), "gmdm_egon" );
	self:AddPickup( Vector( 956.3975, -500.2550, -129.9688 ), "gmdm_crossbow" );
	self:AddPickup( Vector( 762.1973, -1476.3943, -66.4719 ), "gmdm_rail" );
	self:AddPickup( Vector( 117.3484, -1789.3446, -300.6819 ), "gmdm_electicity_nades" );
	self:AddPickup( Vector( -339.0284, -188.1074, -135.6883 ), "gmdm_shotgun" );
	self:AddPickup( Vector( -771.5071, 655.8231, -123.5724 ), "gmdm_smg" );
	self:AddPickup( Vector( -617.8799, -1133.6589, -203.3523 ), "gmdm_crossbow" );
	self:AddPickup( Vector( -1633.7095, -127.4001, -209.9688 ), "gmdm_crossbow" );
	self:AddPickup( Vector( -1531.6525, -1591.0840, -297.9688 ), "gmdm_smg" );
	self:AddPickup( Vector( -1207.7834, -1899.6388, -305.9688 ), "gmdm_rpg" );
	self:AddPickup( Vector( 1112.1136, -1654.1166, -287.0127 ), "gmdm_rpg" );
	self:AddPickup( Vector( 1493.0979, -465.6176, -129.9688 ), "gmdm_tripmine" );
	self:AddPickup( Vector( 2185.9746, -195.5529, -99.9467 ), "gmdm_egon" );
	self:AddPickup( Vector( 1216.6108, 150.3221, -129.9688 ), "gmdm_smg" );
	self:AddPickup( Vector( 1732.0734, 701.8234, -129.9688 ), "gmdm_shotgun" );
	self:AddPickup( Vector( 434.4256, -904.4221, -193.9688 ), "gmdm_rail" );
	self:AddPickup( Vector( -6.5308, -1095.8669, -193.9688 ), "gmdm_rpg" );
end
