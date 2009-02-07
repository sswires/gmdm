
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 75
	SWEP.PrintName			= "Scout";		
	SWEP.Slot				= 3;
	SWEP.SlotPos			= 6;
	SWEP.ViewModelFlip		= true;
	
	SWEP.IconLetter			= "n";
	killicon.AddFont( "gmdm_scout", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
end

SWEP.Base						= "gmdm_sniperbase";
SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel					= "models/weapons/w_snip_scout.mdl"

SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Recoil				= 0.85;
SWEP.Primary.Damage				= 32;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.Delay				= 1.5;
SWEP.IronsightsFOV				= 25; -- HVA Specific

SWEP.IronsightAccuracy			= 3.5; -- what to divide spread by to increase accuracy

SWEP.Primary.Sound				= Sound( "Weapon_Scout.Single" );

SWEP.IronSightsPos = Vector (4.959, -10.2188, 2.4821)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector (-4.436, -2.7145, -0.3405)
SWEP.RunArmAngle = Vector (-8.0181, -53.2216, 7.3013)
