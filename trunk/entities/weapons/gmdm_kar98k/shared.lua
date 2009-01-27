if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= false; -- HVA Specific
SWEP.ViewModelFlip				= false;
SWEP.ViewModelFOV				= 50;

SWEP.ViewModel					= "models/weapons/v_k98.mdl"
SWEP.WorldModel					= "models/weapons/w_k98.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Kar.Shoot" );
SWEP.Primary.Recoil				= 5.5;
SWEP.Primary.Damage				= 60;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.009;
SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Delay				= 1.0;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "ar2";
SWEP.IronsightAccuracy			= 2.3;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.6;

SWEP.RunArmOffset = Vector (10.4268, 0.6154, -0.5153)
SWEP.RunArmAngle = Vector (-4.1586, 48.5377, -1.9256)

SWEP.HasIronsights				= true; -- HVA Specific


SWEP.IronSightsPos = Vector (-6.6948, 16.2026, 3.378)
SWEP.IronSightsAng = Vector (0.4226, -0.0099, 0)


SWEP.IronsightFOV				= 54; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.9;
SWEP.RunSpeed					= 0.8;
SWEP.IronsightWalkSpeed			= 0.5;
SWEP.IronsightRunSpeed			= 0.5;

if( CLIENT ) then

	SWEP.PrintName			= "KAR98 Karbiner";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "3";
	killicon.AddFont( "weapon_kar98k", "HVADODKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
