
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 55
	SWEP.PrintName			= "Springfield";		
	SWEP.Slot				= 3;
	SWEP.SlotPos			= 5;
end

SWEP.Base						= "gmdm_sniperbase";
SWEP.IsCSWeapon					= false;
SWEP.ViewModel					= "models/weapons/v_springfield.mdl"
SWEP.WorldModel					= "models/weapons/w_springfield.mdl"

SWEP.Primary.ClipSize			= 5;

SWEP.Primary.Sound				= Sound( "Weapon_Springfield.Shoot" );


SWEP.RunArmOffset = Vector (10.3605, 0.0137, -0.5843)
SWEP.RunArmAngle = Vector (-5.2527, 40.9672, 1.4453)