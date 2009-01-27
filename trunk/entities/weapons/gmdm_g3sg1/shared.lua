
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 80
	SWEP.PrintName			= "G3 SG1";		
	SWEP.Slot				= 3;
	SWEP.SlotPos			= 6;
	SWEP.ViewModelFlip		= true;
	
	SWEP.IconLetter			= "i";
	killicon.AddFont( "gmdm_g3sg1", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end

SWEP.Base						= "gmdm_sniperbase";
SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel					= "models/weapons/w_snip_g3sg1.mdl"

SWEP.Primary.ClipSize			= 20;
SWEP.Primary.Recoil				= 0.55;
SWEP.Primary.Damage				= 20;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.08;
SWEP.Primary.Delay				= 0.1;
SWEP.StopIronsightsAfterShot	= false;

SWEP.ScopeTime					= 0.35;

SWEP.IronsightAccuracy			= 8.5; -- what to divide spread by to increase accuracy

SWEP.Primary.Sound				= Sound( "Weapon_G3SG1.Single" );

SWEP.IronSightsPos = Vector (4.959, -10.2188, 2.4821)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector (-4.436, -2.7145, -0.3405)
SWEP.RunArmAngle = Vector (-8.0181, -53.2216, 7.3013)
