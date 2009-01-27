
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 80
	SWEP.PrintName			= "AUG";		
	SWEP.Slot				= 3;
	SWEP.SlotPos			= 6;
	SWEP.ViewModelFlip		= true;
	
	SWEP.IconLetter			= "e";
	killicon.AddFont( "gmdm_aug", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end

SWEP.Base						= "gmdm_sniperbase";
SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_aug.mdl"

SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Recoil				= 2.63;
SWEP.Primary.Damage				= 35;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.03;
SWEP.Primary.Delay				= 0.15;
SWEP.StopIronsightsAfterShot	= false;

SWEP.Primary.Automatic			= true;

SWEP.ScopeTime					= 0.2;

SWEP.IronsightAccuracy			= 2.2; -- what to divide spread by to increase accuracy

SWEP.Primary.Sound				= Sound( "Weapon_AUG.Single" );


SWEP.IronSightsPos = Vector (5.6377, -6.6719, 1.5448)
SWEP.IronSightsAng = Vector (0.4569, 1.0484, 0)


SWEP.RunArmOffset = Vector (-4.436, -2.7145, -0.3405)
SWEP.RunArmAngle = Vector (-8.0181, -53.2216, 7.3013)
