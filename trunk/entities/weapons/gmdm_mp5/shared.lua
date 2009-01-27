if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel					= "models/weapons/w_smg_mp5.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_MP5Navy.Single" );
SWEP.Primary.Recoil				= 0.25;
SWEP.Primary.Damage				= 8;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.07;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 1.6;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.3;

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronSightsPos 				= Vector (4.7375, -3.0969, 1.7654)
SWEP.IronSightsAng 				= Vector (1.541, -0.1335, -0.144)
SWEP.IronsightsFOV				= 50; -- HVA Specific



SWEP.RunArmOffset = Vector (-10.3152, -6.2426, 4.431)
SWEP.RunArmAngle = Vector (-31.4844, -43.188, 11.6674)


-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "MP5 Navy";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "x";
	killicon.AddFont( "gmdm_mp5", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
