if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel					= "models/weapons/w_smg_tmp.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_TMP.Single" );
SWEP.Primary.Recoil				= 0.01;
SWEP.Primary.Damage				= 5.2;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.153;
SWEP.Primary.ClipSize			= 25;
SWEP.Primary.Delay				= 0.032;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.0;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.3;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (5.2182, -3.3058, 2.5587)
SWEP.IronSightsAng = Vector (0.6118, -0.144, 0.3591)


SWEP.RunArmOffset = Vector (0.6527, -0.0462, -2.3717)
SWEP.RunArmAngle = Vector (-4.6183, -51.9525, 27.1546)


SWEP.IronsightsFOV				= 60; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "Tactical Machine Pistol";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "d";
	killicon.AddFont( "gmdm_tmp", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
