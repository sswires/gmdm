if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= false; -- HVA Specific
SWEP.ViewModelFlip				= false;
SWEP.ViewModelFOV				= 50;

SWEP.ViewModel					= "models/weapons/v_mp40.mdl"
SWEP.WorldModel					= "models/weapons/w_mp40.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_MP40.Shoot" );
SWEP.Primary.Recoil				= 0.5;
SWEP.Primary.Damage				= 15;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.07;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.10;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 2.3;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.6;

SWEP.RunArmOffset = Vector (10.4268, 0.6154, -0.5153)
SWEP.RunArmAngle = Vector (-4.1586, 48.5377, -1.9256)

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (-4.4659, 25.2161, 1.5477)
SWEP.IronSightsAng = Vector (0.4629, -0.0843, 0)

SWEP.IronsightFOV				= 54; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.9;
SWEP.RunSpeed					= 0.8;
SWEP.IronsightWalkSpeed			= 0.5;
SWEP.IronsightRunSpeed			= 0.5;

if( CLIENT ) then

	SWEP.PrintName			= "MP40";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "3";
	killicon.AddFont( "weapon_mp44", "HVADODKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
