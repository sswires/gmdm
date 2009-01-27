if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= false; -- HVA Specific
SWEP.ViewModelFlip				= false;
SWEP.ViewModelFOV				= 60;

SWEP.ViewModel					= "models/weapons/v_mp44.mdl"
SWEP.WorldModel					= "models/weapons/w_mp44.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_MP44.Shoot" );
SWEP.Primary.Recoil				= 5.5;
SWEP.Primary.Damage				= 45;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.06;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.12;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.3;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.6;

SWEP.RunArmOffset = Vector (10.4268, 0.6154, -0.5153)
SWEP.RunArmAngle = Vector (-4.1586, 48.5377, -1.9256)

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronSightsPos 				= Vector (-3.6395, -6.0663, 1.2509)
SWEP.IronSightsAng 				= Vector (0.2896, 0.3334, -0.2487)
SWEP.IronsightFOV				= 54; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.9;
SWEP.RunSpeed					= 0.8;
SWEP.IronsightWalkSpeed			= 0.5;
SWEP.IronsightRunSpeed			= 0.5;

if( CLIENT ) then

	SWEP.PrintName			= "MP44";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "3";
	killicon.AddFont( "weapon_mp44", "HVADODKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
